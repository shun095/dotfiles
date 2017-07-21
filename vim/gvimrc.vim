" vim: set foldmethod=marker:
scriptencoding utf-8

if has('gui_running')
  let s:true = 1
  let s:false = 0

  if v:version >= 800
    augroup GVIMRC
      autocmd!
      " autocmd VimEnter * set rop=type:directx
      autocmd VimEnter * set rop=type:directx,geom:1,renmode:4,taamode:3
    augroup END
  endif
  set linespace=1
  set cmdheight=2
  set guioptions=rchb
  " フォントを設定
  if has('win32')
    set guifont=Ricty_Diminished_for_Powerline:h10
    " set guifont=ＭＳ_ゴシック:h12
  elseif has('unix')
    set guifont=Ricty\ Diminished\ for\ Powerline\ 10
  endif

  set vb t_vb=
endif
