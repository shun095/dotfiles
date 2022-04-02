scriptencoding utf-8
if &compatible
  set nocompatible
endif

fun! mymisc#util#log_info(mes) abort
  echomsg string(a:mes)
endf

fun! mymisc#util#log_warn(mes) abort
  echohl WarningMsg
  echomsg string(a:mes)
  echohl none
endf

fun! mymisc#util#log_error(mes) abort
  echohl ErrorMsg
  echomsg string(a:mes)
  echohl none
endf
