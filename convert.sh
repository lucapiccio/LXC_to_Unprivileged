#!/bin/bash
#
# prerequisites? : apt install lxc libvirt0 libpam-cgroup libpam-cgfs bridge-utils
#
if [ ! "$#" -eq 1 ] ;
then
        echo -e "\e[31mScript for set container as unprivileged \e[39m"
        echo -e "\e[31mGet list of containers: lxc-ls --fancy \e[39m"
        echo -e "\e[31mExemple: sudo ./convert.sh testContainer \e[39m"
        exit 1
fi

CT=$1

## Stopping container
lxc-stop ${CT}

## Set second UID - GID (subuid guid) for root user:
usermod --add-subuids 1258512-1324047 root
usermod --add-subgids 1258512-1324047 root
## Manual set of sub(UID-GID)
#echo "root:1258512:65536" >> /etc/subuid
#echo "root:1258512:65536" >> /etc/subgid

## Set permission for unprivileged container
## all UID and GID are added with the offset of root sub(uid-gid)
subUid=$(grep root /etc/subuid | cut -d: -f2 | head -1)
for i in $(find /var/lib/lxc/${CT}/ -print)
do
        ## Get numeric owner of current file/dir
        actProp=$(stat -c '%u:%g' "$i")
        actPropUid=$(echo ${actProp} | cut -d: -f1)
        actPropGid=$(echo ${actProp} | cut -d: -f2)
        ## Calculed shifted owner
        newUid=$(( $actPropUid + $subUid ))
        newGid=$(( $actPropGid + $subUid ))
        ## set new owner
        if [ $actPropUid -lt 65536 ] ; then
                chown ${newUid}:${newGid} "$i"
        fi
done
chown ${subUid}:${subUid} /var/lib/lxc/${CT}/

## Correct permissions for soft/hard linked path
#chown xymon:adm /var/log/xymon
#chown root:root /etc/xymon
#chown xymon:xymon /var/lib/xymon/tmp
chown root:root /etc/ssl/certs
chown root:root /etc/ssl/private

## TODO integrate the same of python to resolve the problem of hard/soft link:
#stat = os.stat(filename, follow_symlinks=False)
#os.chown(filename, new_uid, new_gid, follow_symlinks=False)
#if not os.path.islink(filename):
#    os.chmod(filenamefp, stat.st_mode)

## Set in /var/lib/lxc/${CT}/config the options for launch unprivileged
echo "lxc.include = /usr/share/lxc/config/debian.userns.conf" >> /var/lib/lxc/${CT}/config
echo "lxc.idmap = u 0 $subUid 65536" >> /var/lib/lxc/${CT}/config
echo "lxc.idmap = g 0 $subUid 65536" >> /var/lib/lxc/${CT}/config

## Enabling user namespaces
echo "kernel.unprivileged_userns_clone=1" > /etc/sysctl.d/80-lxc-userns.conf
sysctl --system

## Starting container
lxc-start ${CT}

exit 0
