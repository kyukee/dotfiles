#!/bin/bash

### Mounts a folder where you can browse smp network files.

MOUNT_FOLDER_REMOTE='//DESKTOP/Anime'
MOUNT_FOLDER_LOCAL='/media/smb'

TMP_RETURN_VAL=0

# Make sure the folder doesnt exist before running the script
# And remember that you need sudo permissions

# alternative method for always running as sudo
# if [ $(id -nu) != root ]; then
#   sudo $0 # Re-run this script as user root
# fi

sudo su <<EOF

if [ -z "$(ls -A $MOUNT_FOLDER_LOCAL)" ]; then
    echo '***** Mounting smb share on $MOUNT_FOLDER_LOCAL... *****'
    # echo 'Note: To connect as a guest, use an empty Windows password. (Just press the return key)'
    mount.cifs $MOUNT_FOLDER_REMOTE $MOUNT_FOLDER_LOCAL -o password=""
    TMP_RETURN_VAL="$?"
else
    echo '***** Unmounting smb share on $MOUNT_FOLDER_LOCAL... *****'
    umount $MOUNT_FOLDER_LOCAL
    pkill -f 'smb'
fi

EOF


# if yad is executed as root, the tray icon is screwed up

if [ ! -z "$(ls -A $MOUNT_FOLDER_LOCAL)" ] && [ "$TMP_RETURN_VAL" -eq 0 ]; then
    yad --notification             \
        --image='weather-overcast' \
        --text='smb' \
        --command="echo 'Button pressed. If there is no command, the default action is to quit." &
fi
