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


# turn off bell in xorg
if [ -n "$DISPLAY" ]; then
  xset b off
fi


# configure ssh agent through Keychain
eval $(keychain --quiet --agents ssh --eval id_rsa_no_pass)



# fix crlf instead of lf in the enter key
stty icrnl


# used to recover pacman local database restore
recovery-yay() {
    yay "$@"  \
    --dbonly          \
    --nodeps          \
    --needed			\
}

#    --noscriptlet     \
#    --overwrite       \



#--------------------------------------------------
# Remap Keybindings
#--------------------------------------------------
typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[PageUp]}"  ]]  && bindkey  "${key[PageUp]}"  up-line-or-history
[[ -n "${key[PageDown]}" ]] && bindkey  "${key[PageDown]}" down-line-or-history
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      history-beginning-search-backward
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    history-beginning-search-forward
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char

bindkey "^[Od" backward-word     # ctrl+left
bindkey "^[Oc" forward-word     # ctrl+right


# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
function zle-line-init () {
    echoti smkx
}
function zle-line-finish () {
    echoti rmkx
}
zle -N zle-line-init
zle -N zle-line-finish 


#--------------------------------------------------
# environment variables
#--------------------------------------------------
export DISPLAY=:0
export LANG=en_US.UTF-8
export TERM='rxvt-unicode'
export TERMINAL='urxvt'
export EDITOR=micro
export VISUAL=micro

#export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
export JAVA_HOME=/usr/lib/jvm/java-12-jdk
export MYSQL_HOME=/usr/bin/mysql
export M2_HOME=/usr/bin/mvn
export ECLIPSE_HOME=/usr/bin/eclipse


# add a directory to $path
# but only if it doesn't exist already
add_to_path_if_not_exists(){
	case ":${PATH}:" in
	  *:${1}:*) ;;
	  *) PATH=${PATH}:${1} ;;
	esac
}

add_to_path_if_not_exists "$HOME/Scripts"
add_to_path_if_not_exists "$HOME/Scripts/linux64"
add_to_path_if_not_exists "$JAVA_HOME/bin"

export PATH


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

# add completion to kubernetes
source <(kubectl completion zsh)

#--------------------------------------------------
# prompt settings
#--------------------------------------------------

precmd() {
	# Print a newline before the prompt, unless it's the
	# first prompt in the process.
	if [ -z "$NEW_LINE_BEFORE_PROMPT" ]; then
	  NEW_LINE_BEFORE_PROMPT=1
	elif [ "$NEW_LINE_BEFORE_PROMPT" -eq 1 ]; then
	  printf "\n"
	fi
}

# prompts to choose from:

# colored path
#PROMPT='%F{008}%K{green}%F{green}%K{008}%F{008}%K{magenta}%F{magenta}%K{008}%F{008}%K{red}%F{black}%K{red} %~ %F{red}%K{none}$ %{$reset_color%}'

# not colored path
#PROMPT='%F{008}%K{green}%F{green}%K{008}%F{008}%K{magenta}%F{magenta}%K{008}%F{008}%K{008}%F{white}%K{008}[%~]$(git_super_status)$ %{$reset_color%}'

# original prompt from a theme
#PROMPT="%F{000}%K{002} %T %F{002}%K{006}%F{000}%K{006} %F{006}%K{001}%F{000}%K{001} %~ %F{001}%K{000}"$'\n'"%F{000}%K{003} %n ➜ %F{003}%K{000} %F{015}"

# enable git status in prompt
source ~/.zsh/zshrc.sh

# git package prompt script
# source /usr/share/git/completion/git-prompt.sh
# PROMPT='%F{red}>>> %f[%~ ]$(__git_ps1 " (%s)")$ '

# same prompt as bash
#PROMPT='%F{red}>>> %f[%~ ]$(git_super_status)$ '

# two line prompt
PROMPT='%F{008}%K{green}%F{green}%K{008}%F{008}%K{magenta}%F{magenta}%K{008}%F{008}%K{cyan}%F{black}%K{cyan} %f%~ %F{cyan}%K{none} %{$reset_color%}$(git_super_status)'$'\n'' %F{red}$ %{$reset_color%}%f'
