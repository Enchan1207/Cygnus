#!/bin/bash
#
# release preparation script
#

# fetch and extract sources of Lua
./startup.sh

# switch to release branch
RELEASE_BRANCH=release
if [ `git rev-parse --verify $RELEASE_BRANCH 2>/dev/null` ]; then
    git switch $RELEASE_BRANCH
else
    git switch -c $RELEASE_BRANCH
fi

# pull
git pull origin $RELEASE_BRANCH 2>/dev/null || echo "remote branch not found"

# add sources to git forcibly
git add -f Sources/**/*

# commit
git commit -m "[Add] add source files of Lua (automated) [no ci]"

# push
git push origin $RELEASE_BRANCH
