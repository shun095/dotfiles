scriptencoding utf-8
if &compatible
  set nocompatible
endif

function! mymisc#util#log_info(mes) abort
  echomsg string(a:mes)
endfunction

function! mymisc#util#log_warn(mes) abort
  echohl WarningMsg
  echomsg string(a:mes)
  echohl none
endfunction

function! mymisc#util#log_error(mes) abort
  echohl ErrorMsg
  echomsg string(a:mes)
  echohl none
endfunction
