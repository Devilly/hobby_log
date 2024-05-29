# LEGO mounted timelapse

Having a Raspberry Pi 3B+ (determined via `cat /proc/cpuinfo`) as well as a Raspberry Pi Camera Module 3 and not having concrete plans for both I decided to combine these with some LEGO parts to do some learning.

See below images for the gist of it:

<image src="" width="300" />

After having build the setup I followed these steps to get to a timelapse GIF:
1) Connected USB device
1) Used `lsusb` to verify its availability
1) Used `sudo fdisk -l` to find the corresponding partition name, which was `/dev/sda1`
1) First did a manual, temporary, mount via `mount /dev/sda1 /home/rpi/small-usb`
1) After verifying that that worked, added a permanent mount by adding `/dev/sda1 /home/rpi/small-usb ntfs defaults 0 0` to `/etc/fstab`
1) Using crontab configured a cron job to take a picture every minute with `* * * * * /home/rpi/projects/timelapse.sh`, where that file contains following code:

    ```bash
    #!/bin/bash
    rpicam-still -o /home/rpi/small-usb/timelapse/$(date +"%Y-%m-%d_%H-%M-%S-%N").jpg &> /home/rpi/projects/log.txt
    ```
    
1) Being in the directory of the images, created an animated GIF with `convert -delay 10 -loop 0 "./*.jpg" animation.gif`
1) Being in the directory of the images, created an MP4 video with `ffmpeg -r 10 -f image2 -pattern_type glob -i '*.jpg' -s 4608x2592 -vcodec libx264 timelapse.mp4`

1) `* * * * * rpicam-still -o /home/rpi/small-usb/timelapse/$(date +"%Y-%m-%d_%H-%M-%S-%N").jpg`

## References

* [How to List USB Devices Connected to Your Linux System](https://itsfoss.com/list-usb-devices-linux/)
* [How to mount USB drive in Linux](https://linuxconfig.org/howto-mount-usb-drive-in-linux)
* [Time-lapse animations with a Raspberry Pi](https://projects.raspberrypi.org/en/projects/timelapse-setup)
* [An introduction to the Linux /etc/fstab file](https://www.redhat.com/sysadmin/etc-fstab)
* [fstab(5) — Linux manual page](https://man7.org/linux/man-pages/man5/fstab.5.html)
* [ImageMagick cache resource exhausted](https://stackoverflow.com/a/69114403)
* [ImageMagick - Security Policy](https://www.imagemagick.org/script/security-policy.php)