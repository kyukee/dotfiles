#!/bin/bash

### Mounts a folder where you can browse smp network files.

MOUNT_FOLDER_REMOTE='//DESKTOP/Anime'
MOUNT_FOLDER_LOCAL='/media/smb'


# Make sure the folder doesnt exist before running the script
# And remember that you need sudo permissions

# alternative method for always running as sudo
# if [ $(id -nu) != root ]; then
#   sudo $0 # Re-run this script as user root
# fi

sudo su <<EOF

if [ -z "$(ls -A $MOUNT_FOLDER_LOCAL)" ]; then
    echo '***** Mounting smb share on $MOUNT_FOLDER_LOCAL... *****'
    echo 'Note: To connect as a guest, use an empty Windows password. (Just press the return key)'
    mount.cifs $MOUNT_FOLDER_REMOTE $MOUNT_FOLDER_LOCAL

else
    echo '***** Unmounting smb share on $MOUNT_FOLDER_LOCAL... *****'
    umount $MOUNT_FOLDER_LOCAL

fi

EOF


if [ ! -z "$(ls -A $MOUNT_FOLDER_LOCAL)" ]; then
    yad --notification             \
        --image='weather-overcast' \
        --text='smb' \
        --command="echo 'Button pressed. If there is no command, the default action is to quit." &

else
    pkill -f 'smb'

fi
