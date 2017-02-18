#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export LANG=en_US.UTF-8

source ~/.bash_aliases


# the text before every command
PS1='\[$(tput bold)\]\[\033[38;5;197m\]>>>\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\] [\W ]\$ '


# add a directory to $path (Scripts folder in this case)
# directory to add to path
NEWPATH="$HOME/Scripts"


# add it only if required
case ":${PATH}:" in
  *:${NEWPATH}:*) ;;
  *) PATH=${PATH}:$NEWPATH ;;
esac

export PATH


# turn off bell in xorg
if [ -n "$DISPLAY" ]; then
	xset b off
fi