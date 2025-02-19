#!/usr/bin/env python3

import os
import glob


def apply_patch():

    # bak0→bakに変更 (source を書き込むファイルはバックアップを取っていない)
    paths = [
        os.environ.get("HOME") + "/.config/nvim/init.lua",
        os.environ.get("HOME") + "/.config/nvim/ginit.vim",
        os.environ.get("HOME") + "/.tigrc",
        os.environ.get("HOME") + "/.wezterm.lua",
    ]

    for path in paths:
        # bak0→bakに変更 (source を書き込むファイルはバックアップを取っていない)
        if os.path.exists(path + ".bak0"):
            os.rename(path + ".bak0", path + ".bak")

    paths = [
        os.environ.get("HOME") + "/.config/nvim/init.lua",
        os.environ.get("HOME") + "/.config/nvim/ginit.vim",
        os.environ.get("HOME") + "/.tigrc",
        os.environ.get("HOME") + "/.wezterm.lua",
    ]

    for path in paths:
        globpaths = glob.glob(path + ".bak?")
        for globpath in globpaths:
            os.remove(globpath)

    # もしbakが存在したら削除
    #   $HOME/.zshrc
    #   $HOME/.vimrc
    #   $HOME/.gvimrc
    #   $HOME/.tmux.conf
    #
    #   $HOME/.config/nvim/init.vim
    #   $HOME/.config/flake8
    #   $HOME/.vintrc.yml
    #   $HOME/.spacemacs
    #   $HOME/.config/alacritty/alacritty.toml

    # 設定自体削除
    #   $HOME/.config/nvim/init.vim
    #   $HOME/.config/flake8
    #   $HOME/.vintrc.yml
    #   $HOME/.spacemacs
    #   $HOME/.config/alacritty/alacritty.toml

    # XDG化検討
    #   $HOME/.tmux.conf
    #   $HOME/.wezterm.lua
    #   $HOME/.zshrc
    #   $HOME/.vimrc
    #   $HOME/.gvimrc

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
