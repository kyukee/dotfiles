#! /bin/bash

for pkg in $(pacman -Qq); do
    yay -S --noconfirm $pkg
done