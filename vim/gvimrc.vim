scriptencoding utf-8

if has('gui_running')
  " t_vb is reset to default when gui starts
  set vb t_vb=
  set guioptions=rchb
  if has('win32')
    set guifont=Cica:h12:qCLEARTYPE
  else
    set guifont=Cica\ 12
  endif
endif
