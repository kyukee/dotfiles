#!/bin/bash
#   Allows for file browsing in rofi

usage()
{
    cat << EOF
usage: $0 options

Index and search files using dmenu

OPTIONS:
   -h      Show this message
   -o      Store index [default: /tmp/fmenu_index]
   -i      Search folders [default: $HOME]
   -x      Exclude files [default: ".*\/..*" (i.e. dot-files)]
   -d      dmenu parameters [default: -i -l 20]
   -f      force reloading index [default: false]
   -t      time [default: 5min]
   -u      Just update the index
EOF
}

FORCE=false
INDEX="/tmp/fmenu_index"
DMENU="-i -l 20"
TIME="+300"
INPUT=$HOME

# find exclude. See 'emacs regular expression' for syntax
#EXCLUDE='.*\.cache.*\|.*\.local.*\|.*\.mozilla.*\|.*sublime-text-3.*\|.*adapta-gtk-theme.*\|.*Font-Awesome.*\|.*Java\/docs.*\|.*\.wine.*windows.*\|.*wineprefix.*\|.*\.git\/objects.*\|.*\.docker.*\|.*\.thumbnail.*'

# fd exclude. glob pattern
#EXCLUDE='{*cache*,*.local*,*.mozilla*.*sublime-text-3*,*adapta-gtk-theme*,*Font-Awesome*,*.wineprefix*,*.docker*,*.thumbnail*,*.metadata*,*drive_c*,*build-tools*,*extensions*,*Sdk*,*aws-sdk*,*nexus3*,*AndroidStudio*,*node_modules*,*vagrant.d*,*Cache*,*packages*,*globalStorage*,*workspaceStorage*,*licensemanager*,*.sbt*,*.PlayOnLinux*,*storage*,*.m2*,*Backup*,*.gradle*,*assets*,*golang*,*jmespath*,*terraform@*,*.class*,*.gem*,*pygments*}'
EXCLUDE=''

# find exclude - regex
# fd exclude - glob pattern
# apparently, the regex actually makes find slower
# fd deals a lot better with regex and excluded files


DRY=false
while getopts "ht:fd:o:i:x:u" OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         f)
             FORCE=true
             ;;
         d)
             DMENU=$OPTARG
             ;;
         t)
             TIME=$OPTARG
             ;;
         o)
             INDEX=$OPTARG
             ;;
         i)
             INPUT=$OPTARG
             ;;
         x)
             EXCLUDE=$OPTARG
             ;;
         u)
             FORCE=true
             DRY=true
             ;;
         ?)
             usage
             exit
             ;;
     esac
     shift 1
done

function index_files {
    # find "$INPUT" \( ! -regex "$EXCLUDE" \) | sed 's/ /\\ /g' | sort -f > "$INDEX"

    fd -H . "$HOME" --ignore-file .fmenu-ignore | sed 's/ /\\ /g' | sort -f > "$INDEX"
}

# if [[ ! -a "$INDEX" ]] ||  ( test `find $INDEX -mmin $TIME` ) || ($FORCE)
if [[ ! -a "$INDEX" ]] || ($FORCE)
then
    index_files
fi

if ( ! $DRY )
then
    if [ -z $@ ]
    then
        cat "$INDEX"
    else
        xdg-open $@ > /dev/null &
    fi
fi
