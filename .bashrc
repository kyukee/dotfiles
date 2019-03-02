#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# import aliases
source ~/.bash_aliases


# the text before every command (prompt)
PS1='\[$(tput bold)\]\[\033[38;5;197m\]>>>\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\] [\W ]\$ '


# add a directory to $path (Scripts folder in this case)
PATH_TO_ADD="$HOME/Scripts"

# add it only if required
case ":${PATH}:" in
  *:${PATH_TO_ADD}:*) ;;
  *) PATH=${PATH}:$PATH_TO_ADD ;;
esac

export PATH


# turn off bell in xorg
if [ -n "$DISPLAY" ]; then
	xset b off
fi


# export variables
export LANG=en_US.UTF-8
