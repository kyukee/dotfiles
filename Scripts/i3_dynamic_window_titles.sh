#!/bin/bash

# using ipc events to change the title of the currently active window

NO_FOCUS='<span foreground="#EEEECC" weight="bold">▌</span> <span foreground="#EEEECC">%title</span>'
FOCUS='<span foreground="#EEEECC" weight="bold">•</span> <span foreground="#EEEECC">%title</span>'

# the event used is 'binding', which is keyboard events
# 'window' events should be better, but it is constantly sending events and refreshing the window
i3-msg -t subscribe -m '[ "binding" ]' | while read line ; do
	# This will disable the borders on all other windows
	i3-msg --quiet "[class="^.*"] title_format $NO_FOCUS";
	# set the border
	i3-msg --quiet "title_format $FOCUS";
done
