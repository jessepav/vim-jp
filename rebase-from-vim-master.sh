#!/bin/bash

branch=$(git branch --show-current)

if [[ -z "$branch" ]]; then
    echo "No current branch available!"
    exit 1
elif [[ "$branch" == "master" ]]; then
    echo "You're on the master branch - checkout a topic branch"
    exit 1
fi

git rebase origin/master master
git rebase vim/master master
git rebase master $branch
