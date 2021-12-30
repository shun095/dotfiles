@echo off
set VADER_OUTPUT_FILE=test_result.log

call vim --not-a-term --cmd "let g:is_test = 1" --cmd "set shortmess=a cmdheight=10" -c "Vader! ./vim/test/myvimrc.vader"

set RC=%ERRORLEVEL%

type test_result.log

exit /B %RC%
