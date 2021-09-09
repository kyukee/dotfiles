#!/bin/bash
sudo pacman -S $(awk '{print $1}' pacman-packages-list.txt)