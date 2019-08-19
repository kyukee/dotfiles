#!/usr/bin/env bash

# set default rofi options
_rofi () {
    rofi -kb-accept-entry "!Return" "$@"
}

if [ -z "$XDG_RUNTIME_DIR" ]; then
    TMPDIR=$(mktemp -d)
    XDG_RUNTIME_DIR=$TMPDIR
    trap 'rm -rf $TMPDIR; exit' INT QUIT HUP TERM 0
fi

source /etc/teiler/config

if [[ ! -d $HOME/.config/teiler ]]; then
    mkdir $HOME/.config/teiler
fi

if [[ ! -f $HOME/.config/teiler/config ]]; then
    cp /etc/teiler/config $HOME/.config/teiler/config
fi

export ext=${ext}; source $HOME/.config/teiler/config

if [[ ! -d $HOME/.config/teiler/profiles ]]; then
    mkdir $HOME/.config/teiler/profiles
fi

dir=$(pwd)
cd /etc/teiler/profiles
for i in *; do
    if [[ ! -f $HOME/.config/teiler/profiles/"$i" ]]; then
        cp /etc/teiler/profiles/"$i" $HOME/.config/teiler/profiles
    else
        cmp "$i" $HOME/.config/teiler/profiles/"$i" || cp -f /etc/teiler/profiles/"$i" $HOME/.config/teiler/profiles
    fi
done
cd ${dir}

check_img_path () {
  if [[ ! -d $img_path ]]; then
    read -p "Image path \"${img_path}\" does not exist. Create it? (Y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ || $REPLY == "" ]]; then
      mkdir -p "${img_path}"
    elif [[ $REPLY =~ ^[Nn]$ ]]; then
      exit
    else
      echo "Please enter y or n"
      check_img_path
    fi
  fi
}

check_vid_path () {
  if [[ ! -d $vid_path ]]; then
    read -p "Video path \"${vid_path}\" does not exist. Create it? (Y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ || $REPLY == "" ]]; then
      mkdir -p "${vid_path}"
    elif [[ $REPLY =~ ^[Nn]$ ]]; then
      exit
    else
      echo "Please enter y or n"
      check_vid_path
    fi
  fi
}

source "$HOME/.config/teiler/profiles/${profile}"

vid_filemask="${vid_filemask}.${ext}"
noupload=$save

mainMenu () {
    if [[ -f $XDG_RUNTIME_DIR/__teiler_cast_name ]]; then
        filename="$(cat $XDG_RUNTIME_DIR/__teiler_cast_name)"
    fi
    isRecording && STATE_RECORDING="1 Stop Recording Screencast"
    if [[ "$STATE_RECORDING" == "1 Stop Recording Screencast" ]]; then
        menu=$(echo -e "< Exit\n---\n"$STATE_RECORDING"" | _rofi -dmenu -u 2 -p "teiler > ")
        val=$?
        if [[ $val -eq 1 ]]; then exit;
        elif [[ $val -eq 0 ]]; then askPrompt;
        fi

    elif [[ -z "$STATE_RECORDING" ]]; then
        menu=$(echo -e "< Exit\n---\n1 [ Screenshots ]>\n2 [ Screencasts ]>\n3 [ History ]>\n---" | _rofi -dmenu -p "teiler > ")
        val=$?
        if [[ $menu == "1 [ Screenshots ]>" ]]; then screenshotMenu;
        elif [[ $menu == "2 [ Screencasts ]>" ]]; then screencastMenu;
        elif [[ $menu == "3 [ History ]>" ]]; then uploadMenu;
        elif [[ $menu == "< Exit" ]]; then exit;
        elif [[ $val -eq 1 ]]; then exit; fi
    fi
}

screenshotMenu () {
    export filename="${img_filemask}"
    menu=$(echo -e "< Return to Main Menu\n---\n1 Monitor\n2 Fullscreen\n3 Area" | _rofi -dmenu -p "Screenshot > ")
    rofi_exit=$?
    if [[ $menu == "1 Monitor" ]]; then
        mode="fullscreen"
        desc="Monitor"
    elif [[ $menu == "2 Fullscreen" ]]; then
        mode="fullscreenAll"
        desc="Fullscreen"
    elif [[ $menu == "3 Area" ]]; then
        mode="area"
        desc="Area"
    fi
    if [[ $menu == "< Return to Main Menu" ]]; then
        mainMenu
    fi
    if [[ $rofi_exit -eq 1 ]]; then
        exit
    elif [[ $val -eq 10 || $val -eq 0 ]]; then
        delayPrompt
        maimCmd delay $mode "${filename}" && notify-send -a "teiler" -t "1500" "teiler" "Screenshot taken" && exit
    fi
}

test_xrandr () {
    if [[ -n $res ]]; then
      output=$(xininfo -name); xrandr --output "$output" --mode "$res" --dryrun || { rofi -kb-move-word-forward '' -mesg  "Resolution "${res}" not available"; exit 1; }
    fi
}

screencastMenu () {
    #filename="$(cat $XDG_RUNTIME_DIR/__teiler_cast_name)"
    isRecording && STATE_RECORDING="1 Stop Recording Screencast"
    if [[ "$STATE_RECORDING" == "1 Stop Recording Screencast" ]]; then
        filename="$(cat $XDG_RUNTIME_DIR/__teiler_cast_name)"
        menu=$(echo -e "< Exit\n---\n"$STATE_RECORDING"" | _rofi -dmenu  -p "teiler > ")

        if [[ "$menu" == "< Exit" ]]; then
            exit
        fi
        if [[ $val -eq 10 ]]; then isRecording && stopRecording && sleep 2 && cd "${vid_path}"\
         && rm -f $XDG_RUNTIME_DIR/__teiler_cast_name;
        elif [[ $val -eq 1 ]]; then exit
        fi

    elif [[ -z "$STATE_RECORDING" ]]; then
        menu=$(echo -e "< Return to Main Menu\n---\n1 Fullscreen\n2 Area" | _rofi -dmenu -p "Screencast > ")
        val=$?
        filename="${vid_filemask}"
        echo "${filename}" > $XDG_RUNTIME_DIR/__teiler_cast_name

        if [[ $menu == "1 Fullscreen" ]]; then isRecording && stopRecording && sleep 2 || ffmpegCmd fullscreen;
        elif [[ $menu == "2 Area" ]]; then isRecording && stopRecording && sleep 2 || ffmpegCmd area;
        elif [[ $menu == "" ]]; then exit;
        elif [[ $menu == "< Return to Main Menu" ]]; then mainMenu; fi
    fi
}

uploadMenu () {
    menu=$(echo -e "< Return to Main Menu\n---\n1 Images\n2 Videos" | _rofi -dmenu -p "History > ")
    if [[ $menu == "1 Images" ]]; then imageMenu;
    elif [[ $menu == "2 Videos" ]]; then videoMenu;
    elif [[ $menu == "< Return to Main Menu" ]]; then mainMenu;
    elif [[ $menu == "" ]]; then exit
    fi
}

imageMenu () {
    cd "${img_path}"
    HELP="<span color='$help_color'>${edit}: Edit</span>"
    imagemenu=$(echo -e "< Return to Upload Menu\n---\n$(ls -1 -r)" | _rofi -dmenu -select "${entry}" -kb-custom-1 "${view}" -kb-custom-2 "${historyupload}" -kb-custom-3 "${edit}" -kb-custom-4 "${clip}" -mesg "${HELP}" -p "Choose > ")
    val=$?

    imagemenu2="${imagemenu%.*}"
    if [[ "${imagemenu}" == "< Return to Upload Menu" ]]; then uploadMenu; fi

    if [[ $val -eq 10 || $val -eq 0 ]]; then $viewer "${imagemenu}"; export entry="${imagemenu}"; imageMenu
    elif [[ $val -eq 12 ]]; then
        cp "${imagemenu}" "${imagemenu2}-mod.png"
        $editor "${imagemenu2}-mod.png"
        export entry="${imagemenu}"
        imageMenu
    elif [[ $val -eq 1 ]]; then exit;
    fi
}

videoMenu () {
        cd "${vid_path}"
    videomenu=$(echo -e "< Return to Upload Menu\n---\n$(ls -1)" | _rofi -dmenu -select "${entry}" -p "Choose > ")
    val=$?
    videomenu2="${videomenu%.*}"
    if [[ "${videomenu}" == "< Return to Upload Menu" ]]; then uploadMenu; fi
    if [[ $val -eq 10 || $val -eq 0 ]]; then $player "${videomenu}"; export entry="${videomenu}"; videoMenu
    elif [[ $val -eq 1 ]]; then exit
    fi
}

isRecording () { [[ -f "$SCREENCAST_PIDFILE" ]] || return 1; }

stopRecording () {
    local pid
    if [[ -a $XDG_RUNTIME_DIR/teiler_res ]]; then
        res=$(cat $XDG_RUNTIME_DIR/teiler_res)
    fi
    [[ -f $SCREENCAST_PIDFILE ]] && { pid=$(cat "$SCREENCAST_PIDFILE"); isRecording && kill "$pid"; rm "$SCREENCAST_PIDFILE"; }
    notify-send -a "teiler" -t "1500" "teiler" "Stopped recording"
    if [[ -z $rate ]]; then
        output=$(xininfo -name); xrandr --output "$output" --mode "$res"; rm -f $XDG_RUNTIME_DIR/teiler_res; return 0
    else
     if [[ -n $res ]]; then
        output=$(xininfo -name); xrandr --output "$output" --mode "$res" --rate "${rate}"; rm -f $XDG_RUNTIME_DIR/teiler_res; return 0
      fi
    fi
}

webmConvert () {
    cd && cd "${vid_path}"
   
    # convert mkv (filename) to webm (ext2)
    ffmpeg -i "${filename}" $options "${webm_name}"$ext2

    #delete the mkv file
    rm -f "${filename}"
}

slopCmd () {
    slopString=$(slop -b "$slop_border" -c "$slop_color")
    if [[ "$slopString" == *"Cancel=true"* ]]; then
        exit
 #   else eval "${slopString}"
    fi
    }

ffmpegCmd () {
    xres=$(echo "$res" | awk -F 'x' '{ print $1 }')
    yres=$(echo "$res" | awk -F 'x' '{ print $2 }')
  
    if [[ -n $res ]]; then
      res_now="$(xininfo -mon-size | sed 's/ /x/')"
    else
      res="$(xininfo -mon-size | sed 's/ /x/')"
    fi

    source "$HOME/.config/teiler/profiles/${profile}"

    echo "${filename}" > $XDG_RUNTIME_DIR/__teiler_cast_name
    if [[ $1 == "fullscreen" ]]; then
        isRecording && { notify "$time" 'Screencast already in progress'; echo "Already recording Screen"; exit 1; }
        ffmpeg_display=$(echo $DISPLAY)
        ffmpeg_offset="$(xininfo -mon-x),$(xininfo -mon-y)"
        if [[ -n $res_now ]]; then
            echo "$res_now" > $XDG_RUNTIME_DIR/teiler_res
        fi
        if [[ $res_now == $res ]]; then echo " "
        else output=$(xininfo -name); xrandr --output "$output" --mode "$res"; sleep 5; fi
        [[ -f "${vid_path}/${filename}" ]] && rm "${vid_path}/${filename}"
        if [[ -z $ffaudio ]]; then ffmpeg -f x11grab ${border} -s $res -i $ffmpeg_display+$ffmpeg_offset $encopts "${vid_path}/${filename}" &
        else ffmpeg -f x11grab ${border} -s $res -i $ffmpeg_display+$ffmpeg_offset $ffaudio $encopts "${vid_path}/${filename}" &
        fi
        echo "$!" > "$SCREENCAST_PIDFILE"
        notify-send -a "teiler" -t "1500" "teiler" "Screencast started"
    elif [[ $1 == "area" ]]; then
        read -r X Y W H G ID < <(slop -f "%x %y %w %h %g %i")
        X=$(round $X)
        Y=$(round $Y)
        W=$(round $W)
        H=$(round $H)
        isRecording && { notify "$time" 'Screencast already in progress'; echo "Already recording Screen"; exit 1; }
        ffmpeg_display=$(echo $DISPLAY); ffmpeg_offset=$(echo $(xininfo -mon-x),$(xininfo -mon-y)); slopCmd
        [[ -f "${vid_path}/${filename}" ]] && rm "${vid_path}/${filename}"
        if [[ -z $ffaudio ]]; then ffmpeg -f x11grab ${border} -s "$W"x"$H" -i $ffmpeg_display+$X,$Y $rect_encopts "${vid_path}/${filename}" &
        else ffmpeg -f x11grab ${border} -s "$W"x"$H" -i $ffmpeg_display+$X,$Y $ffaudio $rect_encopts "${vid_path}/${filename}" &
        fi
        echo "$!" > "$SCREENCAST_PIDFILE"
        notify-send -a "teiler" -t "1500" "teiler" "Screencast started"
    fi
}

maimCmd () {
    if [[ $hidecursor == "yes" ]]; then
        cursor=""
    elif [[ $hidecursor == "no" ]]; then
        cursor="--showcursor"
    fi

    if [[ $slop_color == "" ]]; then
      rect_color=""
    else
      rect_color="-c ${slop_color}"
    fi

    if [[ $slop_border == "" ]]; then
      rect_border=""
    else
      rect_border="-b ${slop_border}"
    fi

    if [[ $1 == "delay" ]]; then
        if [[ $2 == "area" ]]; then maim $cursor ${rect_border} ${rect_color} -s -d ${delay} "${img_path}/${3}";
        elif [[ $2 == "fullscreen" ]]; then maim $cursor -g $(xininfo -mon-width)x$(xininfo -mon-height)+$(xininfo -mon-x)+$(xininfo -mon-y) -d ${delay} "${img_path}/${3}";
        elif [[ $2 == "fullscreenAll" ]]; then maim $cursor -d ${delay} "${img_path}/${3}"; fi
    fi
}

askPrompt () {
    filename="$(cat $XDG_RUNTIME_DIR/__teiler_cast_name)"
    isRecording && STATE_RECORDING="Recording"
    if [[ -z "$STATE_RECORDING" ]]; then
        filename="${vid_filemask}"
        echo "${filename}" > $XDG_RUNTIME_DIR/__teiler_cast_name
        menu=$(echo -e "< Exit\n---\n1 Fullscreen\n2 Area" | _rofi -dmenu -p "> ")
        if [[ $menu == "1 Fullscreen" ]]; then isRecording && stopRecording && sleep 2 || ffmpegCmd fullscreen;
        elif [[ $menu == "2 Area" ]]; then isRecording && stopRecording && sleep 2 || ffmpegCmd area;
        elif [[ $menu == "" ]]; then exit
        fi
    else
        filename="$(cat $XDG_RUNTIME_DIR/__teiler_cast_name)"
        isRecording && stopRecording && sleep 2
        rm -f $XDG_RUNTIME_DIR/__teiler_cast_name
        webmConvert
    fi
}

delayPrompt () {
    delay=$(echo -e "$(seq 1 10)" | _rofi -dmenu -p "Choose Delay > ")
    if [[ $delay == "" ]]; then
        exit
    fi
}

helpCmd () {
    cat << EOF
teiler - a rofi-driven screen{shot,cast} utility
(C) Rasmus Steinke <rasi@xssn.at>
--screenshot                               open screenshots menu
--screencast                               open screencasts menu
--history {images,video}                   open history menus
--togglecast                               start/stop screencast
--quick image {area,fullscreen,all,active} quickly create screenshot and upload
--quick video {area,fullscreen}            quickly create screenshot and optionally upload
--quickcopy {area,fullscreen,all}          quickly create screenshot and copy
EOF
}


if [[ $1 == "--screenshot" ]]; then check_img_path; screenshotMenu
elif [[ $1 == "--screencast" ]]; then check_vid_path; screencastMenu
elif [[ $1 == "--togglecast" ]]; then check_vid_path; askPrompt
elif [[ $1 == "--history" ]]; then
    if [[ $2 == "images" ]]; then check_img_path; imageMenu
    elif [[ $2 == "videos" ]]; then check_vid_path; videoMenu
    fi
elif [[ $1 == "--quick" ]]; then
    if [[ $2 == "image" ]]; then
      check_img_path
      filename="${img_filemask}"
      if [[ $3 == "area" ]]; then maimCmd nodelay area "${filename}" && cd "${img_path}"
      elif [[ $3 == "active" ]]; then maimCmd nodelay active "${filename}" && cd "${img_path}"
      elif [[ $3 == "fullscreen" ]]; then maimCmd nodelay fullscreen "${filename}" && cd "${img_path}"
      elif [[ $3 == "all" ]]; then maimCmd nodelay fullscreenAll "${filename}" && cd "${img_path}"
      fi
    elif [[ $2 == "video" ]]; then
      check_vid_path
      filename="${vid_filemask}"
      if [[ $3 == "area" ]]; then isRecording && askPrompt && sleep 2 || ffmpegCmd area;
      elif [[ $3 == "fullscreen" ]]; then isRecording && askPrompt && sleep 2 || ffmpegCmd fullscreen;
      fi
    else echo "possible options for \"--quick\": image, video"
    fi

elif [[ $1 == "--quickcopy" ]]; then
    check_img_path;
    filename="${img_filemask}"
    if [[ $2 == "area" ]]; then copyq & maimCmd nodelay area "${filename}" && cd "${img_path}" && copyq write image/png - < "${filename}"; copyq select 0
    elif [[ $2 == "fullscreen" ]]; then copyq & maimCmd nodelay fullscreen "${filename}" && cd "${img_path}" && copyq write image/png - < "${filename}"; copyq select 0
    elif [[ $2 == "all" ]]; then copyq & maimCmd nodelay fullscreenAll "${filename}" && cd "${img_path}" && copyq write image/png - < "${filename}"; copyq select 0
    fi
elif [[ $1 == "--help" || $1 == "-h" ]]; then
    helpCmd
else
    check_img_path; mainMenu
fi

