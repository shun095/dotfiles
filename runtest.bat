@echo off
set MYDOTFILES=%~dp0

call vim --not-a-term --cmd "let g:is_test = 1" --cmd "set shortmess=a cmdheight=10" --cmd "cal feedkeys(""\<CR>\<CR>\<CR>\<CR>\<CR>"")" -c ":PlugInstall --sync" -c ":qa!"

%USERPROFILE%/vimfiles/plugged/vim-themis/bin/themis

set RC=%ERRORLEVEL%

exit /B %RC%
