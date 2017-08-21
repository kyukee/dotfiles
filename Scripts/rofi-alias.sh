#!/bin/bash

# Returns a list of aliases in .bashrc, to be used in rofi
cat .bash_aliases | grep  alias.*= | awk -F'[ =]' '{print $2}'

# commands that come from a custom path (in this case the folder Scripts)
ls -R Scripts | grep .sh
