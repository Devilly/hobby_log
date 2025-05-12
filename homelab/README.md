# Homelab

While installing and using a homelab I'm learning quite a bit and this is the place where I'm noting down all relevant information.

## Machines

The homelab is made up of different machines. Below I've somewhat categorically described specific do's and steps for these.

### Linux

* [Ubuntu Server](https://ubuntu.com/download/server) was installed using [Fedora Image Writer](https://github.com/FedoraQt/MediaWriter).
    * Sleep mode was disabled based on [Disable Ubuntu sleep mode](https://en-wiki.ikoula.com/en/Disable_Ubuntu_sleep_mode).
    * Firewall configurations were done with Uncomplicated Firewall (ufw), as described at the [Ubuntu Server documentation - Firewall](https://documentation.ubuntu.com/server/how-to/security/firewalls/).
* Investigation of system load can be done with several tools:
    * Metrics excluding GPU: [htop](https://github.com/htop-dev/htop).
    * Fancier metrics excluding GPU: [btop](https://github.com/aristocratos/btop).
        * [GPU compatibility](https://github.com/aristocratos/btop?tab=readme-ov-file#gpu-compatibility) can be added by compiling yourself.
    * Metrics just about the GPU: [NVTOP](https://github.com/Syllo/nvtop).
* Showing system information on login (SSH) is done by using [fastfetch](https://github.com/fastfetch-cli/fastfetch), which is a fancier version of [neofetch](https://github.com/dylanaraps/neofetch), by calling it from ` ~/.bash_profile`. 

#### Setup reverse proxy

* [Caddy](https://caddyserver.com/) is used as a reverse proxy to forward traffic to the [Hosting server](#hosting-server).
* Using ethernet instead of Wi-Fi is configured via a [Netplan](https://netplan.io/) file in `/etc/netplan/` which should contain following YAML:

```yaml
network:
    version: 2
    ethernets:
        renderer: networkd
        eth0:
            dhcp4: true
```
* Debugging network connections can be done by...
    * listing the available hardware with [lshw](https://linux.die.net/man/1/lshw).
    * showing the available network interface with `ip link`, see [docs](https://linux.die.net/man/8/ip).

#### Use NVIDIA graphics card

* To use the NVIDIA GeForce GTX 1060 6GB graphics card drivers needed to be installed.
    * Docs for the system itself: [NVIDIA Driver Installation for Ubuntu](https://docs.nvidia.com/datacenter/tesla/driver-installation-guide/index.html#ubuntu).
        * Once the drivers are installed the command `nvidia-smi` should give information about the GPU and its capabilities.
    * Docs to use the GPU from within Docker containers: [Installing the NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html).

### Windows

* Install WSL via [these instructions](https://learn.microsoft.com/en-us/windows/wsl/install).
* Use `Configure startup applications from File Explorer` from [these docs](https://support.microsoft.com/en-us/windows/configure-startup-applications-in-windows-115a420a-0bff-4a6f-90e0-1934c844e473) to get WSL started automatically.
    * Create the shortcut for `C:\Program Files\WSL\wsl.exe`.
* Let Windows Firewall forward incoming message on a port, as described [here](https://wiki.mcneel.com/zoo/window7firewall).
* Let Windows [automatically sign in the admin user](https://learn.microsoft.com/en-us/troubleshoot/windows-server/user-profiles-and-logon/turn-on-automatic-logon#use-registry-editor-to-turn-on-automatic-logon).