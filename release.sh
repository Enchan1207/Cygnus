#!/bin/bash
#
# Release preparation script
#
# @2024 Enchan1207.
#

# スタートアップスクリプトを呼び出してLuaコアのソースを取得・配置
./startup.sh

# リモートの変更を取得
git fetch

# リリースブランチに切り替え
RELEASE_BRANCH=release
git switch $RELEASE_BRANCH || git switch -c $RELEASE_BRANCH

# Luaコアのソースを強制的にaddしてcommit
git add --all
git add -f Sources/LuaSwiftCore/**/*
git commit -m "[Add] add source files of Lua (automated) [no ci]"

# push
git push -f origin $RELEASE_BRANCH
