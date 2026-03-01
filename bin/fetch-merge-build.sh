#!/bin/bash

shopt -s extglob

PROJDIR=$(realpath $(dirname "$0")/..)

cd $PROJDIR

if [[ "$1" == @(-f|--fetch) ]]; then
    range=$(git fetch -v upstream |& rg -o -m 1 '[[:xdigit:]]+\.\.[[:xdigit:]]+')
    [[ -n "$range" ]] && git lg $range || echo "Already up-to-date"
elif [[ "$1" == @(-m|--merge) ]]; then
    git merge --no-edit upstream/master
elif [[ "$1" == @(-p|--merge-push) ]]; then
    git merge --no-edit upstream/master
    git push
elif [[ "$1" == @(-b|--build) ]]; then
    cd src
    make -j 2 && make install
    cd /opt/vim9/share/vim/vim92/plugin
    # We're going to leave these alone:
    # matchparen.vim tohtml.vim
    for plugin in getscriptPlugin.vim gzip.vim logiPat.vim \
                  manpager.vim netrwPlugin.vim openPlugin.vim rrhelper.vim \
                  spellfile.vim tarPlugin.vim tutor.vim vimballPlugin.vim \
                  zipPlugin.vim; do
        mv -fv $plugin $plugin.disabled
    done
else
    echo "Usage: fetch-merge.sh [-f, --fetch] [-m, --merge] [-p, --merge-push] [-b, --build]"
    exit
fi
