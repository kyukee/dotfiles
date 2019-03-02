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
