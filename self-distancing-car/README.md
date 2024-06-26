# Self distancing car

See below images and/or [this](./video.mp4) video.

<image src="PXL_20230706_160758826.jpg" width="300" />
<image src="PXL_20230706_160714623.jpg" width="300" />
<image src="PXL_20230706_160719625.jpg" width="300" />
<image src="PXL_20230706_160731122.jpg" width="300" />
<image src="PXL_20230706_160930224.jpg" width="300" />

## Code

The code on the hub is [Pybricks](https://pybricks.com/) MicroPython.

[host.py](./host.py) contains the code to run on a pc. [brick.py](./brick.py) has the code to be put on the LEGO hub. This was tested with a hub running Pybricks MicroPython `v1.20.0-23-g6c633a8dd on 2024-04-11`.

The host gives output of the execution in the form of graphs showing data used in the PID algorithm. An example, failing, run can be seen [here](https://github.com/Devilly/hobby_log/raw/master/self-distancing-car/video.mp4) and below are the corresponding graphs.

<image src="./graphs.png" width="300" />

## References

* [PID Balance+Ball | full explanation & tuning](https://www.youtube.com/watch?v=JFTJ2SS4xyA)
* [RC Submarine 4.0 – blog post series](https://brickexperimentchannel.wordpress.com/rc-submarine-4-0-blog-post-series/)
* [PID controller](https://en.wikipedia.org/wiki/PID_controller)