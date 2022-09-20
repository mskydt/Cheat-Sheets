Restart upsd with "upsd -c reload"
***********************

THIS FILE HAS NOT BEEN UPDATED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


# NUT Client - Synology Diskstation

## Introduction and overview
The NUT client is a device that via a network connection gets its information from the NUT server.
These config files are used on my Synology Diskstation. The device already uses NUT for the built-in UPS features, but we need to configure a few things to get it working as a NUT client connecting to our NUT server.

## References
https://tellini.info/2014/09/connecting-a-synology-diskstation-to-a-nut-server/

## Preparation
We need to prepare a few things, namely:
1. Update the Diskstation through the web interface.
1. Enable ssh access (remember to disable it when we're done setting it up)
1. Install ```nano``` on the device ... because I'm not very well-versed in vim, which is actually installed per default. Use this guide: https://anto.online/guides/how-to-install-nano-on-your-synology-nas/

## Configuration
The configuration files are located in ```/usr/syno/etc/ups/``` on a Synology.

### synoups.conf
Config stuff. Make it point to the NUT server IP a couple of places.

### ups.conf
Copy the information from the ```ups.conf``` of the NUT server.

### upsd.conf
Interface to listen on.

### upsd.users
As on the NUT server.

### upsmon.conf
Where is the NUT server and also settings for the client.

### upssched-cmd
Logging commands

### upssched.conf
Script to run on the server. What to do when on battery and when ... etc.

## Getting ready to test
Now that all config files have been created, restart the service:
```bash
sudo upsd -c reload
```

## Test it
Check if you get valid configuration settings and information from the UPS:
```bash
upsc ups@IP-OF-NUT-SERVER
```
