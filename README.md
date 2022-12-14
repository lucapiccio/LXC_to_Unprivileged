# LXC_to_Unprivileged
Script to convert an lxc container from privileged to unprivileged

This script convert privileged container created by root in standard path /var/lib/lxc/ to unprivileged without move or copy the storage and using a root subuid instead normal user to grant direct backward compatibility.

## Installation
```
git clone https://github.com/lucapiccio/LXC_to_Unprivileged.git
cd LXC_to_Unprivileged
sudo chmod 755 ./convert.sh
```

## Execution
Need execution as root user or with sudo
```
sudo ./convert.sh nameofconainer
```
This also replace the fuidshift of Ubuntu LXD for all Debian based distribution

## Apparmor
Is necessary to update the default config for AppArmor LXC
```
cat <<EOF >> /etc/lxc/default.conf

lxc.apparmor.allow_incomplete = 1
EOF
```
```
cat <<EOF >> /etc/lxc/default-privileged.conf

lxc.apparmor.allow_incomplete = 1
EOF
```

### Note for debian version
This script is valid for debian 10 / 11. For older debian is necessary change Apparmor variable:
```
lxc.apparmor.allow_incomplete = 1
```
to
```
lxc.aa_allow_incomplete = 1
```

## Enabling swap and memory cgroup
If you want to activate cgroup for memory and swap please change in /etc/default/grub:
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet"
```
to
```
GRUB_CMDLINE_LINUX_DEFAULT="cgroup_enable=memory swapaccount=1 quiet"
```
