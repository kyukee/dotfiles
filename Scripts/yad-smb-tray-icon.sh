#!/bin/bash
# -*- mode:sh -*-

#-------------------------------------------------------

TOOLTIP='Notification tool for mounting smb remote folders'

# add handler for tray icon exit
yad_on_exit_handler() {

    # unmount all remotes
    yad_smb_exit

    # kill yad
    pkill -f $TOOLTIP
}

#-------------------------------------------------------

# ------------------------
MOUNT_FOLDER_REMOTE='//DESKTOP/Anime'
MOUNT_FOLDER_LOCAL='/media/smb'
# ------------------------------------

yad_smb_mount() {
    gksu "mount.cifs $MOUNT_FOLDER_REMOTE $MOUNT_FOLDER_LOCAL"
}

yad_smb_unmount() {
    gksu "umount $MOUNT_FOLDER_LOCAL"
}

yad_smb_toggle_mount() {
    FOLDER_MOUNTED="$(ls -A $MOUNT_FOLDER_LOCAL)"

    if [ -z "$FOLDER_MOUNTED" ]; then
        yad_smb_mount
    else
        yad_smb_unmount
    fi
}

yad_smb_open_folder() {
    xdg-open "$MOUNT_FOLDER_LOCAL"
}

yad_smb_exit() {
    FOLDER_MOUNTED="$(ls -A $MOUNT_FOLDER_LOCAL)"

    if [ "$FOLDER_MOUNTED" -ne "0" ]; then
        yad_smb_unmount
    fi
}

#-------------------------------------------------------

export TOOLTIP

export -f yad_on_exit_handler

export REMOTE1_NAME
export REMOTE1_FOLDER_CLOUD
export REMOTE1_FOLDER_LOCAL

export -f yad_smb_mount
export -f yad_smb_unmount
export -f yad_smb_toggle_mount
export -f yad_smb_open_folder
export -f yad_smb_exit

#-------------------------------------------------------

yad --notification             \
    --image='weather-overcast' \
    --text=$TOOLTIP \
    --command="echo 'Button pressed. If there is no command, the default action is to quit." \
    --menu="Toggle mounted folder!bash -c yad_smb_toggle_mount|\
Open mount folder location!bash -c yad_smb_open_folder|\
|\
Quit!bash -c yad_on_exit_handler" &

# --menu='STRING'
# Set popup menu for notification icon.
# STRING must be in form name1[!action1[!icon1]]|name2[!action2[!icon2]]....
# Empty name add separator to menu.
# Separator character for values (e.g. `|') sets with --separator argument.
# Separator character for menu items (e.g. `!') sets with --item-separator argument.
