#!/bin/bash

perl /path/to/i3subscribe.pl window | while read -r event; do
# This will disable the borders on all other windows
    i3-msg '[class="^.*"] border pixel 0';
# set the border
    i3-msg 'border normal';
done
