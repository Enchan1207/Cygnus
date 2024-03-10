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

# masterブランチをマージ ここが失敗すると何の意味もないのでアクションごとコケさせる
git merge --allow-unrelated-histories gmaster || exit 1

# Luaコアの.gitディレクトリを削除し、強制的にaddしてcommit
rm -rf Sources/LuaSwiftCore/lua/.git
git add -f Sources/LuaSwiftCore/lua
git commit -m "[Add] add source files of Lua (automated) [no ci]"

# push
git push -f origin $RELEASE_BRANCH
