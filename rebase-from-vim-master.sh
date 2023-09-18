#!/bin/bash

branch=$(git branch --show-current)

if [[ -z "$branch" ]]; then
    echo "No current branch available!"
    exit 1
elif [[ "$branch" == "master" ]]; then
    echo "You're on the master branch - checkout a topic branch"
    exit 1
fi

if [[ $(git rev-parse master) != $(git rev-parse origin/master) ]]; then
    echo "Rebasing master onto origin/master..."
    git rebase origin/master master
else
    echo "master already up-to-date with origin/master"
fi
git rebase vim/master master
git rebase master $branch
