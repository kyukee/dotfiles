#!/bin/bash

### Mounts a folder where you can browse upnp network files.

MOUNT_DIRECTORY="/media"
MOUNT_FOLDER="upnp"

# Make sure the folder doesnt exist before running the script
# And remember that you need sudo permissions

# alternative method for always running as sudo
# if [ $(id -nu) != root ]; then
#   sudo $0 # Re-run this script as user root
# fi

sudo su <<EOF

cd "$MOUNT_DIRECTORY"
if [ ! -d "$MOUNT_FOLDER" ]; then

    echo '***** No upnp folder detected. Mounting upnp folder... *****'
    
    mkdir "$MOUNT_FOLDER"
    chmod 777 "$MOUNT_FOLDER"
    sudo modprobe fuse
    sudo djmount -o allow_other "$MOUNT_FOLDER"
    #xdg-open "$MOUNT_FOLDER"
else

    echo '***** upnp folder already exists. Attempting to delete... *****'
    
    sudo fusermount -u "$MOUNT_FOLDER"
    rmdir "$MOUNT_FOLDER"
fi

EOF
