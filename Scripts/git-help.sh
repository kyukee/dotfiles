#!/bin/bash

printf "############################################################################"
printf "\n"
printf "init /path/to/directory            create local repo\n"

printf "\n"

printf "remote add 'label' 'repo url'      connect to a github repo (for no login use git+ssh://git@github.com/username/reponame.git)\n"
printf "remote rm 'label'                  remove connection to github repo\n"
printf "remote -v                          show current connections\n"

printf "\n"

printf "status                             current directory status\n"
printf "reset --hard HEAD~n                discard the previous n commits\n"
printf "git push origin HEAD --force       the reset command for deleting commits is only local. this updates the remote repository\n"

printf "\n"

printf "add 'filename'                     add a file to the staging area (* for all) (-u for modified or deleted files)\n"
printf "reset 'filename'                   remove a file from the staging area (* for all)\n"
printf "git rm --cached 'filename'         untrack a file\n"
printf "commit -m 'Description'            add staged files to local repo\n"

printf "\n"

printf "log                                show commit history\n"
printf "diff HEAD                          see differences since last commit\n"
printf "checkout -- 'filename'             restore to last commit of the file\n"

printf "\n"

printf "checkout -b 'new branch'           create new branch\n"
printf "checkout 'branch name'             switch to a different branch\n"
printf "checkout -b 'remote branch' 'name of remote'/'remote branch'            check out a remote branch\n"
printf "checkout -t 'name of remote'/'remote branch'                            shorter alternative\n"

printf "\n"

printf "git fetch --all                    for resetting a file to HEAD when there are conflicts\n"
printf "git reset --hard origin/master     now you can discard the local changes\n"

printf "\n"


printf "pull 'label' 'repo branch'         pull current github repo to local repo\n"
printf "push 'label' 'repo branch'         push local changes to github repo\n"
printf "                                note: use -u to remember parameters\n"
printf "                                and next time just write git push\n"

