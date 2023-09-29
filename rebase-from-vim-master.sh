#!/bin/bash

branch=$(git branch --show-current)

if [[ -z "$branch" ]]; then
    echo "No current branch available!"
    exit 1
elif [[ "$branch" == "master" ]]; then
    echo "You're on the master branch - checkout a topic branch"
    exit 1
fi

echo "Setting master to origin/master..."
git branch --no-track -f master origin/master
echo "Merging vim/master..."
git co master
git merge --no-edit vim/master
echo "Rebasing $branch onto master..."
git rebase master $branch
