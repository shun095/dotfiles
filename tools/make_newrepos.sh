#! /bin/bash
#
# make_newrpos.sh
# Copyright (C) 2017 ishitaku5522 <ishitaku5522@gmail.com>
#
# Distributed under terms of the MIT license.
#
set -e

cd /opt/git
sudo mkdir $1.git
cd $1.git
sudo git init --bare --shared
cd ..
sudo chown -R www-data:www-data $1.git
