#!/usr/bin/env bash

# This script defines just a mode for rofi instead of being a self-contained
# executable that launches rofi by itself. This makes it more flexible than
# running rofi inside this script as now the user can call rofi as one pleases.
# For instance:
#
#   rofi -show powermenu -modi powermenu:./rofi-power-menu

set -e
set -u

# All supported choices
all=(bluetooth theme-gtk theme-qt fonts audio network displays power printer center defaults)

# By default, show all (i.e., just copy the array)
show=("${all[@]}")

# By default, show symbols
showsymbols=true

# missing:
# - xbacklight
# - selectdefaultapplication

declare -A texts
texts[bluetooth]="Bluetooth Manager"
texts[theme-gtk]="Theme Switcher (GTK)"
texts[theme-qt]="Theme Switcher (QT)"
texts[fonts]="Font Manager"
texts[audio]="Volume Control"
texts[network]="Network Configuration"
texts[displays]="Display Settings"
texts[power]="Power Management"
texts[printer]="Printer Manager"
texts[center]="Configuration Center"
texts[defaults]="Default Applications"

declare -A icons
icons[cancel]=""
icons[bluetooth]=""
icons[theme-gtk]=""
icons[theme-qt]=""
icons[fonts]=""
icons[audio]=""
icons[network]=""
icons[displays]=""
icons[power]=""
icons[printer]=""
icons[center]=""
icons[defaults]=""

declare -A actions
actions[bluetooth]="blueman-manager"
actions[theme-gtk]="lxappearance"
actions[theme-qt]="qt5ct"
actions[fonts]="font-manager"
actions[audio]="pavucontrol"
actions[network]="nm-connection-editor"
actions[displays]="arandr"
actions[power]="tlpui"
actions[printer]="system-config-printer"
actions[center]="lxqt-config"
# actions[center]="io.elementary.switchboard"
actions[defaults]="xdg-open ~/.config/mimeapps.list"

function check_valid {
    option="$1"
    shift 1
    for entry in "${@}"
    do
        if [ -z "${actions[$entry]+x}" ]
        then
            echo "Invalid choice in $1: $entry" >&2
            exit 1
        fi
    done
}

# Define the messages after parsing the CLI options so that it is possible to
# configure them in the future.

function write_message {
    icon="<span font_size=\"medium\">$1</span>"
    text="<span font_size=\"medium\">$2</span>"
    if [ "$showsymbols" = "true" ]
    then
        echo -n "\u200e$icon \u2068$text\u2069"
    else
        echo -n "$text"
    fi
}

function print_selection {
    echo -e "$1" | $(read -r -d '' entry; echo "echo $entry")
}

declare -A messages
for entry in "${all[@]}"
do
    messages[$entry]=$(write_message "${icons[$entry]}" "${texts[$entry]^}")
done

if [ $# -gt 0 ]
then
    # If arguments given, use those as the selection
    selection="${@}"
else
    # Otherwise, use the CLI passed choice if given
    if [ -n "${selectionID+x}" ]
    then
        selection="${messages[$selectionID]}"
    fi
fi

# Don't allow custom entries
echo -e "\0no-custom\x1ftrue"
# Use markup
echo -e "\0markup-rows\x1ftrue"

if [ -z "${selection+x}" ]
then
    echo -e "\0prompt\x1fSystem settings"
    for entry in "${show[@]}"
    do
        echo -e "${messages[$entry]}\0icon\x1f${icons[$entry]}"
    done
else
    for entry in "${show[@]}"
    do
        if [ "$selection" = "$(print_selection "${messages[$entry]}")" ]
        then
            # Perform the action
            eval "${actions[$entry]}" &>/dev/null & disown;
        fi
    done
    # The selection didn't match anything, so raise an error
    echo "Invalid selection: $selection" >&2
    exit 1
fi
