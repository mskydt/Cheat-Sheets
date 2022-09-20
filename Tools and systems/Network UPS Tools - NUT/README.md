# Network UPS Tools - NUT
Set-up guidance and configuration files for my implementation of NUT.

## Introduction
To avoid problems with possible power surges and power outages impacting my home lab, I decided to implement a UPS.
I have a Home Assistant VM on my Proxmox cluster with an attached Conbee II and I wanted to protect this specifically. It seems that it's rather sensitive to sudden power outages. So the target was to have a solution that would automatically and gracefully shut down VMs on my Proxmox cluster, then the hosts themselves as well as my Synology NAS. My main switch is also connected to the UPS.
The software solution I have implemented to achieve this, is NUT - Network UPS Tools.
My fiber modem is located somewhere else in my house, and another UPS might be added later for this.

Configurations are:
- NUT Server - a Raspberry Pi 3B
- NUT Client - a Proxmox host (two of them)
- NUT Client - a Synology Diskstation

## References
Full documentation  
https://networkupstools.org/

Techno Tims "Network UPS Tools (NUT Server) Ultimate Guide" on Youtube and his corresponding blog post.

Youtube: https://youtu.be/vyBP7wpN72c  
Blog: https://docs.technotim.live/posts/NUT-server-guide/  

## Testing a set-up with both NUT server and NUT client
1. Start up multiple terminal windows (e.g. using tmux) and log into server and clients using ssh. Status messages will appear in ssh sessions, but not (for example) if you're logged into the shell on Proxmox directly.
1. Unplug the UPS from LINE POWER and observe status messages on the NUT server and the NUT client.

## TODO for these guides
1. Finetune configurations regarding time to shut down and time to ignore shut down (e.g. with a brief interruption)
1. Actual shutdown of the Synology (right now it just stops services and idles in "ready-to-be-turned-off-mode)
1. Last-minute (just before the battery dies) shut down of the NUT server