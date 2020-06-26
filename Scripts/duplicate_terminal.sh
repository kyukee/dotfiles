#!/bin/bash

# Creates another terminal, opened in the same directory as the original one

CURRENT_PATH=$(pwd)
kitty -d "$CURRENT_PATH" & disown
