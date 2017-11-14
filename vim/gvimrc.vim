" vim: set foldmethod=marker:
scriptencoding utf-8

if has('gui_running')

  if v:version >= 800
    fun! s:set_rop(...)
      set rop=type:directx
      " set rop=type:directx,geom:1,renmode:4,taamode:3
    endf
    if has('job')
      " to improve launch speed
      call timer_start(0, function('s:set_rop'), {'repeat':1})
    else
      augroup GVIMRC
        autocmd!
        " autocmd VimEnter * set rop=type:directx
        autocmd VimEnter * call <SID>set_rop()
      augroup END
    endif
  endif
  set linespace=1
  set guioptions=rchb
  " フォントを設定
  if has('win32')
    set guifont=Cica:h12
  elseif has('unix')
    set guifont=Cica\ 12
  endif

  set vb t_vb=
endif
