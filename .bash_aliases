# aliases
alias ls='ls --color=auto'
alias ll='ls -al'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias startx='ssh-agent startx'
alias scrot-d='scrot -d 3 -c /home/kyukee/Pictures/screenshots/%Y-%m-%d-%T-screenshot.png'
alias clock='mongoclock'
alias pipes='pipes -f 30  -p 4  -s 12  -r 1600  -p 4 -R'
alias gitdir='cd Development/git/ && ls'
alias diff='colordiff'
# alias calc='='
alias calc='rofi -show calc -modi calc -no-show-match -no-sort'
alias i3lock-fancy='i3lock-fancy -b=20x10'
alias open='xdg-open'
alias surfd='surf duckduckgo.com'

# functions
fzf-edit() { fzf | xargs -r $EDITOR ;}
