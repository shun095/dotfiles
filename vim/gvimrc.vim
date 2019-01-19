scriptencoding utf-8

if has('gui_running')
  " t_vb is reset to default when gui starts
  set visualbell t_vb=
  set guioptions=rchb

  if filereadable(expand('$HOME/.vim/lastwinpos.vim'))
    exe "so " . expand('$HOME/.vim/lastwinpos.vim')
  else
    set columns=158
    set lines=40
  endif

  if has('win32')
    set renderoptions=type:directx
    set guifont=Cica:h12
  else
    set guifont=Cica\ 12
  endif

  function! s:save_winpos(save_window_file) abort
    let l:window_maximaize = ''
    if has('win32')
      if libcallnr('User32.dll', 'IsZoomed', v:windowid)
        let l:window_maximaize = 'au GUIEnter * simalt ~x'
      endif
    endif
    let options = [
          \ 'set lines=' . &lines,
          \ 'set columns=' . &columns,
          \ 'winpos ' . getwinposx() . ' ' . getwinposy(),
          \ l:window_maximaize
          \ ]
    call writefile(options, a:save_window_file)
    call setfperm(a:save_window_file, 'rw-rw-rw-')
  endfunction

  augroup GVIMRC
    autocmd!
    autocmd VimLeavePre * call s:save_winpos(expand('$HOME/.vim/lastwinpos.vim'))
  augroup END
endif
