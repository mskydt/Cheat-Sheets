# NUT Client - Proxmox host

## Introduction and overview
The NUT client is a device that via a network connection gets its information from the NUT server.
These config files are used on my Proxmox hosts, but can be easily deployed on any machine. Sending a shutdown message to a Proxmox host will start the graceful shutdown of VMs before the host itself.

## Installation
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install nut-client
```

## Configuration
Prepare the configuration directory by moving existing files to a "examples" subfolder and create clean new ones:

```bash
cd /etc/nut
mkdir examples
mv *.conf examples
mv *.users exaples
```

### nut.conf
"netclient" is the setting for this NUT client.

### upsmon.conf
Where is the NUT server and also settings for the client.

### upssched-cmd
Logging commands

### upssched.conf
Script to run on the server. What to do when on battery and when ... etc.

## Getting ready to test
Now that all config files have been created, do a reboot.

## Test it
Check if you get valid configuration settings and information from the UPS:
```bash
upsc ups@IP-OF-NUT-SERVER
```

## Secure it
The files contain sensitive information such as password of the admin user. So, protect the files like this:
```bash
sudo chown nut:nut /etc/nut/*
sudo chmod 640 /etc/nut/upsd.users /etc/nut/upsmon.conf
```