#!/bin/bash
#
# download Lua and extract to source directory
#
LUA_VERSION="5.4.6"

# 作業ディレクトリを生成
mkdir -p work && cd work

# ソースファイルを取得
LUA_DIR="lua-${LUA_VERSION}"
LUR_ARCHIVE="${LUA_DIR}.tar.gz"
if [ ! -e "$LUR_ARCHIVE" ]; then
    LUA_SOURCE_URL="https://www.lua.org/ftp/${LUR_ARCHIVE}"
    echo "Download Lua ${LUA_VERSION} from ${LUA_SOURCE_URL}..."
    wget "$LUA_SOURCE_URL"
else
    echo "Lua source archive are already downloaded"
fi

# 展開
if [ ! -e "$LUA_DIR" ]; then
    echo "Extracting..."
    tar xzf "$LUR_ARCHIVE"
else
    echo "Lua sources are already deployed"
fi

cd "$LUA_DIR/src"

# ソースとヘッダをSPMのソースディレクトリに移動
LUA_SOURCE_DIR="../../../Sources/LuaSwift"
LUA_INCLUDE_DIR="${LUA_SOURCE_DIR}/include"
echo "Move files to source directory..."
mkdir -p "$LUA_INCLUDE_DIR"
mv *.c "$LUA_SOURCE_DIR"
mv *.h "$LUA_INCLUDE_DIR"
