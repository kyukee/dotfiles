##!/bin/bash

printf "\
 ---------------
# WINDOW

## open new window
    F2

## close window
    ctrl+F6

## move between windows
    F3 / F4    |   alt+j / alt+k

## rename window
    F8

 ---------------
# SESSION

## list sessions
    byobu ls
 
## create new session
    byobu new -s <session-name>

## delete session
    byobu kill-session -t <session-name>

## detach session
    F6

## detach session without logging out
    shift+F6

## change between sessions
    alt+up_arrow   |   alt+down_arrow

## rename session
    ctrl-F8

 ---------------
# OTHER

## reload profile
    F5

## toggle through status lines
    shift+F5

## toggle byobu keybinds
    shift+F12

## open configuration menu
    F1

 ---------------
"