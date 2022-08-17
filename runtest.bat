@echo off
set MYDOTFILES=%~dp0
set VADER_OUTPUT_FILE=test_result.log

call vim --not-a-term --cmd "let g:is_test = 1" --cmd "set shortmess=a cmdheight=10" --cmd "cal feedkeys(""\<CR>\<CR>\<CR>\<CR>\<CR>"""")" -c ":PlugInstall --sync" -c ":qa!"
call vim --not-a-term --cmd "let g:is_test = 1" --cmd "set shortmess=a cmdheight=10" --cmd "cal feedkeys(""\<CR>\<CR>\<CR>\<CR>\<CR>"""")" -c "Vader! ./vim/test/myvimrc.vader"

set RC=%ERRORLEVEL%

type test_result.log

exit /B %RC%
