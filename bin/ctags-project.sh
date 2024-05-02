#!/bin/bash

PROJDIR=$(realpath $(dirname "$0")/..)

cd $PROJDIR/src

if [[ $# -eq 0 ]]; then
    fd -g '*.{c,h}' -d 1 | update-ctags tags
else
    update-ctags tags "$@"
fi
