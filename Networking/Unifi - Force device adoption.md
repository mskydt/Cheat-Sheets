# Unifi - Force device adoption

1. Factory reset the device
1. Obtain the IP of the device 
1. SSH into the device using default credentials (username: ubnt, password: ubnt) 
1. Execute command: ``set-default
``
1. Wait for the device to reboot 
1. SSH into the device again 
1. Execute command: ``
set-inform http://(IP-adress of the controller):8080/inform 
``
1. Log out of the device 

If you have the controller's *Devices page* open at the same time you should see the device appear as ready for adoption immediately.  