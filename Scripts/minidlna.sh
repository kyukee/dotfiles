#!/bin/bash

if [ ! "$#" -eq 1 ]; then
	echo "Invalid input. Usage: ${0##*/} <start/stop/status/rescan>" >&2
	exit 1
fi

ARG="$1"

if [ "$ARG" == "start" ]; then
	minidlnad -f /home/$USER/.config/minidlna/minidlna.conf -P /home/$USER/.config/minidlna/minidlna.pid
	echo "server started"
	echo "to turn screen off:"
	echo "xset dpms force off"
elif [ "$ARG" == "rescan" ]; then
	minidlnad -f /home/$USER/.config/minidlna/minidlna.conf -P /home/$USER/.config/minidlna/minidlna.pid -R
	echo "server started"
	echo "library updated"
	echo "to turn screen off:"
	echo "xset dpms force off"	
elif [ "$ARG" == "stop" ]; then
	pkill minidlnad
	echo "server stopped"
elif [ "$ARG" == "status" ]; then
	if [ -n "$(pidof minidlnad)" ]; then
		echo "server is running"
	else
		echo "server is not running"
	fi
else
	echo "Invalid argument. It should be start, stop or status"
	exit 1
fi
