#!/bin/bash
#
# Download Latest version of Lua and extract to source directory
#
# @2024 Enchan1207.
#

# 作業ディレクトリを作り、移動
WORK_DIR=work
echo "Making and moving to working directory ($WORK_DIR)..."
mkdir -p $WORK_DIR
cd $WORK_DIR

# 作業ディレクトリに前回展開したluaソースがあれば削除
LUA_ARCHIVE_DIR=lua
if [ -e $LUA_ARCHIVE_DIR ]; then
    echo "There is extracted Lua source directory ($LUA_ARCHIVE_DIR). removing..."
    rm -rf $LUA_ARCHIVE_DIR
fi

# tarが落ちていればまとめてスキップする
LUA_ARCHIVE_NAME=lua.tar.gz
if [ -e $LUA_ARCHIVE_NAME ]; then
    echo "Cached Lua tarball ($LUA_ARCHIVE_NAME) found."
else
    # GitHub APIを使って最新リリースの情報を取得
    echo "Fetching latest release information of Lua from GitHub (lua/lua)..."
    LUR_RELEASE_INFO="$(wget -O - https://api.github.com/repos/lua/lua/releases/latest)"
    if [ $? -ne 0 ]; then
        echo "GitHub API invocation failed."
        exit 1
    fi

    # URLを取り出す
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

    # アーカイブをダウンロード
    echo "Downloading Lua source..."
    wget -O "$LUA_ARCHIVE_NAME" "$LUA_SOURCE_URL"
    if [ $? -ne 0 ]; then
        echo "Failed to download source file archive."
        exit 1
    fi
fi

# アーカイブを展開し、ディレクトリ名を修正
echo "Extracting archive..."
tar xzf $LUA_ARCHIVE_NAME
mv lua-lua-* $LUA_ARCHIVE_DIR

# ビルドにあたり不要なファイルを削除
echo "Removing unnecessary files..."
cd $LUA_ARCHIVE_DIR
rm -f ljumptab.h lua.c onelua.c ltests.*
cd ..

# ソースとヘッダをSPMのソースディレクトリに移動
echo "Moving source files to package directory..."
LUA_SOURCE_DIR="../Sources/LuaSwiftCore"
LUA_INCLUDE_DIR="${LUA_SOURCE_DIR}/include"
mkdir -p "$LUA_INCLUDE_DIR"
mv $LUA_ARCHIVE_DIR/*.c "$LUA_SOURCE_DIR"
mv $LUA_ARCHIVE_DIR/*.h "$LUA_INCLUDE_DIR"

echo "Finished."
