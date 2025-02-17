#!/usr/bin/env python3

import argparse
import os
from libs import utils

SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))


def update():
    # ディレクトリ構成にパッチを当てる

    # バックアップする

    # システムのアップデート

    # buildtools済みであればそちらも更新？

    # 各種ツールアップデート
    #   win:  fzf, oh-my-posh, oh-my-bash(git bash)
    #   unix: fzf, oh-my-zsh, oh-my-bash, zsh plugin, tpm

    # プラグインアップデート
    #   win:  vim plugin, neovim plugin
    #   unix: vim plugin, neovim plugin, tmux plugin

    # パッチを当てる（脆弱性対応など）

    # テストを回す？
    pass


def buildtools():
    # ディレクトリ構成にパッチを当てる

    # バックアップする

    # 前提ライブラリのインストール

    # 各種ツールのビルド、インストール
    #   win:  vim, neovim, luajit?, luarocks?
    #   unix: vim, neovim, tmux

    # パッチを当てる（脆弱性対応など）

    # テストを回す？
    pass


def test():
    # 前提ライブラリのインストール

    # テストの実行
    pass


def install():
    # ディレクトリ構成にパッチを当てる?

    # バックアップする

    # git, vim, neovim, zsh, tmuxのインストール
    #   win:  git, vim, neovim
    #   unix: git, vim, neovim, zsh, tmux

    # fzf, oh-my-zsh, oh-my-posh, oh-my-bash, zshプラグイン, tpmのダウンロード
    #   win:  fzf, oh-my-posh, oh-my-bash(git bash)
    #   unix: fzf, oh-my-zsh, oh-my-bash, zsh plugin, tpm

    # zshテーマのインストール
    #   win:  none
    #   unix: ishitaku.zsh-theme

    # RCファイルにsourceを追記（winがシンボリックリンク面倒なので、シンボリックリンクはやめる?）
    #   win:  vimrc, gvimrc, init.lua, ginit.vim, tigrc, weztermrc, profile.ps1
    #   unix: vimrc, gvimrc, init.lua, ginit.vim, tigrc, weztermrc, zshrc, bashrc, tmux.conf
    # シンボリックリンクを辞めるデメリット: XDGディレクトリまとめてシンボリックリンク貼って終わり！ができない

    # デフォルトのシェルの環境変数をまとめて定義
    #   win: profile.ps1
    #   unix: .profile, .zshenv

    # tmux-256infoのterm infoを生成

    # 各種プラグインインストール
    #   win: fzf, vim plugin, neovim plugin, git config書き換え
    #   win: fzf, vim plugin, neovim plugin, git config書き換え, tmux plugin

    # パッチを当てる（脆弱性対応など）

    # テストを回す？
    pass


def uninstall():
    pass


def main():
    utils.get_deployed_version()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='dotfiles installer')

    subparsers = parser.add_subparsers(dest="command", required=True)
    subparsers.add_parser("install", help="Install the application")
    subparsers.add_parser("uninstall", help="Uninstall the application")
    subparsers.add_parser("update", help="Update the application")
    main()
