#!/bin/bash

PROJDIR=$(realpath $(dirname "$0")/..)

cd $PROJDIR

range=$(git fetch -v upstream |& rg -o -m 1 '[[:xdigit:]]+\.\.[[:xdigit:]]+')
git merge --no-edit upstream/master &> /dev/null
[[ -n "$range" ]] && git lg $range
