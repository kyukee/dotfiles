#!/bin/bash

awk 'END{sub(/\[/,""); sub(/\]/,""); print $1}' /var/log/pacman.log
