# LXC_to_Unprivileged
Script to convert an lxc container from privileged to unprivileged

This script convert privileged container created by root in standard path /var/lib/lxc/ to unprivileged without move or copy the storage and using a root subuid instead normal user to grant direct backward compatibility.

Need execution as root user or with sudo
sudo ./convert.sh

