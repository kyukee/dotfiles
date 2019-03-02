#!/bin/bash

printf "Local Status Symbols

✔ 	repository clean
●n 	there are n staged files
✖n 	there are n unmerged files
✚n 	there are n changed but unstaged files
… 	there are some untracked files

Branch Tracking Symbols

↑n 	ahead of remote by n commits
↓n 	behind remote by n commits
↓m↑n 	branches diverged, other by m commits, yours by n commits"