#!/bin/bash
#
# Download Latest version of Lua and extract to source directory
#
# @2024 Enchan1207.
#

# GitHub APIを使って最新リリースの情報を取得
# (lua/luaはミラーなので本来はlua.orgからダウンロードすべきだが、ここにバージョン情報を直書きするよりはマシ)
echo "Fetching latess release information of Lua from GitHub (lua/lua)..."
LUR_RELEASE_INFO="$(wget -q -O - https://api.github.com/repos/lua/lua/releases/latest)"
if [ $? -ne 0 ]; then
    echo "GitHub API invocation failed."
    exit 1
fi

# ソースファイルアーカイブへのリンクを取り出す
echo "Looking for URL to source file archive..."
JQ="$(which jq)"
if [ $? -eq 0 ]; then
    echo "Use jq to parse release info."
    LUA_SOURCE_URL="$(echo $LUR_RELEASE_INFO | $JQ -r '.tarball_url')"
else
    echo "Use generic commands to parse release info."
    LUA_SOURCE_URL="$(echo $LUR_RELEASE_INFO | grep tarball_url | sed -r 's/.*(https:\/\/.+)\",$/\1/')"
fi
echo "Source file URL: ${LUA_SOURCE_URL}"

# 作業ディレクトリを生成、移動
echo "Making work directory..."
rm -rf work && mkdir -p work && cd work

# ソースファイルを取得・展開し、簡単のためディレクトリ名を変更
echo "Downloading Lua source..."
wget -O "lua.tar.gz" "$LUA_SOURCE_URL"
if [ $? -ne 0 ]; then
    echo "Failed to download source file archive."
    exit 1
fi
tar xzf lua.tar.gz
mv lua-lua-* lua

# ビルドにあたり不要なファイルを削除
echo "Removing unnecessary files..."
rm -f lua/ljumptab.h lua/lua.c lua/onelua.c lua/ltests.*

# ソースとヘッダをSPMのソースディレクトリに移動
echo "Moving source files to package directory..."
LUA_SOURCE_DIR="../Sources/LuaSwiftCore"
LUA_INCLUDE_DIR="${LUA_SOURCE_DIR}/include"
mkdir -p "$LUA_INCLUDE_DIR"
mv lua/*.c "$LUA_SOURCE_DIR"
mv lua/*.h "$LUA_INCLUDE_DIR"

# 作業ディレクトリを削除
echo "Removing work directory..."
cd ..
rm -rf work

echo "Finished."
