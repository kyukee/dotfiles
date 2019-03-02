#/usr/bin/python
import sys, shutil, os


# by default, these are all preceded by $HOME
file_list = {
    '.config/dunst',
    '.config/git',
    '.config/i3',
    '.config/mpd/mpd.conf',
    '.config/mpv/scripts',
    '.config/mpv/mpv.conf',
    '.config/neofetch',
    '.config/rofi',
    '.config/sublime-text-3/Packages/Colorsublime - Themes',
    '.config/sublime-text-3/Packages/Material Theme',
    '.config/sublime-text-3/Packages/User',
    '.config/teiler/profiles',
    '.config/teiler/config',
    '.config/compton.conf',
    '.fonts',
    '.ncmpcpp/config',
    '.zsh',
    'root/etc/sddm.conf',
    'root/usr/share/sddm',
    'Scripts',
    '.bash_aliases',
    '.bash_profile',
    '.bashrc',
    '.redshiftgrc',
    '.Xresources',
    '.zprofile',
    '.zshrc',}


# for files that are not in $HOME
path_alterations = {
    'root/etc/sddm.conf' : '',
    'root/usr/share/sddm' : ''}


# the script doesn't do anything with these files
excluded_files = {
    'dotfiles.py',
    'keymap.map',
    'README.md',
    '.git',
    '.gitignore'}


# setup some variables
thisDir = os.path.dirname(os.path.realpath(__file__))
home = os.path.expanduser('~')


'''
    recursive function used to copy folders
'''
def recursive_copy(src, dst):

    for item in os.listdir(src):
        s = os.path.join(src, item)
        d = os.path.join(dst, item)

        if os.path.isdir(s):

            if not os.path.exists(d):
                os.makedirs(d)

            recursive_copy(s, d)

        else:
            print( 'copying ', s, 'to ',  d)
            shutil.copy2(s, d)


'''
    Executes 'mv src dest'
'''
def copyFile(src, dest):
    try:
        if (os.path.isdir(src)):

            if not os.path.exists(dest):
                os.makedirs(dest)

            recursive_copy(src, dest)
        else:
            shutil.copy2(src, dest)

    except shutil.Error as e:
        print( 'Error: ' ,  e)

    except IOError as e:
        print( 'Error: ' , e)


### main code ###
if sys.argv[1] == 'install':
    for item in file_list:
        src = thisDir + '/' + item

        path = home
        if (item in path_alterations):
            path = path_alterations[item]

        dest = path + '/' + item
        print( 'copying ', src, 'to ',  dest)
        copyFile(src, dest)

elif sys.argv[1] == 'backup':
    for item in file_list:
        dest = thisDir + '/' + item

        path = home
        if (item in path_alterations):
            path = path_alterations[item]

        src = path + '/' + item
        print( 'copying ', src, 'to ',  dest)
        copyFile(src, dest)

else:
    print( 'Possible arguments are \'install\' or \'backup\'')
