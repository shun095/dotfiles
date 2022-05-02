#!/bin/sh
# ターミナルのログを自動で取るようにするためのスニペット
if [ -z $TERMLOG_LOADED ]; then
    TERMLOG_LOADED=true script -a ~/log/term/term_`date +%Y%d%m_%H%M%S`.log
    exit
fi
