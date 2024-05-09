#!/bin/bash

# INSTALL_DIR=$HOME/bin
INSTALL_DIR=$HOME/bin
echo "所有应用安装到：${INSTALL_DIR}"
QUIET='-q'

if [ ! -d $INSTALL_DIR ];then
    echo "安装目录不存在，创建${INSTALL_DIR}目录"
    mkdir -p $INSTALL_DIR
fi


# Install eza
echo "安装eza..."
wget $QUIET -c -c https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz -O - | tar xz
mv eza $INSTALL_DIR/
echo "eza安装结束"


# Install bat, 出新版本时，需要手动更新链接
VERSION="v0.24.0"
echo "安装bat..."
wget $QUIET -c -c https://github.com/sharkdp/bat/releases/download/$VERSION/bat-$VERSION-x86_64-unknown-linux-gnu.tar.gz -O - | tar xz
mv bat-$VERSION-x86_64-unknown-linux-gnu/bat $INSTALL_DIR/
echo "bat安装结束"


# Install btop
echo "安装btop..."
wget $QUIET -c -c https://github.com/aristocratos/btop/releases/latest/download/btop-x86_64-linux-musl.tbz
tar -xf btop-x86_64-linux-musl.tbz
mv btop/bin/btop $INSTALL_DIR/
echo "btop安装结束"


# install ncdu
echo "安装ncdu..."
wget $QUIET -c https://dev.yorhel.nl/download/ncdu-2.4-linux-x86_64.tar.gz -O - | tar xz
mv ncdu $INSTALL_DIR/
echo "ncdu安装结束"


# fdfind
echo "安装fdfind..."
VERSION="v10.0.0"
wget $QUIET -c https://github.com/sharkdp/fd/releases/download/$VERSION/fd-$VERSION-x86_64-unknown-linux-gnu.tar.gz -O - | tar xz
mv fd-$VERSION-x86_64-unknown-linux-gnu/fd $INSTALL_DIR/
echo "fdfind安装结束"


# ripgrep
echo "安装ripgrep..."
VERSION="14.1.0"
wget $QUIET -c https://github.com/BurntSushi/ripgrep/releases/download/$VERSION/ripgrep-$VERSION-x86_64-unknown-linux-musl.tar.gz -O - |tar xz
mv ripgrep-$VERSION-x86_64-unknown-linux-musl/rg $INSTALL_DIR/
echo "ripgrep安装结束"


# 更新aliases
echo "更新aliases..."
if [ -f ~/.mysh_config ];then
    sed -i '/tool.aliases start/,/tool.aliases end/ d' ~/.mysh_config
fi
cat tool.aliases >> ~/.mysh_config

# 提示
echo "请手动运行： source ~/.mysh_config"