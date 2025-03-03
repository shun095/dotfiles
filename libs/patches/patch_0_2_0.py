#!/usr/bin/env python3

import os
import glob


def apply_patch():

    # bak0→bakに変更 (source を書き込むファイルはバックアップを取っていない)
    paths = [
        "/.config/nvim/init.lua",
        "/.config/nvim/ginit.vim",
        "/.tigrc",
        "/.wezterm.lua",
    ]

    for path in paths:
        # bak0→bakに変更 (source を書き込むファイルはバックアップを取っていない)
        if os.path.exists(os.environ.get("HOME") + path + ".bak0"):
            os.rename(os.environ.get("HOME") + path + ".bak0", os.environ.get("HOME") + path + ".bak")

    for path in paths:
        globpaths = glob.glob(os.environ.get("HOME") + path + ".bak?")
        for globpath in globpaths:
            os.remove(globpath)

    # もしbakXが存在したら削除
    paths = [
        "/.config/alacritty/alacritty.toml",
        "/.config/flake8",
        "/.config/nvim/init.vim",
        "/.gvimrc",
        "/.spacemacs",
        "/.tmux.conf",
        "/.vimrc",
        "/.vintrc.yml",
        "/.zshrc",
    ]
    for path in paths:
        globpaths = glob.glob(os.environ.get("HOME") + path + ".bak?")
        for globpath in globpaths:
            os.remove(globpath)

    # 設定自体削除
    paths = [
        "/.config/alacritty/alacritty.toml",
        "/.config/flake8",
        "/.config/nvim/init.vim",
        "/.spacemacs",
        "/.vintrc.yml",
    ]
    for path in paths:
        os.remove(os.environ.get("HOME") + path)

    # XDG化検討
    #   $HOME/.gvimrc
    #   $HOME/.tmux.conf
    #   $HOME/.vimrc
    #   $HOME/.wezterm.lua
    #   $HOME/.zshrc

    # localrcs→.localrcsに命名変更

    # .vimsessions命名変更

    # .cd_history削除 or 命名変更

    # .viminfoファイル見直し

    # zwcファイル削除
    pass


def main():
    apply_patch()


if __name__ == "__main__":
    main()
