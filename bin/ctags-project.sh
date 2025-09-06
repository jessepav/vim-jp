#!/bin/bash

PROJDIR=$(realpath $(dirname "$0")/..)

cd $PROJDIR

fd -g '*.{c,h}' -d 1 src > gtags.files
xargs update-ctags tags  < gtags.files
