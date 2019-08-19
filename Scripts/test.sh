#!/bin/bash

_rofi () {
  rofi -kb-accept-entry "!Return" "$@"
}

echo "test" | _rofi -dmenu -p "Screencast > "
