#!/bin/bash
#
# Release preparation script
#
# @2024 Enchan1207.
#

# スタートアップスクリプトを呼び出してLuaコアのソースを取得・配置
./startup.sh

# リリースブランチに切り替え
RELEASE_BRANCH=release
if [ `git rev-parse --verify $RELEASE_BRANCH 2>/dev/null` ]; then
    git switch $RELEASE_BRANCH
else
    git switch -c $RELEASE_BRANCH
fi

# リモートからpull
git pull origin $RELEASE_BRANCH 2>/dev/null || echo "remote branch not found"

# Luaコアのソースを強制的にaddしてcommit
git add -f Sources/LuaCore/**/*
git commit -m "[Add] add source files of Lua (automated) [no ci]"

# push
git push origin $RELEASE_BRANCH
