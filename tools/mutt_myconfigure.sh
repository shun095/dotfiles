#!/bin/sh

LANG=ja_JP.UTF-8 LANGUAGE=ja_JP.UTF-8 LC_ALL=ja_JP.UTF-8 \
./configure --enable-dependency-tracking \
    --enable-sidebar \
    --enable-compressed \
    --enable-external-dotlock \
    --enable-pop \
    --enable-imap \
    --enable-smtp \
    --enable-nfs-fix \
    --enable-mailtool \
    --enable-locales-fix \
    --enable-exact-address \
    --enable-hcache \
    --with-ssl \
    --with-regex \
    --with-gnutls \
    --with-sasl \
    --with-included-gettext \
    --with-idn \
    --with-homespool=$HOME/Maildir/
