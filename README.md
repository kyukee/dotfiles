## installed software


### interface
+ **i3-gaps-git** _window manager_  a fork of i3wm with more features, including gaps
  + **i3lock-fancy-git**  _lockscreen_  blurs background, adds lock icon and text
  + **i3status** _status bar_  generates status bar to use with i3bar
+ **sddm** _display manager_  customizable with qml
  + **sddm-deepin-theme**  personal modified version, very minimal
+ **rxvt-unicode** _terminal emulator_  lightweight, extensible with perl
  + **urxvt-clipboard**  makes urxvt play nice with the x clipboard
  + **urxvt-resize-font**  enables on the fly font resizing.  very useful for small screens
+ **conky** _status bar_ lightweight system monitor used to configure the system bar
+ **feh** _background setter_  it's simple and does everything you need
+ **ahoviewer** _image viewer_  gtk2 image viewer, manga reader and booru browser (also supports .gif)
+ **xflux** _screen temperature daemon_  reduces eye strain in reduced light
+ **dunst**  notification daemon

### internet
+ **connman** _wifi_  wireless lan network manager
  + **connman_dmenu-git**  dmenu integration for connman
+ **weechat** _irc client_  extensible irc client with great community support
+ **newsbeuter** _rss feed reader_  simple rss feed reader for the terminal
+ **firefox** _web browser_  golden standard web browser
  + **greasemonkey**  userscript manager
    + **4chan x**  make 4chan more usable
    + **kissanime/cartoon downloader**  when there isn't a decent torrent for it
    + **youtube +**  add useful some features to youtube
  + **stylus**  user styles manager
  + **https everywhere**  force https where possible
  + **ublock origin**  ad and nuisance blocker
  + **new tab homepage**  custumize new tab url
  + **black elegance theme**  works well with the css
  + **easy screenshot**  easily capture screenshots
  + **imagus**  show images/videos from links with a mouse hover
  + **simple translate**  quickly translate selected text on web page
  + **tab session manager**  save and restore the state of windows and tabs
+ **w3m** _web browser_  console web browser, used for image previews in ranger
+ **qbittorrent**  bittorrent client
+ **openssh**  ssh client

### media
+ **alsa-lib** _audio driver_  alternative implementation of linux sound support
  + **alsa-utils** _gui_  provides (among other utilities) the 'alsamixer'
+ **pulseaudio** _audio daemon_  some programs can't have audio without it
+ **mpd** _music player_  gold standard music player daemon
+ **ncmpcpp** _music player_  fast and configurable mpd client
+ **mpv** _video player_  do-it-all video player for streaming and playing local media
+ **hachoir-metadata-gtk** _metadata viewer_  extract metadata from media files ()
  + note: create a 'thunar custom action' to be able to open any media file metadata

### office
+ **libreoffice** _office suite_  word processor, spreadsheet and presentation graphics software
+ **zathura** _document viewer_  lightweight extensible document viewer with a vim-like interface
  + **mupdf** _pdf rendering lib_  alternative to poppler
  + **zathura-cb** _comic book plugin_  for reading manga with zathura
+ **scrot** _screenshotter_  simple

### programming
+ **sublime text 3** _text editor_  install 'package control' with (Ctrl + shift + p) for addons and themes
  + **bracket highlighter**  my list of plugins
  + **color scheme editor**
  + **color sublime themes**
  + **find key conflicts**
  + **git**
  + **git gutter**
  + **material theme**
  + **side bar enhancements**
  + **sub notify**
  + **terminality**
  + **terminal view**
  + **unicode escape**
+ **python**  allows for easy scripting
+ **lua**  another scripting language
+ **jre**  java runtime environment

### utilities
+ **rofi** _dynamic menu_ application launcher
  + **fmenu-rofi.sh**  allows to browse your files in rofi
  + **rofi-alias.sh**  adds aliases to the rofi list of commands
  + **teiler-alt.sh**  personal modified version of teiler. captures screenshots and screencasts
+ **thunar** _file manager_  main file manager
  + **thunar volman**  automatic management of removable devices
+ **ranger** _file manager_  lightweight terminal file manager. use w3m for image previews
+ **yay** _aur helper_  browsing aur made easy, better replacement for yaourt
+ **htop** _task manager_  interactive process viewer
+ **tlp** _power management_  fire and forget power manager
+ **gnome-calculator** _power management_  gnome scientific calculator
+ **ca-certificates-utils**  useful for wifi connections
+ **zip**  compressor/archiver
+ **p7zip**  compressor/archiver
+ **unzip**  extract and view files in zip archives
+ **neofetch**  cli system information tool
+ **gcolor3**  simple gtk color selection dialog

### fonts / themes
+ **lxappearance** _theme switcher_  easily change most customization options with one program
+ **terminus (ttf)** _bitmap monospace font_  ttf version of terminus, thicker and more readable (use size 14)
+ **font awesome** _icon font_  set of icons, used to configure the status bar
+ **adapta-nokto** _gtk theme_  flat gtk theme with custom red highlights
+ **clarity** _icon theme_  '-albus' for the white variant, other options include evopop, flat remix and paper
+ **openzone** _mouse theme_  'white slim' version

### fun applications
+ **bastet**  slightly more advanced tetris
+ **pipes**  create pipes that move randomly in the terminal
+ **cmatrix**  matrix style terminal
+ **mongoclock**  terminal clock

### scripts and tools
+ **feh_browser**  cycle between images in a folder with feh
+ **tiles**  display the current terminal colors and colored text over colored tiles
+ **colorz**  generate a color pallete from any image (useful for creating themes)
+ **startpage**  simple customizable startpage (modded version of yukisuki by fuyuneko)
+ **4chanx settings**  .json file with all the settings configured
+ **youtube+ settings**  just import it to easily customiza all settings

## notes
Consider this my checklist of things that i want when installing a new os.  
dotfiles.py can be used to install all the necesssary config files in their directories or to make a backup of the config files.  
Run it by using _python dotfiles.py arg_, where arg can be _install_ or _backup_.  
There's also a list for excluded files, among others. Look at the code for more info.
