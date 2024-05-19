#!/bin/bash

PROJDIR=$(realpath $(dirname "$0")/..)

cd $PROJDIR

git fetch -v upstream
git merge --no-edit upstream/master
