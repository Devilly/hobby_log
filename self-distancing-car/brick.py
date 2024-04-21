from pybricks.hubs import InventorHub
from pybricks.pupdevices import Motor, UltrasonicSensor
from pybricks.parameters import Button, Color, Direction, Port, Side, Stop
from pybricks.tools import wait, StopWatch

from usys import stdin, stdout

hub = InventorHub()
hub.light.on(Color.GREEN)

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

hub.display.animate([
    [
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [80, 0, 20, 0, 20]
    ],
    [
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [20, 0, 80, 0, 20]
    ],
    [
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [20, 0, 20, 0, 80]
    ]
], 500)

def receive(number_of_bytes):
    stdout.buffer.write(b"rdy")

    return stdin.buffer.read(number_of_bytes)

kp = float(receive(5))
ki = float(receive(5))
kd = float(receive(5))

hub.display.icon([
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 50],
    [0, 0, 0, 50, 0],
    [50, 0, 50, 0, 0],
    [0, 50, 0, 0, 0]
])

distance_setpoint = 200

stopWatch = StopWatch()

# generic insights
last_time = stopWatch.time()

# ki
i_accumulated_error = 0

# kd
d_last_time = stopWatch.time()
d_difference_time = 0

d_last_error = 0

d_reading_count = 0
derivative_input = 0

while(True):
    wait(20)

    time = stopWatch.time()
    difference_time = time - last_time

    error = distance.distance() - distance_setpoint

    proportial_input = error * kp

    i_accumulated_error += error
    integral_input = i_accumulated_error * ki

    d_reading_count += 1
    if(d_reading_count % 15 == 0):
        d_time = stopWatch.time()
        d_difference_error = error - d_last_error
        d_difference_time = time - d_last_time

        derivative_input = (d_difference_error / d_difference_time) * kd

        d_last_error = error
        d_last_time = d_time

    combined_input = proportial_input + integral_input + derivative_input

    stdout.buffer.write(
        str(difference_time)
        + ";" + str(error)
        + ";" + str(proportial_input)
        + ";" + str(integral_input)
        + ";" + str(derivative_input)
        + ";" + str(combined_input)
        + "#")

    for motor in motors:
        motor.run(combined_input)

    last_time = time
