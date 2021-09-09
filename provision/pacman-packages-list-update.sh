# will create a list of all explicitly installed packages, except those in groups base-devel
comm -23 <(pacman -Qqe | sort) <(pacman -Qq -g base-devel | sort | uniq) > pacman-packages-list-install.sh

# note: install the packages from the list after installing base-devel
