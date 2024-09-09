# Raspberry Pi video recording

Using the same Lego setup as in [LEGO mounted timelapse](../lego-mounted-timelapse/README.md) one can also record videos. Doing that remotely via SSH it's nice if the connection doesn't need to keep open all the time.

To manage that, we can use the [screen](https://ss64.com/bash/screen.html) utility. Step by step starting the video and disconnecting:
1. `screen` to create a new screen session
1. `rpicam-vid -t 240000 -o ./test.h264` to start a recording of four minutes and writing to a file in the current directory.
1. `Ctrl + a` and then `d` to detach from the session.

You can now do whatever you want, even exit the SSH session in case you've done all this via such a session.

To re-attach use `screen -r`. Doing `echo $STY` will show the screen session identifier and blank when not within a screen session.

## References
* [rpicam-vid](https://www.raspberrypi.com/documentation/computers/camera_software.html#rpicam-vid)