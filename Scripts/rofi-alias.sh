#!/bin/bash
#   Returns a list of aliases in .bashrc, to be used in rofi

cat .bashrc | grep  alias.*= | awk -F'[ =]' '{print $2}'
