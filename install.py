#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2017  ishitaku5522<ishitaku5522@gmail.com>
#
# Distributed under terms of the MIT license.

"""

"""
import shutil
import os
import copy
import ipdb

if os.name == "nt":
    HOME = os.environ.get("USERPROFILE")
else:
    HOME = os.environ.get("HOME")
DOTFILES = HOME + "/dotfiles/"

class PluginsConfigurator(object):
    def __init__(self):
        self.plugin_dirs = {
                "fzf"     : HOME + "/.fzf",
                "zprezto" : HOME + "/.zprezto"
                }


class RcfilesConfigurator(object):
    def __init__(self):
        self.rcfiles_name = [
            "zshrc",
            "vimrc",
            "gvimrc",
            "tmuxconf",
            "emacsinit",
            "flake8",
            "vintrc"
            ]

        self.symlinks = {
                "zshrc"     : HOME + "/.zshrc",
                "vimrc"     : HOME + "/.vimrc",
                "gvimrc"    : HOME + "/.gvimrc",
                "tmuxconf"  : HOME + "/.tmux.conf",
                "emacsinit" : HOME + "/.emacs.d/init.el"
                "flake8"    : HOME + "/.config/flake8"
                "vintrc"    : HOME + "/.vimtrc.yml"
                }

        self.symlinks_target = {
                "vimrc"     : DOTFILES + "/vim/vimrc.vim",
                "gvimrc"    : DOTFILES + "/vim/gvimrc.vim",
                "tmuxconf"  : DOTFILES + "/tmux/tmux.conf",
                "emacsinit" : DOTFILES + "/emacs/init.el"
                "flake8"    : DOTFILES + "/python/lint/flake8"
                "vintrc"    : DOTFILES + "/python/lint/vintrc.yml"
                }
        


def download_repos(plugin_dirs):
    if plugin_dirs.has_key("fzf"):
        if not os.path.isdir("fzf"):
            print("Downloading FZF...\n")
            os.system("git clone --depth 1 https://github.com/junegunn/fzf.git " + HOME +"/.fzf")

    if plugin_dirs.has_key("zprezto"):
        if not os.path.isdir("zprezto"):

def main():
    """TODO: Docstring for main.
    :returns: TODO

    """


if __name__ == "__main__":
    main()
