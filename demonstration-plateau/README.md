# Demonstration plateau

See below images and/or [this](https://github.com/Devilly/lego_creations/raw/master/demonstration_plateau/PXL_20230614_175337373.TS~3.mp4) video.

<image src="PXL_20230614_175047264.jpg" width="300" />
<image src="PXL_20230614_175055543.jpg" width="300" />
<image src="PXL_20230614_175104730.jpg" width="300" />
<image src="PXL_20230614_175125347.jpg" width="300" />
<image src="PXL_20230614_175133997.jpg" width="300" />
<image src="PXL_20230614_175140405.jpg" width="300" />

## Code

The code is [Pybricks](https://pybricks.com/) MicroPython.

```Python
from pybricks.hubs import InventorHub
from pybricks.pupdevices import Motor
from pybricks.parameters import Port, Button
from pybricks.tools import wait

hub = InventorHub()
motor = Motor(Port.E)

minimum_velocity = 100
velocity_step = 20
desired_velocity = 0

idle_loops = 0

while(True):
    pressed = hub.buttons.pressed()
    
    if(Button.LEFT in pressed and Button.RIGHT in pressed):
        motor.stop()
    elif(Button.LEFT in pressed or Button.RIGHT in pressed):
        if(idle_loops > 0):
            velocity_change = -velocity_step if Button.LEFT in pressed else velocity_step
            desired_velocity += velocity_change
            motor.run(desired_velocity)
        
        idle_loops = 0
    else:
        idle_loops += 1

    print(motor.speed())

    wait(50)
```
