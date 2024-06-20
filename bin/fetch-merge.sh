#!/bin/bash

shopt -s extglob

PROJDIR=$(realpath $(dirname "$0")/..)

cd $PROJDIR

if [[ "$1" == @(-f|--fetch) ]]; then
    range=$(git fetch -v upstream |& rg -o -m 1 '[[:xdigit:]]+\.\.[[:xdigit:]]+')
    [[ -n "$range" ]] && git lg $range || echo "Already up-to-date"
elif [[ "$1" == @(-m|--merge) ]]; then
    git merge --no-edit upstream/master
else
    echo "Usage: fetch-merge.sh [-f, --fetch] [-m, --merge]"
    exit
fi
