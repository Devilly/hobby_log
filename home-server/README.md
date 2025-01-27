# Home server

While installing and using a home server I'm learning quite a bit and this is the place where I'm noting down all relevant information.

* [Ubuntu Server](https://ubuntu.com/download/server) was installed using [Fedora Image Writer](https://github.com/FedoraQt/MediaWriter).
    * Sleep mode was disabled based on [Disable Ubuntu sleep mode](https://en-wiki.ikoula.com/en/Disable_Ubuntu_sleep_mode).
    * Firewall configurations were done with Uncomplicated Firewall (ufw), as described at the [Ubuntu Server documentation - Firewall](https://documentation.ubuntu.com/server/how-to/security/firewalls/).
* To use the NVIDIA GeForce GTX 1060 6GB graphics card drivers needed to be installed.
    * Docs for the system itself: [NVIDIA Driver Installation for Ubuntu](https://docs.nvidia.com/datacenter/tesla/driver-installation-guide/index.html#ubuntu).
        * Once the drivers are installed the command `nvidia-smi` should give information about the GPU and its capabilities.
    * Docs to use the GPU from within Docker containers: [Installing the NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html).
* Investigation of system load can be done with several tools:
    * Metrics excluding GPU: [htop](https://github.com/htop-dev/htop).
    * Fancier metrics excluding GPU: [btop](https://github.com/aristocratos/btop).
        * [GPU compatibility](https://github.com/aristocratos/btop?tab=readme-ov-file#gpu-compatibility) can be added by compiling yourself.
    * Metrics just about the GPU: [NVTOP](https://github.com/Syllo/nvtop).
* Showing system information on login (SSH) is done by using [fastfetch](https://github.com/fastfetch-cli/fastfetch), which is a fancier version of [neofetch](https://github.com/dylanaraps/neofetch), by calling it from ` ~/.bash_profile`. 

