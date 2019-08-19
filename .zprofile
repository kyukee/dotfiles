#
# ~/.zprofile
#

# start external monitor above the primary one
mons -e top

# autostart x
if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
  exec startx
fi