#!/bin/bash

if pidof -o %PPID -x “$(basename $0)”; then
    exit 1
fi

rclonesync "$HOME/Cloud/IST" "google_drive_work:IST" --rclone-args --fast-list --drive-chunk-size 64M --drive-skip-gdocs > "$HOME/.rclonesyncwd/last_run.log"

RET_VAL=$?

if [ $RET_VAL -ne 0 ]; then
    notify-send "Synchronization Failed" "An error ocurred. Check the logs for more info: ~/.rclonesyncwd" --app-name="rclonesync" --expire-time=2000
else
    notify-send "Synchronization Complete" "Your local and remote folders were synchronized successfuly" --app-name="rclonesync" --expire-time=2000
fi
