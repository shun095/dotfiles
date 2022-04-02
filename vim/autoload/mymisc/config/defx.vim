scriptencoding utf-8

fun! mymisc#config#defx#setup() abort
  " nno <silent> <Leader>e :call <SID>quit_existing_defx()<CR>:Defx `expand('%:p:h')` -split=vertical -winwidth=40 -direction=topleft -search=`expand('%:p')`<CR>
  " nno <silent> <Leader>E :call <SID>quit_existing_defx()<CR>:Defx -split=vertical -winwidth=40 -direction=topleft .<CR>
  " nno <silent> <Leader>E :Defx `expand('%:p:h')` -split=vertical -search=`expand('%:p')`<CR>
  " nno <silent> <Leader>e :Defx -split=vertical<CR>

  nno <silent> <Leader>E :call defx#util#call_defx('Defx', expand('%:p:h') . ' -split=vertical -search=' . expand('%:p'))<CR>
  nno <silent> <Leader>e :call defx#util#call_defx('Defx', ' -split=vertical')<CR>
  nno <silent> <Leader><C-e> :call defx#util#call_defx('Defx', '. -split=vertical')<CR>

  fun! s:expand(path) abort
    return s:substitute_path_separator(
          \ (a:path =~# '^\~') ? fnamemodify(a:path, ':p') :
          \ (a:path =~# '^\$\h\w*') ? substitute(a:path,
          \             '^\$\h\w*', '\=eval(submatch(0))', '') :
          \ a:path)
  endf

  fun! s:substitute_path_separator(path) abort
    return has('win32') ? substitute(a:path, '\\', '/', 'g') : a:path
  endf

  let g:indentLine_fileTypeExclude = ['defx']

  let s:defx_custom_columns = 'mark:indent:icon:filename:type:size:time'

  if mymisc#startup#plug_tap('defx-git')
    let s:defx_custom_columns = 'mark:indent:icon:git:filename:type:size:time'
  endif

  call defx#custom#option('_', {
        \ 'columns': s:defx_custom_columns,
        \ 'winwidth': '35',
        \ 'direction': 'topleft',
        \ })

  aug vimrc_defx
    au!

    " Remove netrw and NERDTree directory handlers.
    au VimEnter * if exists('#FileExplorer') | exe 'au! FileExplorer *' | endif
    au VimEnter * if exists('#NERDTreeHijackNetrw') | exe 'au! NERDTreeHijackNetrw *' | endif
    au BufEnter * if !exists('b:defx') && isdirectory(expand('%'))
          \ | call defx#util#call_defx('Defx', escape(s:expand(expand('%')), ' '))
          \ | endif

    call defx#custom#option('_', {'ignored_files': '*.meta,*.swp,*.swo,*.pyc,*.aux,*.dvi,*.fls,*.synctex.gz,*.synctex(busy),*.bbl,*.blg,*.toc,*.fdb_latexmk'})

    au FileType defx call s:defx_my_settings()
    fun! s:defx_my_settings() abort
      " Define mappings
      nno <silent><buffer><expr> <CR>
            \ defx#do_action('drop')
      nno <silent><buffer><expr> <2-LeftMouse>
            \ defx#do_action('drop')
      nno <silent><buffer><expr> O
            \ defx#do_action('open_tree_recursive')
      nno <silent><buffer><expr> o
            \ defx#is_directory() ?
            \   defx#do_action('open_tree') :
            \   defx#do_action('drop')
      nno <silent><buffer><expr> u
            \ defx#do_action('cd', ['..'])
      nno <silent><buffer><expr> l
            \ defx#do_action('drop')
      nno <silent><buffer><expr> h
            \ defx#do_action('cd', ['..'])
      nno <silent><buffer><expr> t
            \ defx#do_action('open', 'tabedit')
      nno <silent><buffer><expr> ~
            \ defx#do_action('cd')
      nno <silent><buffer><expr> yy
            \ defx#do_action('yank_path')
      nno <buffer><expr> cd
            \ defx#do_action('yank_path').":cd \<C-r>\"\<CR>"
      nno <silent><buffer><expr> .
            \ defx#do_action('toggle_ignored_files')
      nno <silent><buffer><expr> x
            \ defx#do_action('close_tree')
      nno <silent><buffer><expr> s
            \ defx#do_action('open', 'wincmd p \| vsplit')
      nno <silent><buffer><expr> i
            \ defx#do_action('open', 'wincmd p \| split')
      nno <silent><buffer><expr> P
            \ defx#do_action('open', 'topleft pedit')
      nno <silent><buffer><expr> Y
            \ defx#do_action('copy')
      nno <silent><buffer><expr> M
            \ defx#do_action('move')
      nno <silent><buffer><expr> D
            \ defx#do_action('remove')
      nno <silent><buffer><expr> R
            \ defx#do_action('rename')
      nno <silent><buffer><expr> p
            \ defx#do_action('paste')
      nno <silent><buffer><expr> a
            \ defx#do_action('new_file')
      nno <silent><buffer><expr> A
            \ defx#do_action('new_directory')
      nno <silent><buffer><expr> q
            \ defx#do_action('quit')
      nno <silent><buffer><expr> *
            \ defx#do_action('toggle_select') . 'j'
      nno <silent><buffer><expr> g*
            \ defx#do_action('toggle_select_all')
      nno <silent><buffer><expr> <C-l>
            \ defx#do_action('redraw')
      nno <silent><buffer><expr> <C-g>
            \ defx#do_action('print')
    endf
  aug END
endf
