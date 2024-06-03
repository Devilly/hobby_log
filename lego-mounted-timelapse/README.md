# LEGO mounted timelapse

Having a Raspberry Pi 3B+ (determined via `cat /proc/cpuinfo`) as well as a Raspberry Pi Camera Module 3 and not having concrete plans for both I decided to combine these with some LEGO parts to do some learning.

See below images for the gist of it:

<image src="PXL_20240603_180951494.jpg" width="300" />
<image src="PXL_20240603_181025940.jpg" width="300" />
<image src="PXL_20240603_181116426.jpg" width="300" />
<image src="PXL_20240603_181134576.jpg" width="300" />

After having build the setup I followed these steps to get to a timelapse GIF:
1) Connected USB device
1) Used `lsusb` to verify its availability
1) Used `sudo fdisk -l` to find the corresponding partition name, which was `/dev/sda1`
1) First did a manual, temporary, mount via `mount /dev/sda1 /home/rpi/small-usb`
1) After verifying that that worked, added a permanent mount by adding `/dev/sda1 /home/rpi/small-usb ntfs defaults 0 0` to `/etc/fstab`
1) Using crontab configured a cron job to take a picture every minute with `* * * * * /home/rpi/projects/timelapse.sh`, where that file contains following code:

    ```bash
    #!/bin/bash
    DATE=$(date +"%Y-%m-%d_%H-%M-%S-%N")
    LOG_FILE='/home/rpi/projects/log.txt'

    cat << END >> $LOG_FILE
    ##### SNAP $DATE

    END

    rpicam-still --nopreview -o /home/rpi/small-usb/timelapse/$DATE.jpg >> $LOG_FILE 2>&1

    echo $'\n' >> $LOG_FILE
    ```

    1) Used `watch ls` to monitor the generation of new image files
    1) The generated image files can be found in the [test-run](./test-run/) directory

1) Copied the resulting files to my Windows 10 computer, using `scp -r rpi@rpi:~/small-usb/timelapse/* .`
1) With [WSL](https://learn.microsoft.com/en-us/windows/wsl/) being in the directory where the files were copied, created an animated GIF with `convert -delay 30 -loop 0 "./*.jpg" animation.gif`

    1) The result is as follows:

        <image src="./test-run/animation.gif" width="300" />

    1) `/etc/ImageMagick-6/policy.xml` was updated to increase the allowed memory usage. In specific this line was altered: `<policy domain="resource" name="memory" value="13GiB"/>`

1) With WSL being in the directory where the files were copied, created a MP4 video with `ffmpeg -framerate 3.3 -pattern_type glob -i '*.jpg' video.mp4`

    1) The result can be seen [here](./test-run/video.mp4)

## References

* [How to List USB Devices Connected to Your Linux System](https://itsfoss.com/list-usb-devices-linux/)
* [How to mount USB drive in Linux](https://linuxconfig.org/howto-mount-usb-drive-in-linux)
* [Time-lapse animations with a Raspberry Pi](https://projects.raspberrypi.org/en/projects/timelapse-setup)
* [An introduction to the Linux /etc/fstab file](https://www.redhat.com/sysadmin/etc-fstab)
* [fstab(5) — Linux manual page](https://man7.org/linux/man-pages/man5/fstab.5.html)
* [ImageMagick cache resource exhausted](https://stackoverflow.com/a/69114403)
* [ImageMagick - Security Policy](https://www.imagemagick.org/script/security-policy.php)