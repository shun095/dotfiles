" vim: set foldmethod=marker:
scriptencoding utf-8

if has('gui_running')

  if v:version >= 800
    fun! s:set_rop(...)
    endf
    if has('job')
      " to improve launch speed
      call timer_start(0, function('s:set_rop'), {'repeat':1})
    else
      augroup GVIMRC
        autocmd!
        autocmd VimEnter * call <SID>set_rop()
      augroup END
    endif
  endif
  set guioptions=rchb
  " フォントを設定
  if has('win32')
    set guifont=Cica:h12:qCLEARTYPE
  elseif has('unix')
    set guifont=Cica\ 12
  endif

  set vb t_vb=
endif
