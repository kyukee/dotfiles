#!/bin/bash

# Selected options for "emacsclient"
#
# -c          Create a new frame instead of trying to use the current
#             Emacs frame.
#
# -e          Evaluate the FILE arguments as ELisp expressions.
#
# -n          Don't wait for the server to return.
#
# -t          Open a new Emacs frame on the current terminal.

# check whether an Emacs server is already running
pgrep -l "^emacs$" > /dev/null

# check result of last command
if [ $? -ne 0 ]; then
    # start Emacs server
    /usr/bin/emacs "$@" &
else

    # check number of arguments given to this script
    if [ "$#" -ne "0" ]; then
        # open file in existing Emacs instance and focus Emacs
        /usr/bin/emacsclient -n "$@"
    else
        # if no argument is given, just focus Emacs
        /usr/bin/emacsclient -n -e "(select-frame-set-input-focus (selected-frame))" > /dev/null
    fi
fi
