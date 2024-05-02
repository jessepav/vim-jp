#!/bin/bash
# Generates tag files for use with GNU Global

PROJDIR=$(realpath $(dirname "$0")/..)

cd $PROJDIR
fd -g '*.{c,h}' -d 1 src > gtags.files
gtags -vi --sqlite3
