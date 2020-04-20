#/usr/bin/python
import sys, shutil, os


# by default, these are all preceded by $HOME
file_list = {
    '.config/dunst',
    '.config/git',
    '.config/gsimplecal',
    '.config/i3',
    '.config/mpd/mpd.conf',
    '.config/mpv/scripts',
    '.config/mpv/mpv.conf',
    '.config/neofetch',
    '.config/rofi',
    '.config/yay/',
    '.config/sublime-text-3/Packages/Colorsublime - Themes/DinkDonk.tmTheme',
    '.config/sublime-text-3/Packages/Colorsublime - Themes/rainbow.tmTheme',
    '.config/sublime-text-3/Packages/Material Theme',
    '.config/sublime-text-3/Packages/User',
    '.config/teiler/profiles',
    '.config/picom/picom.conf',
    '.config/teiler/config',
    '.config/minidlna/minidlna.conf',
    '.config/micro',

    '.fonts',
    '.ncmpcpp/config',
    '.mozilla/firefox/lpdzbf4s.default/chrome/userChrome.css',

    '.atom/config.cson',
    '.atom/atom-package-list.txt',
    '.atom/keymap.cson',
    '.atom/snippets.cson',
    '.atom/styles.less',

    '.config/Code - OSS/User/keybindings.json',
    '.config/Code - OSS/User/settings.json',
    '.config/Code - OSS/User/tasks.json',

    'root/etc/acpi/actions',
    'root/etc/default/grub',
    'root/etc/sddm.conf',
    'root/etc/systemd/journald.conf',
    'root/etc/pulse/default.pa',
    'root/sys/devices/pci0000:00/0000:00:02.0/drm/card0/card0-eDP-1/intel_backlight/brightness',
    'root/usr/share/kbd/keymaps/i386/qwerty/pt-latin9.map',
    'root/usr/share/sddm/faces',
    'root/usr/share/sddm/themes/deepin',

    'Documents/icomoon-awesome-brankic-feather',
    'Scripts',
    'Workspaces/VScode',
    
    '.bash_aliases',
    '.bash_profile',
    '.bashrc',
    '.fmenu-ignore',
    '.redshiftgrc',
    '.Xresources',
    '.zprofile',
    '.zsh',
    '.zshrc',
}


# for files that are not in $HOME
path_alterations = {
    'example.txt' : '/new/path/example.txt',
}


# the script excludes these files
excluded_files = {
    '.config/sublime-text-3/Packages/User/Package Control.cache',
    '.config/sublime-text-3/Packages/User/Package Control.last-run',
    '.config/micro/buffers',
    '.config/micro/backups',
    'Scripts/linux64',
    'dotfiles.py',
    'keymap.map',
    'README.md',
    '.git',
    '.gitignore',
}


# setup some variables
thisDir = os.path.dirname(os.path.realpath(__file__))
home = os.path.expanduser('~')


'''
    check if any item in a list is excluded
'''
def any_excluded(items):
    for item in items:
        for ex_item in excluded_files:
            if item.endswith(ex_item):
                return True
    return False


'''
    function used to copy a single file
'''
def copy_file(src, dest):

    if any_excluded([src, dest]):
        return

    dirname = os.path.dirname(dest)

    if not os.path.exists(dirname):
        os.makedirs(dirname)
        print( 'copying ', src, 'to ',  dest)
        shutil.copy2(src, dest) 

    else:

        if os.path.exists(dest):
            # check time of last modification
            if ((os.stat(src).st_mtime - os.stat(dest).st_mtime) < 1): 
                return

        print( 'copying ', src, 'to ',  dest)
        shutil.copy2(src, dest)


'''
    recursive function used to copy folders
'''
def copy_folder(src, dest):

    if any_excluded([src, dest]):
        return

    if os.path.isdir(src):
        if not os.path.exists(dest):
            os.makedirs(dest)

    for item in os.listdir(src):
        s = os.path.join(src, item)
        d = os.path.join(dest, item)

        if os.path.isdir(s):
            copy_folder(s, d)
        else:            
            copy_file(s, d)


'''
    copy an item, which can be a file or folder
'''
def copyItem(src, dest):
    try:
        if (os.path.isdir(src)):
            copy_folder(src, dest)
        else:
            copy_file(src, dest)

    except Exception as e:
        print( 'Error: ' , e)


'''
    displays helpful information
'''
def help():
    print( 'Possible arguments are \'install\' or \'backup\'')


### main code ###

# sys.argv[0] is the filename
if len(sys.argv) > 1:

    if sys.argv[1] == 'install':
        for item in file_list:
            src = thisDir + '/' + item

            path = home
            if (item.startswith('root')):
                path = ''
                item = item.replace('root/', '')

            if (item in path_alterations):
                path = path_alterations[item]

            dest = path + '/' + item
            copyItem(src, dest)

    elif sys.argv[1] == 'backup':
        for item in file_list:
            dest = thisDir + '/' + item

            path = home
            if (item.startswith('root')):
                path = ''
                item = item.replace('root/', '')

            if (item in path_alterations):
                path = path_alterations[item]

            src = path + '/' + item
            copyItem(src, dest)

    else:
        help()

else:
    help()
