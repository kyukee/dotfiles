#!/bin/sh
#
# Rofi wrapper for Jackett search API to find torrents.

# Jacket service URL
JACKETT_URL='https://jackett.minipc.home'

# Search options
option0="Anime"
option1="All categories"
options="$option0\n$option1"

selected="$(echo -e "$options" | rofi -lines 5 -dmenu -p "What do you want to search?")"

case $selected in
    $option0)
        TRACKER='nyaasi'
        CATEGORY='127720'
        FILTER='all'
        SEARCH="$(rofi -dmenu -p "Search: ")"
        SEARCH_TERM="$(echo $SEARCH | sed 's/ /+/g')"
        xdg-open "$JACKETT_URL/UI/Dashboard#tracker=$TRACKER&category=$CATEGORY&filter=$FILTER&search=$SEARCH_TERM";;
    $option1)
        FILTER='all'
        SEARCH="$(rofi -dmenu -p "Search: ")"
        SEARCH_TERM="$(echo $SEARCH | sed 's/ /+/g')"
        xdg-open "$JACKETT_URL/UI/Dashboard#filter=$FILTER&search=$SEARCH_TERM";;
esac
