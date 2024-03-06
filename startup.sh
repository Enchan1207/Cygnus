#!/bin/bash
#
# Download Latest version of Lua and extract to source directory
#
# @2024 Enchan1207.
#

# Luaコアのソースディレクトリに移動
cd Sources/LuaSwiftCore
if [ $? -ne 0 ]; then
    echo "Source directory of Lua core not found."
    exit 1
fi

# Luaがなければクローン
echo "Looking for Lua repository..."
if [ ! -e lua ]; then
    echo "Cloning..."
    git clone https://github.com/lua/lua
fi
cd lua

# フェッチして最新のタグを取得し、チェックアウト
echo "Fetching latest tag..."
git fetch
LATEST_TAG=$(git tag -l | sed -rn "/^v[0-9]+\.[0-9]+(\.[0-9]+)?$/p" | tail -n 1)
echo "Latest version: $LATEST_TAG"
git checkout $LATEST_TAG

echo "Finished."
