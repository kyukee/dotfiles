#!/bin/sh

case "${SRANDRD_OUTPUT} ${SRANDRD_EVENT}" in
    "DP1 connected")
        ~/.screenlayout/external_only.sh
        ;;
    "DP1 disconnected")
        ~/.screenlayout/default.sh
        ;;
esac
