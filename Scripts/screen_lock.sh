#!/bin/sh -e

# Lock screen displaying this image.
i3lock --blur=12 --composite --clock --ignore-empty-password --timecolor=ffffffff --timesize=140 --datecolor=ffffffff --datesize=36 --datepos tx:ty+100 --redraw-thread

# Turn the screen off after a delay.
sleep 10; pgrep i3lock && xset dpms force off
