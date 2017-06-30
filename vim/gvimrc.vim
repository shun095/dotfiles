" vim: set foldmethod=marker:
scriptencoding utf-8

if has('gui_running')
  let s:true = 1
  let s:false = 0

  if v:version >= 800
    set rop=type:directx
  endif
  set linespace=1
  set cmdheight=2
  set guioptions=rchb
  " フォントを設定
  if has('win32')
    set guifont=Ricty_Diminished_for_Powerline:h12
  elseif has('unix')
    set guifont=Ricty\ Diminished\ for\ Powerline\ 12
  endif

  set vb t_vb=
endif
