scriptencoding utf-8
if &compatible
  set nocompatible
endif

function! mymisc#util#log_info(mes) abort
  echomsg string(mes)
endfunction

function! mymisc#util#log_warn(mes) abort
  echohl WarningMsg
  echomsg string(mes)
  echohl none
endfunction

function! mymisc#util#log_error(mes) abort
  echohl ErrorMsg
  echomsg string(mes)
  echohl none
endfunction
