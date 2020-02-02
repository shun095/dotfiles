#!/usr/bin/env bash
#
# install.sh
# Copyright (C) 2019 ishitaku5522
#
# Distributed under terms of the MIT license.

tmpfile=$(mktemp)
curl -sS -L -o ${tmpfile} https://raw.githubusercontent.com/ishitaku5522/dotfiles/master/Dockerfile
echo "Dockerfile:"
cat ${tmpfile}
echo

docker build -f ${tmpfile} -t ishitaku_dotfiles .
rm ${tmpfile}
docker run -it --rm --name ishitaku_dotfiles ishitaku_dotfiles /bin/zsh --login
