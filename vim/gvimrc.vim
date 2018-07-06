scriptencoding utf-8

if has('gui_running')
  " t_vb is reset to default when gui starts
  set visualbell t_vb=
  set guioptions=rchb
  if has('win32')
    set renderoptions=type:directx,renmode:6
    set guifont=Cica:h12
  else
    set guifont=Cica\ 12
  endif
endif
