#!/bin/bash
# -*- mode:sh -*-

#-------------------------------------------------------

# add handler for tray icon exit
yad_rclone_on_exit() {

    # unmount all remotes
    yad_rclone_remote_1_exit

    # kill yad
    pkill -f "Notification tool for rclone mounted cloud folders"
}

#-------------------------------------------------------

# ----------- Remote 1 --------------
REMOTE1_NAME="Google Drive - Work"
REMOTE1_FOLDER_CLOUD="IST"
REMOTE1_FOLDER_LOCAL="$HOME/Cloud/IST"
# ------------------------------------

yad_rclone_remote_1_bi_sync() {
    $HOME/Scripts/rclonesync-cron.sh &
}

yad_rclone_remote_1_mount() {
    rclone mount --daemon --poll-interval 5m0s --allow-non-empty --vfs-cache-mode writes "$REMOTE1_NAME:$REMOTE1_FOLDER_CLOUD" "$REMOTE1_FOLDER_LOCAL" &
}

yad_rclone_remote_1_unmount() {
    pkill -f "rclone"
}

yad_rclone_remote_1_toggle_mount() {
    FOLDER_MOUNTED="$(cat /proc/mounts | grep $REMOTE1_FOLDER_LOCAL | wc -l)"

    if [ "$FOLDER_MOUNTED" -eq 0 ]; then
        yad_rclone_remote_1_mount
    else
        yad_rclone_remote_1_unmount
    fi
}

yad_rclone_remote_1_open() {
    xdg-open "$HOME/Cloud/IST"
}

yad_rclone_remote_1_exit() {
    FOLDER_MOUNTED="$(cat /proc/mounts | grep $REMOTE1_FOLDER_LOCAL | wc -l)"

    if [ "$FOLDER_MOUNTED" -ne "0" ]; then
        yad_rclone_remote_1_unmount
    fi
}

#-------------------------------------------------------

export -f yad_rclone_on_exit

export REMOTE1_NAME
export REMOTE1_FOLDER_CLOUD
export REMOTE1_FOLDER_LOCAL

export -f yad_rclone_remote_1_bi_sync
export -f yad_rclone_remote_1_mount
export -f yad_rclone_remote_1_unmount
export -f yad_rclone_remote_1_toggle_mount
export -f yad_rclone_remote_1_open
export -f yad_rclone_remote_1_exit

#-------------------------------------------------------

yad --notification             \
    --image='weather-overcast' \
    --text='Notification tool for rclone mounted cloud folders' \
    --command="echo 'Button pressed. If there is no command, the default action is to quit." \
    --menu="-- 1 -- $REMOTE1_NAME|\
Remote 1: Bi-directional Sync!bash -c yad_rclone_remote_1_bi_sync|\
Remote 1: Open mount folder location!bash -c yad_rclone_remote_1_open|\
Remote 1: Toggle mounted folder!bash -c yad_rclone_remote_1_toggle_mount|\
|\
Quit!bash -c yad_rclone_on_exit" &

# --menu='STRING'
# Set popup menu for notification icon.
# STRING must be in form name1[!action1[!icon1]]|name2[!action2[!icon2]]....
# Empty name add separator to menu.
# Separator character for values (e.g. `|') sets with --separator argument.
# Separator character for menu items (e.g. `!') sets with --item-separator argument.
