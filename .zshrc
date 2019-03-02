#
# ~/.zshrc
#

#--------------------------------------------------
# history settings
#--------------------------------------------------
HISTFILE=~/.histfile
HISTSIZE=500
SAVEHIST=$HISTSIZE


#--------------------------------------------------
# Essentials
#--------------------------------------------------
# import aliases
source ~/.bash_aliases


# add a directory to $path (Scripts folder in this case)
# add it only if it doesn't exist already
PATH_TO_ADD="$HOME/Scripts"

case ":${PATH}:" in
  *:${PATH_TO_ADD}:*) ;;
  *) PATH=${PATH}:$PATH_TO_ADD ;;
esac

PATH_TO_ADD="$HOME/Scripts/linux64"

case ":${PATH}:" in
  *:${PATH_TO_ADD}:*) ;;
  *) PATH=${PATH}:$PATH_TO_ADD ;;
esac


export PATH



# turn off bell in xorg
if [ -n "$DISPLAY" ]; then
  xset b off
fi

# home and end key behaviour fixed
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line

#--------------------------------------------------
# eviornment variables
#--------------------------------------------------
export DISPLAY=:0
export LANG=en_US.UTF-8
export TERM='rxvt-unicode'
export EDITOR='subl3'
export VISUAL='subl3'

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
export MYSQL_HOME=/usr/bin/mysql
export M2_HOME=/usr/bin/mvn
export ECLIPSE_HOME=/usr/bin/eclipse


#--------------------------------------------------
# zsh options
#--------------------------------------------------
# append history instead of replacing it
setopt appendhistory

# automatically list completion possibilities
setopt menu_complete

# press TAB to finish path's with incomplete words
setopt complete_in_word

# spelling correction for arguments (correctall to correct everything)
setopt correct

# when searching history, don't do not display duplicates
setopt hist_find_no_dups
setopt hist_ignore_all_dups

# type the name of directory to cd to it
setopt autocd

# increase the amount of options for glob searching
#setopt extended glob

# fish-like syntax highlighting
#source ./zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


#--------------------------------------------------
# ASCII escape sequences - Colors
#--------------------------------------------------
# Syntax: [attribute;foreground;background m  

# Text attributes
# 0 All attributes off
# 1 Bold on
# 4 Underscore (on monochrome display adapter only)
# 5 Blink on
# 7 Reverse video on
# 8 Concealed on
 
# Foreground colors
# 30  Black
# 31  Red
# 32  Green
# 33  Yellow
# 34  Blue
# 35  Magenta
# 36  Cyan
# 37  White
 
# Background colors
# 40  Black
# 41  Red
# 42  Green
# 43  Yellow
# 44  Blue
# 45  Magenta
# 46  Cyan
# 47  White 


#--------------------------------------------------
# completion settings
#--------------------------------------------------
# enable completion
autoload -Uz compinit && compinit

# case insensitive auto-completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# activate completion menu when there are nore then 3 items to choose
zstyle ':completion:*' menu select=3

# message when there aren't any completion results
zstyle ':completion:*:warnings' format $'%{\e[0;35m%}No matches for:%{\e[0m%} %d'

# divide results into groups
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

# format group names for results
zstyle ':completion:*' format $'%{\e[0;34m%}» %B%d%b%{\e[0m%}'

# display processes for kill command completion in tree format
zstyle ':completion:*:processes' command ps --forest -A -o pid,cmd

# kill command completion colors
zstyle ':completion:*:*:kill:*' list-colors '=(#b) #([0-9]#)*( *[a-z])*=34=31=37'

# highlight matching part of available completions
highlights='${PREFIX:+=(#bi)($PREFIX:t)(?)*==$color[yellow];$color[bold]}':${(s.:.)LS_COLORS}}
zstyle -e ':completion:*' list-colors 'reply=( "'$highlights'" )'
unset highlights

# change folders color
#zstyle ':completion:*:local-directories' list-colors '=*=0;34'


#--------------------------------------------------
# prompt settings
#--------------------------------------------------

# add an empty line before every prompt
#precmd() { print "" }

# prompts to choose from

# colored path
#PROMPT='%F{008}%K{green}%F{green}%K{008}%F{008}%K{magenta}%F{magenta}%K{008}%F{008}%K{red}%F{black}%K{red} %~ %F{red}%K{none}$ %{$reset_color%}'

# not colored path
#PROMPT='%F{008}%K{green}%F{green}%K{008}%F{008}%K{magenta}%F{magenta}%K{008}%F{008}%K{008}%F{white}%K{008}[%~]$(git_super_status)$ %{$reset_color%}'

# original prompt from a theme
#PROMPT="%F{000}%K{002} %T %F{002}%K{006}%F{000}%K{006} %F{006}%K{001}%F{000}%K{001} %~ %F{001}%K{000}"$'\n'"%F{000}%K{003} %n ➜ %F{003}%K{000} %F{015}"

# enable git status in prompt
source ~/.zsh/zshrc.sh

# same prompt as bash
PROMPT='%F{red}>>> %f[%~ ]$(git_super_status)$ '

# git package prompt script
# source /usr/share/git/completion/git-prompt.sh
# PROMPT='%F{red}>>> %f[%~ ]$(__git_ps1 " (%s)")$ '
