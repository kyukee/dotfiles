#!/bin/bash

awk 'END{sub(/\[/,""); print $1}' /var/log/pacman.log
