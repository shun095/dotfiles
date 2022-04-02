scriptencoding utf-8

fun! mymisc#config#dirvish#setup() abort
  nno <silent> <Leader>e :<C-u>call <SID>mydirvish_start('.',0)<CR>
  nno <silent> <Leader><C-e> :<C-u>call <SID>mydirvish_start('.',1)<CR>
  nno <silent> <Leader>E :<C-u>call <SID>mydirvish_start('%:p:h',1)<CR>

  let g:mydirvish_hidden = 1
  let g:mydirvish_sort = 1
  let g:mydirvish_width = 35

  fun! s:mydirvish_update_callback(timer) abort
    let l:prev_winid = win_getid(winnr())
    if exists('t:mydirvish_winid') && win_gotoid(t:mydirvish_winid)
      normal R
      call win_gotoid(l:prev_winid)
      echom "timer" 
    endif
  endf

  fun! s:mydirvish_start(path, force_change_path) abort
    let path = expand(a:path)
    let l:mydirvish_last_file = expand("%:p")

    if exists('t:mydirvish_winid') && win_gotoid(t:mydirvish_winid)
      let w:mydirvish_before = [expand("%:p"), l:mydirvish_last_file]

      if a:force_change_path
        exe 'Dirvish ' . path
      elseif &ft !=# 'dirvish'
        let path = get(g:, 'mydirvish_last_dir', path)
        exe 'Dirvish ' . path
      endif

      return
    endif
    exe 'vertical topleft ' . g:mydirvish_width . 'split'
    set winfixwidth

    let w:mydirvish_by_split = 1
    let w:mydirvish_default_width = 1
    let w:mydirvish_before = [l:mydirvish_last_file]

    if a:force_change_path
      exe 'Dirvish ' . path
    elseif exists('g:mydirvish_last_dir')
      exe 'Dirvish ' . g:mydirvish_last_dir
    else
      exe 'Dirvish ' . path
    endif

    let t:mydirvish_winid = win_getid(winnr())
  endf

  fun! s:mydirvish_open(...) abort
    if a:0 > 0
      let l:cmd = a:1
    else
      let l:cmd = 'edit'
    endif

    if !exists('w:mydirvish_before')
      let w:mydirvish_before = []
    endif
    if len(w:mydirvish_before) > 1
      call remove(w:mydirvish_before,0,1)
    elseif len(w:mydirvish_before) == 1
      call remove(w:mydirvish_before,0)
    endif

    if exists("w:mydirvish_by_split")
      " on custom dirvish window
      if match(getline("."),"[\\/]$") >= 0
        " directory
        call dirvish#open(l:cmd, 0)
      else
        " file
        let g:mydirvish_tmp = getline('.')
        if winnr("$") == 1
          call s:mydirvish_clean_on_quit()
          if exists('w:mydirvish_by_split') && w:mydirvish_by_split
            unlet w:mydirvish_by_split
          endif
        else
          wincmd p
        endif
        if l:cmd ==# 'edit'
          let l:cmd = 'drop'
        elseif l:cmd ==# 'vsplit'
          vsplit
          let l:cmd = 'drop'
        elseif l:cmd ==# 'split'
          split
          let l:cmd = 'drop'
        endif
        try
          exe l:cmd . " " . g:mydirvish_tmp
        catch /\(E319\|E492\)/
          echomsg ":drop is not available code:"
          echomsg "  " . v:exception
          exe "edit " . g:mydirvish_tmp
        endt
        unlet g:mydirvish_tmp
      endif
    else
      " on original dirvish window
      call dirvish#open(l:cmd, 0)
    endif
  endf

  fun! s:mydirvish_up() abort
    let w:mydirvish_before = get(w:, 'mydirvish_before', [])

    if len(w:mydirvish_before) > 1
      let w:mydirvish_before[1] = getline('.')
    else
      call extend(w:mydirvish_before, [getline('.')])
    endif
    " echom 'Dirvish %:p:h'.repeat(':h',v:count1)
    exe 'Dirvish %:p:h'.repeat(':h',v:count1)
  endf

  fun! s:mydirvish_init_buffer() abort
    " Guard nested loading
    if exists('b:mydirvish_no_init_buffer')
      return
    endif
    if !exists('w:mydirvish_before')
      let w:mydirvish_before = []
    endif

    let g:mydirvish_last_dir = expand('%:p:h')

    " hとlによる移動
    nno <buffer><silent> <C-t> :<C-u>call <SID>mydirvish_open('tabedit')<CR>
    xno <buffer><silent> <C-t> :<C-u>call <SID>mydirvish_open('tabedit')<CR>
    nno <buffer><silent> -     :<C-u>call <SID>mydirvish_up()<CR>
    xno <buffer><silent> -     :<C-u>call <SID>mydirvish_up()<CR>
    nno <buffer><silent> u     :<C-u>call <SID>mydirvish_up()<CR>
    xno <buffer><silent> u     :<C-u>call <SID>mydirvish_up()<CR>
    nno <buffer><silent> <CR>  :<C-u>call <SID>mydirvish_open()<CR>
    xno <buffer><silent> <CR>  :<C-u>call <SID>mydirvish_open()<CR>
    nno <buffer><silent> i     :<C-u>call <SID>mydirvish_open('split')<CR>
    xno <buffer><silent> i     :<C-u>call <SID>mydirvish_open('split')<CR>
    nno <buffer><silent> s     :<C-u>call <SID>mydirvish_open('vsplit')<CR>
    xno <buffer><silent> s     :<C-u>call <SID>mydirvish_open('vsplit')<CR>
    nno <buffer><silent> o     :<C-u>call <SID>mydirvish_open()<CR>
    xno <buffer><silent> o     :<C-u>call <SID>mydirvish_open()<CR>
    nno <buffer><silent> ~     :<C-u>call <SID>mydirvish_start($HOME,1)<CR>

    nno <buffer><silent> A     :<C-u>call <SID>mydirvish_toggle_winwidth()<CR>

    " 独自quitスクリプト
    nno <buffer><silent> q     :<C-u>call <SID>mydirvish_quit()<CR>

    " .とsに隠しファイルとソートを割り当て
    nno <buffer><silent> .     :<C-u>call <SID>mydirvish_toggle_hiddenfiles()<CR>
    nno <buffer><silent> S     :<C-u>call <SID>mydirvish_toggle_sortfiles()<CR>

    " Shell operations
    if executable('trash-put')
      nno <buffer><silent> md   :<C-u>call <SID>mydirvish_shdo("trash-put {}")<CR>
      vno <buffer><silent> d    :<C-u>call <SID>mydirvish_shdo("trash-put {}")<CR>
    else
      nno <buffer><silent> md   :<C-u>call <SID>mydirvish_shdo("rm -rf {}")<CR>
      vno <buffer><silent> d    :<C-u>call <SID>mydirvish_shdo("rm -rf {}")<CR>
    endif
    nno <buffer><silent> mm   :<C-u>call <SID>mydirvish_shdo("mv {} {}")<CR>
    vno <buffer><silent> m    :<C-u>call <SID>mydirvish_shdo("mv {} {}")<CR>
    nno <buffer><silent> mc   :<C-u>call <SID>mydirvish_shdo("cp {} {}_")<CR>
    vno <buffer><silent> c    :<C-u>call <SID>mydirvish_shdo("cp {} {}_")<CR>
    nno <buffer><silent> ma   :<C-u>let @z = @%<CR>:<C-u>call <SID>mydirvish_create_newfile('<C-r>z')<CR>

    nno <buffer><silent> cd   :<C-u>exe 'cd ' . getline('.')<CR>

    call <SID>mydirvish_apply_config()

    " 開いていたファイルやDirectory(w:mydirvish_before)にカーソルをあわせる
    call <SID>mydirvish_update_beforelist()
    call <SID>mydirvish_selectprevdir()
  endf

  fun! s:mydirvish_create_newfile(current_path) abort abort
    let l:path = input("Create new file or directory: ", expand(a:current_path), "file")
    let l:dirpath = fnamemodify(l:path, ':h')

    " 無ければとりあえずディレクトリを作成
    if !isdirectory(l:dirpath)
      try
        call mkdir(l:dirpath, 'p')
        normal R
      catch
        echomsg v:exception
        echomsg 'Couldn''t make directory: ' . l:dirpath
      endt
    endif
    if !isdirectory(l:path)
      " ファイル用ウィンドウへ
      normal! p
      try
        exe 'drop ' . escape(l:path, ' ')
        " Dirvishウィンドウへ
        normal! p
        normal R
        " ファイル用ウィンドウへ
        normal! p
      catch /\(E319\|E492\)/
        echomsg ":drop is not available code:"
        echomsg "  " . v:exception
        exe "edit " . g:mydirvish_tmp
      endt
    endif
  endf

  fun! s:mydirvish_shdo(arg) abort
    if exists('w:mydirvish_default_width') && w:mydirvish_default_width
      call s:mydirvish_winwidth_maximize()
    endif

    exe "Shdo " . a:arg

  endf

  fun! s:mydirvish_winwidth_maximize() abort
      normal |
      let w:mydirvish_default_width = 0
      setl conceallevel=0
  endf

  fun! s:mydirvish_winwidth_default() abort
      exe 'normal ' . g:mydirvish_width . '|'
      let w:mydirvish_default_width = 1
      setl conceallevel=2
  endf

  fun! s:mydirvish_toggle_winwidth() abort
    if exists('w:mydirvish_default_width') && w:mydirvish_default_width
      call s:mydirvish_winwidth_maximize()
    else
      call s:mydirvish_winwidth_default()
    endif
  endf

  fun! s:mydirvish_apply_config() abort
    " Guard nested loading.: 'normal R' hooks FileType dirvish again
    let b:mydirvish_no_init_buffer = 1
    normal R
    unlet b:mydirvish_no_init_buffer

    aug vimrc_dirvish_buffer
      au!
      " Overwrite TextChanged <buffer> setlocal conceallevel=0 on buf_init()
      if exists('##TextChanged') && has('conceal')
        au TextChanged,TextChangedI <buffer> exe 'setlocal conceallevel=2'
      endif
    aug END

    if g:mydirvish_sort
      call s:mydirvish_do_sort()
    endif
    if g:mydirvish_hidden
      call s:mydirvish_do_hide()
    endif
  endf

  fun! s:mydirvish_do_sort() abort
    sort /.*\([\\\/]\)\@=/
  endf

  fun! s:mydirvish_do_hide() abort
    silent keeppatterns g@\v[\/]\.[^\/]+[\/]?$@d _
    silent keeppatterns g@\v[\/][^\/]+(\.pyo)$@d _
  endf

  fun! s:mydirvish_toggle_hiddenfiles() abort
    let g:mydirvish_hidden = !g:mydirvish_hidden
    call s:mydirvish_apply_config()
  endf

  fun! s:mydirvish_toggle_sortfiles() abort
    let g:mydirvish_sort = !g:mydirvish_sort
    call s:mydirvish_apply_config()
  endf

  fun! s:mydirvish_update_beforelist() abort
    if len(w:mydirvish_before) == 0 || w:mydirvish_before[0] !=# expand("%:p")
      call insert(w:mydirvish_before,expand("%:p"))
    endif
  endf

  fun! s:mydirvish_selectprevdir() abort
    if len(w:mydirvish_before) > 1
      call search('\V\^'.escape(w:mydirvish_before[1], '\').'\$', 'cw')
    endif
  endf

  fun! s:mydirvish_clean_on_quit() abort
    if exists('w:mydirvish_by_split') && exists('t:mydirvish_winid')
      unlet t:mydirvish_winid
    endif

    if exists('w:mydirvish_before')
      unlet w:mydirvish_before
    endif
  endf

  fun! s:mydirvish_quit() abort
    execute "normal \<plug>(dirvish_quit)"
    call s:mydirvish_clean_on_quit()
    if exists("w:mydirvish_by_split") && w:mydirvish_by_split && winnr("$") > 1
      unlet w:mydirvish_by_split
      q
    endif
  endf

  aug vimrc_dirvish
    au!
    au FileType dirvish call s:mydirvish_init_buffer()
  aug END
endf
