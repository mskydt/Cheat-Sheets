# NUT Server - Raspberry Pi

## Introduction and overview
The NUT server is the device to which the UPS USB cable is attached. This is the master which controls how the clients (or slaves) behave during shifts from LINE og BATTERY and vice versa.
I've installed this on a Raspberry Pi that also serves as Qdevice ("Quorum witness") for my two-host Proxmox cluster. Do not use a VM on a host that you plan to shut down with the software as a NUT Server.

## References
- https://wiki.ledhed.net/index.php?title=Raspberry_Pi_NUT_Server  
- https://melgrubb.com/2016/12/11/rphs-v2-ups/  
- https://www.howtoraspberry.com/2020/11/how-to-monitor-ups-with-raspberry-pi/  
Also, check my overall readme for NUT.

## Installation
Attach the USB cable from the UPS and reboot the machine.

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install nut nut-server nut-client
```

## Configuration
Prepare the configuration directory by moving existing files to a "examples" subfolder and create clean new ones:

```bash
cd /etc/nut
mkdir examples
mv *.conf examples
mv *.users exaples
```

Get information to start populating ```ups.conf``` with this command. It's a good idea to call name the UPS as ```[ups]``` in ```ups.conf``` as it will be much easier to configure when it comes to the Synology Diskstation.

```bash
sudo nut-scanner -U
```

### hosts.conf
The name defined here will be used in the web interface and nowhere else - I think.

### nut.conf
"netserver" is the setting for the NUT server.

### upsd.conf
Interface and port to listen for connections on.

### upsd.users
Users are "created" here. Remember to update "secret" to your own password. It will be hardcoded in these config files (look for "secret" as keyword). Use a MAXIMUM of 8 characters!

### upsmon.conf
Which UPS(es) should be monitored?

### upssched.conf
Script to run on the server

### upsset.conf
This file is relevant when the web interface (NUT CGI SERVER) goes up.
Use the guide here: https://docs.technotim.live/posts/NUT-server-guide/#nut-cgi-server

## Getting ready to test
Now that all config files have been created, do a reboot:
```bash
sudo reboot now
```

## Test it
Check if you get valid configuration settings and information from the UPS:
```bash
upsc ups@localhost
```

## Secure it
The files contain sensitive information such as password of the admin user. So, protect the files like this:
```bash
sudo chown nut:nut /etc/nut/*
sudo chmod 640 /etc/nut/upsd.users /etc/nut/upsmon.conf
```