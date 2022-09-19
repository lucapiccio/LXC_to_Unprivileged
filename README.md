# LXC_to_Unprivileged
Script to convert an lxc container from privileged to unprivileged

This script convert privileged container created by root in standard path /var/lib/lxc/ to unprivileged without move or copy the storage and using a root subuid instead normal user to grant direct backward compatibility.

Need execution as root user or with sudo
```
sudo ./convert.sh
```
This also replace the fuidshift of Ubuntu LXD for all Debian based distribution

Note for debian version:
This script is valid for debian 10 / 11. For older debian is necessary change Apparmor variable:
```
lxc.apparmor.allow_incomplete = 1
```
to
```
lxc.aa_allow_incomplete = 1
```
