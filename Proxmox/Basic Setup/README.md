# Proxmox Basic Setup
Below guide is what I did to get everything up and running. It might not be exactly fits you, but it's a place to start.
There's a paragraph about moving VMs from ESXi to Proxmox which is what I did. Skip that if it doesn't apply.

# Preparation
With my pfSense as a VM on my ESXi, I didn't want to start from scratch on that same NUC. It would cause network unavailability for to long. So with an old decomissioned NUC (i5 CPU, 16GB RAM, 256GB SSD) I set up my first Proxmox node which I named *pve1*.

# Installation
There are lots of guides on how to download the Proxmox ISO, "burn it" to a flash drive and boot into the installation from USB. Google it.

# Configuration
Some topics are detailed and some are just a reminder to do it and where to find it.

## Patch
So the very first thing you need to do is to patch the newly installed node. Proxmox is Linux, so it's pretty much as simple as ```apt update && apt upgrade -y``` in the shell. You can accomplish the exact same in the web GUI in ```Datacenter > node > Updates``` where you can refresh and upgrade - same thing.

Proxmox has a paid repository for software updates which is enabled but inactive by default ... seeing as you do not have a subscription.
So, do this:

1. Go to: ```Datacenter > node > Updates > Repositories```
1. Mark the ```pve-enterprise``` component and click Disable
1. Click Add and select the ```No-subscription``` repository
1. Go to: ```Datacenter > node > Updates``` and do a refresh and upgrade
1. Once the upgrade has finished, the update window will likely suggest that you reboot the node. Do that!

Now your node is now installed and up-to-date. Congratulations.

## Remove local-LVM, resize local and expand storage capacity
Source: NetworkChuck's Youtube video [Virtual Machines Pt. 2 (Proxmox install w/ Kali Linux)](https://www.youtube.com/watch?v=_u8qTN3cCnQ)

1. Goto ```Server view > Datacenter > Storage```
1. Remove ```local-lvm```
1. Select the Proxmox node and goto Shell to execute the following commands:  
```bash
lvremove /dev/pve/data  
lvresize -l +100%FREE /dev/pve/root  
resize2fs /dev/lapper/pve-root
```

That's it - now you have 100% of the free space on the SSD available for VMs. Of course, if you need to have additional drives set up, this is not covered here.

## Check that S.M.A.R.T. is enabled
1. Goto ```Datacenter > local > Edit > content```
1. Verify (and enable if not) that S.M.A.R.T. is activated

## Make it VLAN Aware
1. Set checkbox here: ```Datacenter > node > Network > Linux Bridge > VLAN Aware```

## Add NFS share for backups and ISO's
1. Goto: ```Datacenter > Storage > ADD NFS```

# Migrating VMs from ESXi to Proxmox
I found a few different approaches. The easiest for me was to use CloneZilla:

1. [Download the CloneZilla ISO from here](https://clonezilla.org/downloads.php)

On ESXi
1. Reboot the ESXi VM - just to be sure it's fresh and working well
1. Upload the CloneZilla ISO to a storage location your VMs can access
1. Mount it to the virtual DVD drive of the VM
1. Set the VM to boot into BIOS next time in ESXi settings for the VM
1. Reboot the VM and configure its boot order in BIOS to boot from the DVD drive before the harddrive
1. Reboot the VM
1. Make the correct selections in the CloneZilla interface (set a static IP reachable by the new Proxmox VM, set this VM as the source)

On Proxmox
1. Upload the CloneZilla ISO to a storage location your VMs can access
1. Create a new VM with the same specifications as the source (also, maybe set the disk size 1GB larger - just to be sure)
1. Mount it to the virtual DVD drive of the VM
1. Boot the VM
1. Make the correct selections in the CloneZilla interface (select DHCP networking and point to the static IP set to the ESXi CloneZilla instance, set this VM as the destination)
1. Now let CloneZilla do its work

Wrapping up
1. Keep the ESXi VM shut down - do not start it again
1. Remove the CloneZilla DVD from the VM
1. Start the migrated VM

Everything should be working fine. This process worked fine for me on a couple of Ubuntu VMs as well as my pfSense. If you encounter problems: let the troubleshooting begin!

# Create a cluster
Creating a cluster is pretty straightforward in ```Datacenter > Cluster```. Make sure that networking is in place before you create a cluster - it cannot be changed afterwards. Joining a cluster is also easy - copy-paste the join-information from the cluster to the new node you want to add and ... presto!
As far as I can see, removing a node from a cluster is NOT as easy. But I've seen guides on how to do it.
Node names etc. cannot be reused for replacement nodes - this is very important!

So now we're done with our cluster? Well, not completely. A two-node cluster - which I'm assuming here - has an even number of votes. That's not good. If you have both hosts running and you shut down one, all is good. But you don't have quorum (or the cluster is not "quorate") and you won't be able to start new VMs as they're waiting for the other host to come up. So if you have a power failure and only one host comes up, no VMs will start.

There are two options I considered. I could manipulate the number of votes on one host making the total an uneven number. Instead, though, I decided to install a Raspberry Pi as a QDevice. This devices has a vote and acts as what others might call a "witness server". I found a great Youtube guide by Apalrd's adventures called "SMALL Proxmox CLuster Tips | Quorum and QDevices, Oh my! (+Installing a QDevice on a RasPi)". Awesome title! Find it here:
https://youtu.be/TXFYTQKYlno

Summarizing the steps from the video, which I performed:

```bash
# On the Raspberry Pi
sudo passwd root
sudo nano /etc/ssh/sshd_config
# Uncomment "PermitRootLogin prohibit-password"
# Change to "PermitRootLogin yes"
sudo systemctl restart sshd
sudo apt update && sudo apt upgrade -y
sudo apt install corosync-qnetd corosync-qdevice

# On both of the two Proxmox hosts
apt update
apt install corosync-qdevice

# On one of the two Proxmox hosts
pvecm qdevice setup IP-OF-RASPBERRY-PI -f
# When prompted, provide root credentials and let it configure

# On the Raspberry Pi
sudo nano /etc/ssh/sshd_config
# Comment "PermitRootLogin yes" ... we don't want root ssh access activated
sudo systemctl restart sshd
```

**Be aware**: If the Raspberry Pi fails, you want to get it (the QDevice) disconneted from the cluster or there will be trouble when we need to restart the hosts. Do that with the following, should the Raspberry Pi need to be reinstalled after failure (SD Cards do fail from time to time...):

```bash
# On a Proxmox host
pvecm qdevice remove
```
**WARNING: If you want to add another host (a third!), remove the QDevice FIRST!**

# Backup
Proxmox has a simple and basic backup solution built-in for VMs and containers. There are no options for incremental backups - it's full every time and create a simple file that can be restored from.
For my homelab, that's okay. However, Proxmox do have a solution called *Proxmox Backup Server* which has all the bells and whistles when it comes to backup. You can download the [ISO from Proxmox here](https://www.proxmox.com/en/proxmox-backup-server). I haven't experimented with Proxmox Backup Server yet.
