#!/bin/bash

if [ $# -eq 0 ];then 
    bat  --paging=never -l bash ~/Scripts/.commands-help.txt
else
    cat ~/Scripts/.commands-help.txt | grep --color -i -C 3 $1
fi
