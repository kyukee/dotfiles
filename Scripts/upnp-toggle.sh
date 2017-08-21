#!/bin/bash

cd /media
if [ ! -d upnp ]; then
mkdir upnp; chmod 777 upnp
modprobe fuse
echo '    mounting upnp folder'
sudo djmount -o allow_other upnp
#xdg-open upnp
else
sudo fusermount -u upnp
rmdir upnp
echo umounting upnp and rmdir
fi