#!/usr/bin/env python3

import os
import random
from pyfakefs import fake_filesystem_unittest

from .. import version_util
from . import patch_0_2_0


class Test_apply_patch(fake_filesystem_unittest.TestCase):
    def setUp(self):
        self.setUpPyfakefs()

    def test_実行するとbak0のファイルをbakにリネームしbakXのファイルを削除する(self):
        self.fs.create_file(version_util.get_abs_path("deployed-version.txt"), contents="0.1.0\n")
        paths = [
            "/.zshrc",
            "/.vimrc",
            "/.gvimrc",
            "/.tmux.conf",
            "/.config/nvim/init.vim",
            "/.config/flake8",
            "/.vintrc.yml",
            "/.spacemacs",
            "/.config/alacritty/alacritty.toml",
            "/.config/nvim/init.lua",
            "/.config/nvim/ginit.vim",
            "/.tigrc",
            "/.wezterm.lua",
        ]
        for path in paths:
            self.fs.create_file(os.environ.get("HOME") + path)
            for i in range(5):
                if i == 0 or bool(random.getrandbits(1)):  # あったりなかったりでも通るようにする
                    self.fs.create_file(os.environ.get("HOME") + path + ".bak" + str(i))

        print(os.listdir(os.environ.get("HOME")))

        patch_0_2_0.apply_patch()

        true_path = [
            "/.config/nvim/ginit.vim",
            "/.config/nvim/ginit.vim.bak",
            "/.config/nvim/init.lua",
            "/.config/nvim/init.lua.bak",
            "/.tigrc",
            "/.tigrc.bak",
            "/.wezterm.lua",
            "/.wezterm.lua.bak",
        ]

        for path in true_path:
            assert os.path.exists(os.environ.get("HOME") + path) is True

        false_path = [
            "/.config/alacritty/alacritty.toml",
            "/.config/flake8",
            "/.config/nvim/init.vim",
            "/.spacemacs",
            "/.vintrc.yml",
        ]
        for path in false_path:
            assert os.path.exists(os.environ.get("HOME") + path) is False

        false_bak_path = [
            "/.config/alacritty/alacritty.toml",
            "/.config/flake8",
            "/.config/nvim/ginit.vim",
            "/.config/nvim/init.lua",
            "/.config/nvim/init.vim",
            "/.gvimrc",
            "/.spacemacs",
            "/.tigrc",
            "/.tmux.conf",
            "/.vimrc",
            "/.vintrc.yml",
            "/.wezterm.lua",
            "/.zshrc",
        ]
        for path in false_bak_path:
            for i in range(5):
                assert os.path.exists(os.environ.get("HOME") + path + ".bak" + str(i)) is False
