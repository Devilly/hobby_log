# Raspberry Pi monitoring e-paper screen

My Raspberry Pi sometimes fails on me without me knowing and I just bought an e-paper display so I came up with the idea of doing some kind of monitoring on the display.

The commands needed to setup the Python environment are as follows:

```bash
python -m venv .venv --system-site-packages

source .venv/bin/activate

pip install -r requirements.txt
```

After that a conjob can be defined with, in my case:

```*/30 * * * * cd /home/rpi/hobby_log/raspberry-pi-monitoring-e-paper/ && ./monitoring.sh```

## References
* [2.13inch e-Paper HAT Manual](https://www.waveshare.com/wiki/2.13inch_e-Paper_HAT_Manual#Overview)