#
# ~/.zshrc
#

#--------------------------------------------------
# history settings
#--------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=1500
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
recovery-yay () {
    yay "$@"  \
    --dbonly          \
    --nodeps          \
    --needed			\
}

#    --noscriptlet     \
#    --overwrite       \


# profiling tool for zshrc
zmodload zsh/zprof


# By default, Ctrl+G is assigned to launching navi
eval "$(navi widget zsh)"


# Setting fd as the default source for fzf (respects .gitignore by default)
export FZF_DEFAULT_COMMAND='fd --type "file" --hidden --ignore-case --no-ignore-vcs --exclude ".git/*/*"'


# update mirrorlist
upp() {
  for i in 1 3 6; do
    if reflector -c PT -a $i -p https -l 5 --sort score --save /etc/pacman.d/mirrorlist.reflector 2>/dev/null; then
      cat /etc/pacman.d/mirrorlist.reflector
      pacman -Syu
      return 0
    fi
  done
  echo "--> cannot find a single mirror with sync time in the last 6 hours"
  return 1
}

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
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}

#setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[PageUp]}"  ]]  && bindkey  "${key[PageUp]}"   up-line-or-history
[[ -n "${key[PageDown]}" ]] && bindkey  "${key[PageDown]}" down-line-or-history
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"       history-beginning-search-backward
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"     history-beginning-search-forward
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"    forward-char

# ctrl + arrow keys
bindkey "\e[1;5D" backward-word
bindkey "\e[1;5C" forward-word

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
export DISPLAY=:1
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export TERM='xterm-kitty'
export TERMINAL='kitty'
export EDITOR=micro
export VISUAL=micro
export MICRO_TRUECOLOR=1
export PDFVIEWER=evince
export CHEATSHEETS_PATH="$HOME/Development/git/cheatsheets"

export JAVA_HOME=/usr/lib/jvm/default # use archlinux-java to set value
export MYSQL_HOME=/usr/bin/mysql
export M2_HOME=/usr/bin/mvn
export ECLIPSE_HOME=/usr/bin/eclipse
export GOPATH="$HOME/.go"

# add a directory to $path
# but only if it doesn't exist already
add_to_path_if_not_exists () {
	case ":${PATH}:" in
	  *:${1}:*) ;;
	  *) PATH=${PATH}:${1} ;;
	esac
}

add_to_path_if_not_exists "$HOME/Scripts"
add_to_path_if_not_exists "$JAVA_HOME/bin"
add_to_path_if_not_exists "$HOME/.npm-global/bin"
add_to_path_if_not_exists "$HOME/.local/bin"
add_to_path_if_not_exists "$HOME/.config/composer/vendor/bin"

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

# colours used by ls (obtained with dircolors command)
LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:';
export LS_COLORS

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
zstyle ':completion:*:local-directories' list-colors '=*=0;34'

# add completion to kubernetes (its a bit slow, so better keep it disabled unless necessary)
#source <(kubectl completion zsh)

# flatpak completion
source ~/.zsh/flatpak-zsh-completion/flatpak.plugin.zsh


#--------------------------------------------------
# prompt settings
#--------------------------------------------------
# http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html

# export TERMINAL_EMULATOR=$(basename "/"$(ps -f -p $(cat /proc/$(echo $$)/stat | cut -d \  -f 4) | tail -1 | sed 's/^.* [\d:]* //' | awk '{print $2}'))
export TERMINAL_EMULATOR="term"

precmd() {
    # set window/tab title
    #print -Pn "\e]2;%n@%M | %~\a"

    if [[ ! "$TMUX" ]]; then
      # \e]2; and \a are escape codes. %2~ is the PWD, but with a limit size of the last 2 directorys
      print -Pn "\e]2;${TERMINAL_EMULATOR:-unknown} - %2~\a"
    else
      print -Pn "\e]2; %2~ \a"
    fi

	# Print a newline before the prompt, unless it's the
	# first prompt in the process.
	if [ -z "$NEW_LINE_BEFORE_PROMPT" ]; then
	  NEW_LINE_BEFORE_PROMPT=1
	elif [ "$NEW_LINE_BEFORE_PROMPT" -eq 1 ]; then
	  printf "\n"
	fi
}

settitle() {
    printf "\033k$1\033\\"
}

# prompts to choose from:

# colored path
#PROMPT='%F{000}%K{green}%F{green}%K{000}%F{000}%K{magenta}%F{magenta}%K{000}%F{000}%K{red}%F{black}%K{red} %~ %F{red}%K{none}$ %{$reset_color%}'

# not colored path
#PROMPT='%F{000}%K{green}%F{green}%K{000}%F{000}%K{magenta}%F{magenta}%K{000}%F{000}%K{000}%F{white}%K{000}[%~]$(git_super_status)$ %{$reset_color%}'

# original prompt from a theme
#PROMPT="%F{000}%K{002} %T %F{002}%K{006}%F{000}%K{006} %F{006}%K{001}%F{000}%K{001} %~ %F{001}%K{000}"$'\n'"%F{000}%K{003} %n ➜ %F{003}%K{000} %F{015}"

# enable git status in prompt
# source ~/.zsh/zsh-git-prompt/zshrc.sh
source ~/.zsh/git-prompt.zsh/git-prompt.zsh

# get background color
BG_COL="$(cat ~/.config/kitty/kitty.conf | grep background | awk '{print $2}')"

# same prompt as bash
#PROMPT='%F{red}>>> %f[%~ ]$(git_super_status)$ '

# two line prompt (git_super_status)
# PROMPT='%F{000}%K{green}%F{green}%K{000}%F{000}%K{magenta}%F{magenta}%K{000}%F{000}%K{cyan}%F{black}%K{cyan} %f%~ %F{cyan}%K{none} %{$reset_color%}$(git_super_status) %{$reset_color%}'$'\n'' %F{red}$ %{$reset_color%}%k%f'

# two line prompt (with separate async git)
PROMPT='%F{$BG_COL}%K{green}%F{green}%K{$BG_COL}%F{$BG_COL}%K{magenta}%F{magenta}%K{$BG_COL}%F{$BG_COL}%K{cyan}%F{black}%K{cyan} %f%~ %F{cyan}%K{none} %{$reset_color%}'$'\n'' %F{red}$ %{$reset_color%}%k%f'

# local _lineup=$'\e[1A'
# local _linedown=$'\e[1B'
# RPROMPT=%{${_lineup}%}'$(gitprompt)'%{${_linerestore}%}

RPROMPT='$(gitprompt)'

# local _lineright=$'\e[5G'
# RPROMPT='$(gitprompt)'%{${_lineright}%}



# terminal title
#printf "\033];%s\07\n" "hello world"



# powerline symbols
# airline_left_sep = ''
# airline_left_alt_sep = ''
# airline_right_sep = ''
# airline_right_alt_sep = ''
# airline_symbols.branch = ''
# airline_symbols.readonly = ''
# airline_symbols.linenr = '☰'
# airline_symbols.maxlinenr = ''



# # Usage: prompt-length TEXT [COLUMNS]
# #
# # If you run `print -P TEXT`, how many characters will be printed
# # on the last line?
# #
# # Or, equivalently, if you set PROMPT=TEXT with prompt_subst
# # option unset, on which column will the cursor be?
# #
# # The second argument specifies terminal width. Defaults to the
# # real terminal width.
# #
# # The result is stored in REPLY.
# #
# # Assumes that `%{%}` and `%G` don't lie.
# #
# # Examples:
# #
# #   prompt-length ''            => 0
# #   prompt-length 'abc'         => 3
# #   prompt-length $'abc\nxy'    => 2
# #   prompt-length '❎'          => 2
# #   prompt-length $'\t'         => 8
# #   prompt-length $'\u274E'     => 2
# #   prompt-length '%F{red}abc'  => 3
# #   prompt-length $'%{a\b%Gb%}' => 1
# #   prompt-length '%D'          => 8
# #   prompt-length '%1(l..ab)'   => 2
# #   prompt-length '%(!.a.)'     => 1 if root, 0 if not
# function prompt-length() {
#   emulate -L zsh
#   local -i COLUMNS=${2:-COLUMNS}
#   local -i x y=${#1} m
#   if (( y )); then
#     while (( ${${(%):-$1%$y(l.1.0)}[-1]} )); do
#       x=y
#       (( y *= 2 ))
#     done
#     while (( y > x + 1 )); do
#       (( m = x + (y - x) / 2 ))
#       (( ${${(%):-$1%$m(l.x.y)}[-1]} = m ))
#     done
#   fi
#   typeset -g REPLY=$x
# }
#
# # Usage: fill-line LEFT RIGHT
# #
# # Sets REPLY to LEFT<spaces>RIGHT with enough spaces in
# # the middle to fill a terminal line.
# function fill-line() {
#   emulate -L zsh
#   prompt-length $1
#   local -i left_len=REPLY
#   prompt-length $2 9999
#   local -i right_len=REPLY
#   local -i pad_len=$((COLUMNS - left_len - right_len - ${ZLE_RPROMPT_INDENT:-1}))
#   if (( pad_len < 1 )); then
#     # Not enough space for the right part. Drop it.
#     typeset -g REPLY=$1
#   else
#     local pad=${(pl.$pad_len.. .)}  # pad_len spaces
#     typeset -g REPLY=${1}${pad}${2}
#   fi
# }
#
# # Sets PROMPT and RPROMPT.
# #
# # Requires: prompt_percent and no_prompt_subst.
# function set-prompt() {
#   emulate -L zsh
#
#   local top_left="%F{000}%K{green}%F{green}%K{000}%F{000}%K{magenta}%F{magenta}%K{000}%F{000}%K{cyan}%F{black}%K{cyan} %f%~ %F{cyan}%K{none} %{$reset_color%}"
#   local top_right="$(gitprompt)"
#   local bottom_left=" %F{red}$ %{$reset_color%}%k%f"
#   local bottom_right=''
#
#   local REPLY
#   fill-line "$top_left" "$top_right"
#   PROMPT=$REPLY$'\n'$bottom_left
#   RPROMPT=$bottom_right
# }
#
# setopt no_prompt_{bang,subst} prompt_{cr,percent,sp}
# autoload -Uz add-zsh-hook
# add-zsh-hook precmd set-prompt
