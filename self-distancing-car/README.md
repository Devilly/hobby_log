# Self distancing car

<image src="PXL_20230706_160758826.jpg" width="300" />
<image src="PXL_20230706_160714623.jpg" width="300" />
<image src="PXL_20230706_160719625.jpg" width="300" />
<image src="PXL_20230706_160731122.jpg" width="300" />
<image src="PXL_20230706_160930224.jpg" width="300" />

## Code

The code on the hub is [Pybricks](https://pybricks.com/) MicroPython.

This first version keeps the car a specified number of millimeters from the object in front of it, while using a margin to prevent it from microadjusting all the time.

```Python
from pybricks.hubs import InventorHub
from pybricks.pupdevices import Motor, UltrasonicSensor
from pybricks.parameters import Button, Color, Direction, Port, Side, Stop
from pybricks.robotics import DriveBase
from pybricks.tools import wait, StopWatch

from umath import fabs, copysign

hub = InventorHub()

# left side
motor_right_back = Motor(Port.C)
motor_right_front = Motor(Port.E)

# right side
motor_left_back = Motor(Port.B, Direction.COUNTERCLOCKWISE)
motor_left_front = Motor(Port.D, Direction.COUNTERCLOCKWISE)

distance = UltrasonicSensor(Port.F)

motors = [
    motor_right_back,
    motor_right_front,
    motor_left_back,
    motor_left_front
]

desired_distance = 200
motor_speed = 300

while(True):
    distance_difference = distance.distance() - desired_distance
    print(distance_difference)

    if(fabs(distance_difference) > 25):
        for motor in motors:
            motor.run(copysign(motor_speed, distance_difference))
    else:
        for motor in motors:
            motor.brake()
```

After this I restarted the software implementation with the P part of a PID controller.

```Python
from pybricks.hubs import InventorHub
from pybricks.pupdevices import Motor, UltrasonicSensor
from pybricks.parameters import Button, Color, Direction, Port, Side, Stop
from pybricks.robotics import DriveBase
from pybricks.tools import wait, StopWatch

from umath import fabs, copysign

hub = InventorHub()

# left side
motor_right_back = Motor(Port.C)
motor_right_front = Motor(Port.E)

# right side
motor_left_back = Motor(Port.B, Direction.COUNTERCLOCKWISE)
motor_left_front = Motor(Port.D, Direction.COUNTERCLOCKWISE)

distance = UltrasonicSensor(Port.F)

motors = [
    motor_right_back,
    motor_right_front,
    motor_left_back,
    motor_left_front
]

distance_setpoint = 200

kp = 10

while(True):
    error = distance.distance() - distance_setpoint

    for motor in motors:
        motor.run(error * kp)

    wait(20)
```

That worked fine. Next step is adding the I...

```Python
from pybricks.hubs import InventorHub
from pybricks.pupdevices import Motor, UltrasonicSensor
from pybricks.parameters import Button, Color, Direction, Port, Side, Stop
from pybricks.robotics import DriveBase
from pybricks.tools import wait, StopWatch

from umath import fabs, copysign

hub = InventorHub()

# left side
motor_right_back = Motor(Port.C)
motor_right_front = Motor(Port.E)

# right side
motor_left_back = Motor(Port.B, Direction.COUNTERCLOCKWISE)
motor_left_front = Motor(Port.D, Direction.COUNTERCLOCKWISE)

distance = UltrasonicSensor(Port.F)

motors = [
    motor_right_back,
    motor_right_front,
    motor_left_back,
    motor_left_front
]

distance_setpoint = 200

accumulated_error = 0

kp = 10
ki = .1

while(True):
    error = distance.distance() - distance_setpoint
    accumulated_error += error

    for motor in motors:
        motor.run(error * kp +
        accumulated_error * ki)

    wait(20)
```

It works while adding some overshoot in the process. Now adding the D. But it's better to make the PID constants configurable for a faster debug/test experience. Making a script that talks to the hub, passing the constants as well as receiving output from the hub for inspection purposes. Continuing this documentation in a [Jupyter Notebook](./implementation.ipynb).

## References

* [PID Balance+Ball | full explanation & tuning](https://www.youtube.com/watch?v=JFTJ2SS4xyA)
* [RC Submarine 4.0 – blog post series](https://brickexperimentchannel.wordpress.com/rc-submarine-4-0-blog-post-series/)
* [PID controller](https://en.wikipedia.org/wiki/PID_controller)