## update terminal
xrdb ~/.Xresources

## refresh keys
pacman-key --refresh-keys

## change shell (replace zsh with shell name for other shell)
chsh -s $(which zsh)

## check current brightness
cat /sys/class/backlight/intel_backlight/brightness

## check max brightness
cat /sys/class/backlight/intel_backlight/max_brightness

## rename every file in a folder to bnr00, bnr01, bnr02, etc.
num=0; for i in *; do mv "$i" "$(printf 'bnr%02d' $num).${i#*.}"; ((num++)); done

## set keyboard input mode to scancode
sudo kbd_mode -s

## update aur packages
yaourt -Syua

## (rar) extract to folder ('e' instead of 'x' to dump all files)
unrar x filename

## (7z) extract to folder
7z x filename

## start a local webserver on port 9000 with the contents of the ".startpage" folder
http-server ./.startpage -p 9000

## connect to ist sigma
ssh sigma.ist.utl.pt -l ist187665

## copy all files in folder to destination ('*' for normal files, '.' for hidden files also)
scp -r ~/Development/git/IPM-IST/Homepage/. ist187665@sigma.ist.utl.pt:~/web

## copy only modified files
rsync -av ~/Development/git/IPM-IST/Homepage/ ist187665@sigma.ist.utl.pt:~/web

## list open ports ('l' for listening, 'a' for all)
ss -tunl

## check for date of all previous pacman updates
egrep 'pacman -Syu' /var/log/pacman.log

## check for date of last pacman update
awk 'END{sub(/\[/,""); print $1}' /var/log/pacman.log

## zip to a directory
zip -r squash.zip dir1

## start a service
systemctl start unit

## enable a service at bootup and also start immediatly
systemctl enable --now unit

## run a command in the background
add '&' to the end of the command

## start a ssh agent which stores rsa key passwords
eval $(keychain --quiet --agents ssh --eval id_rsa)

## check for errors and warnings in the script (can use bash instead of ksh)
ksh -n myscript.sh

## Disk usage analyzer with an ncurses interface
sudo ncdu [directory]

## output appended data as the file grows
tail -f file.txt

## print current terminal emulator
ps -p $(ps -p $$ -o args,ppid | tail -1 | awk '{print $2}') -o args | tail -1

## utility to list / change java environments, among other things
archlinux-java

## look at filesizes in current directory
du -h -d1 .

## select the 20 most recently synchronized HTTP or HTTPS mirrors, sort them by download speed, and overwrite the file /etc/pacman.d/mirrorlist
sudo reflector --latest 20 --verbose --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist

## list fonts
convert -list font | awk -F: '/Font: / { print $2 }' | sort -du

## run a program with a program with a certasin cpu priority (-19=highest, 19=lowest)
nice -n 19 <command>

## install micro text editor
cd /usr/local/bin; curl https://getmic.ro | sudo bash

## atom export packages
apm list --installed --bare > atom-package-list.txt

## atom import packages
apm install --packages-file atom-package-list.txt
