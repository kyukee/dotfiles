#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export LANG=en_US.UTF-8

# aliases
alias ls='ls --color=auto'
alias scrot-d='scrot -d 3 -c /home/kyukee/Pictures/screenshots/%Y-%m-%d-%T-screenshot.png'
alias wifi='sudo connman_dmenu'
alias simulador='java -jar "/home/kyukee/Documents/CPU Simulator/simulador.jar"'
alias clock='mongoclock'
alias pipes='pipes -f 30  -p 4  -s 12  -r 1600  -p 4 -R'
alias lock='i3lock-fancy'
alias gitdir='cd Development/git/ && ls'


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
