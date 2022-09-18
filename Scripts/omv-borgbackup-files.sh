#!/bin/bash

BORG_REPO_SHARED_FOLDER="/srv/dev-disk-by-uuid-9cb27bb4-b733-4a93-a184-a4782b168419/Backup"
BORG_REPO_NAME="Sync"

# BORG_REPO_PASSWORD='very_secure_password'

BORG_BACKUP_PATH="/srv/dev-disk-by-uuid-67f059ba-aa60-43ea-b852-7bf2e9bee931/Sync"

BORG_ARCHIVE_PREFIX="weekly-backup"
BORG_ARCHIVE_TIME_FORMAT="$(date +'%Y-%m-%dT%H:%M:%S')"

# check the shared folder is mounted
if [ ! -d "${BORG_REPO_SHARED_FOLDER}" ]; then
    echo "Shared folder directory does not exist.  Exiting..."
    exit 1
fi

# set backup directory and create it if it doesn't exist
BORG_REPO="${BORG_REPO_SHARED_FOLDER}/${BORG_REPO_NAME}"
mkdir -p "${BORG_REPO}"

# enable encryption if password is provided
if [ -n "${BORG_REPO_PASSWORD}" ]; then
    echo "Encryption is enabled"
    export BORG_PASSPHRASE="${BORG_REPO_PASSWORD}"
fi

# some helpers and error handling:
info() { printf "\n%s %s\n\n" "$( date )" "$*" >&2; }
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

# first run - init borg directory
if [ ! $(borg list "${BORG_REPO}") ] ; then
    info "Initializing a new repository"

    if [ -n "${BORG_REPO_PASSWORD}" ]; then
        borg init -e repokey "${BORG_REPO}"
    else
        borg init -e none "${BORG_REPO}"
    fi
fi

info "Starting backup"

# Backup the directories into an archive named after
# the machine this script is currently running on:

borg create                          \
    --verbose                        \
    --filter AME                     \
    --list                           \
    --stats                          \
    --show-rc                        \
    --compression lz4                \
    --exclude-caches                 \
                                     \
    "${BORG_REPO}::${BORG_ARCHIVE_PREFIX}-${BORG_ARCHIVE_TIME_FORMAT}" \
    "${BORG_BACKUP_PATH}"            \

backup_exit=$?

info "Pruning repository"

# The prefix is very important to limit prune's operation to
# this machine's archives and not apply to other machines' archives also:

borg prune "${BORG_REPO}"            \
    --list                           \
    --prefix "${BORG_ARCHIVE_PREFIX}" \
    --show-rc                        \
    --keep-weekly   4                \
    --keep-monthly  3                \

prune_exit=$?

info "Compacting repository"

# actually free repo disk space by compacting segments

borg compact "${BORG_REPO}"

compact_exit=$?

# use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))
global_exit=$(( compact_exit > global_exit ? compact_exit : global_exit ))

if [ ${global_exit} -eq 0 ]; then
    info "Backup, Prune, and Compact finished successfully"
elif [ ${global_exit} -eq 1 ]; then
    info "Backup, Prune, and/or Compact finished with warnings"
else
    info "Backup, Prune, and/or Compact finished with errors"
fi

exit ${global_exit}
