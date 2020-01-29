#!/usr/bin/env bash
#
# install.sh
# Copyright (C) 2019 ishitaku5522
#
# Distributed under terms of the MIT license.

docker build -t ishitaku_dotfiles .
docker run -it --rm --name ishitaku_dotfiles ishitaku_dotfiles /bin/zsh --login
