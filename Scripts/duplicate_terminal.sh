#!/bin/bash

# Creates another terminal, opened in the same directory as the original one

CURRENT_PATH=$(pwd)
urxvt -cd "$CURRENT_PATH" & disown
