scriptencoding utf-8

function! mymisc#config#defx#setup() abort
  " nnoremap <silent> <Leader>e :call <SID>quit_existing_defx()<CR>:Defx `expand('%:p:h')` -split=vertical -winwidth=40 -direction=topleft -search=`expand('%:p')`<CR>
  " nnoremap <silent> <Leader>E :call <SID>quit_existing_defx()<CR>:Defx -split=vertical -winwidth=40 -direction=topleft .<CR>
  " nnoremap <silent> <Leader>E :Defx `expand('%:p:h')` -split=vertical -search=`expand('%:p')`<CR>
  " nnoremap <silent> <Leader>e :Defx -split=vertical<CR>

  nnoremap <silent> <Leader>E :call defx#util#call_defx('Defx', expand('%:p:h') . ' -split=vertical -search=' . expand('%:p'))<CR>
  nnoremap <silent> <Leader>e :call defx#util#call_defx('Defx', ' -split=vertical')<CR>
  nnoremap <silent> <Leader><C-e> :call defx#util#call_defx('Defx', '. -split=vertical')<CR>

  function! s:expand(path) abort
    return s:substitute_path_separator(
          \ (a:path =~# '^\~') ? fnamemodify(a:path, ':p') :
          \ (a:path =~# '^\$\h\w*') ? substitute(a:path,
          \             '^\$\h\w*', '\=eval(submatch(0))', '') :
          \ a:path)
  endfunction

  function! s:substitute_path_separator(path) abort
    return has('win32') ? substitute(a:path, '\\', '/', 'g') : a:path
  endfunction

  let g:indentLine_fileTypeExclude = ['defx']

  let s:defx_custom_columns = 'mark:indent:icon:filename:type:size:time'

  if mymisc#plug_tap('defx-git')
    let s:defx_custom_columns = 'mark:indent:icon:git:filename:type:size:time'
  endif

  call defx#custom#option('_', {
        \ 'columns': s:defx_custom_columns,
        \ 'winwidth': '35',
        \ 'direction': 'topleft',
        \ })

  augroup vimrc_defx
    autocmd!

    " Remove netrw and NERDTree directory handlers.
    autocmd VimEnter * if exists('#FileExplorer') | exe 'au! FileExplorer *' | endif
    autocmd VimEnter * if exists('#NERDTreeHijackNetrw') | exe 'au! NERDTreeHijackNetrw *' | endif
    autocmd BufEnter * if !exists('b:defx') && isdirectory(expand('%'))
          \ | call defx#util#call_defx('Defx', escape(s:expand(expand('%')), ' '))
          \ | endif

    call defx#custom#option('_', {'ignored_files': '*.meta,*.swp,*.swo,*.pyc,*.aux,*.dvi,*.fls,*.synctex.gz,*.synctex(busy),*.bbl,*.blg,*.toc,*.fdb_latexmk'})

    autocmd FileType defx call s:defx_my_settings()
    function! s:defx_my_settings() abort
      " Define mappings
      nnoremap <silent><buffer><expr> <CR>
            \ defx#do_action('drop')
      nnoremap <silent><buffer><expr> <2-LeftMouse>
            \ defx#do_action('drop')
      nnoremap <silent><buffer><expr> O
            \ defx#do_action('open_tree_recursive')
      nnoremap <silent><buffer><expr> o
            \ defx#is_directory() ?
            \   defx#do_action('open_tree') :
            \   defx#do_action('drop')
      nnoremap <silent><buffer><expr> u
            \ defx#do_action('cd', ['..'])
      nnoremap <silent><buffer><expr> l
            \ defx#do_action('drop')
      nnoremap <silent><buffer><expr> h
            \ defx#do_action('cd', ['..'])
      nnoremap <silent><buffer><expr> t
            \ defx#do_action('open', 'tabedit')
      nnoremap <silent><buffer><expr> ~
            \ defx#do_action('cd')
      nnoremap <silent><buffer><expr> yy
            \ defx#do_action('yank_path')
      nnoremap <buffer><expr> cd
            \ defx#do_action('yank_path').":cd \<C-r>\"\<CR>"
      nnoremap <silent><buffer><expr> .
            \ defx#do_action('toggle_ignored_files')
      nnoremap <silent><buffer><expr> x
            \ defx#do_action('close_tree')
      nnoremap <silent><buffer><expr> s
            \ defx#do_action('open', 'wincmd p \| vsplit')
      nnoremap <silent><buffer><expr> i
            \ defx#do_action('open', 'wincmd p \| split')
      nnoremap <silent><buffer><expr> P
            \ defx#do_action('open', 'topleft pedit')
      nnoremap <silent><buffer><expr> Y
            \ defx#do_action('copy')
      nnoremap <silent><buffer><expr> M
            \ defx#do_action('move')
      nnoremap <silent><buffer><expr> D
            \ defx#do_action('remove')
      nnoremap <silent><buffer><expr> R
            \ defx#do_action('rename')
      nnoremap <silent><buffer><expr> p
            \ defx#do_action('paste')
      nnoremap <silent><buffer><expr> a
            \ defx#do_action('new_file')
      nnoremap <silent><buffer><expr> A
            \ defx#do_action('new_directory')
      nnoremap <silent><buffer><expr> q
            \ defx#do_action('quit')
      nnoremap <silent><buffer><expr> *
            \ defx#do_action('toggle_select') . 'j'
      nnoremap <silent><buffer><expr> g*
            \ defx#do_action('toggle_select_all')
      nnoremap <silent><buffer><expr> <C-l>
            \ defx#do_action('redraw')
      nnoremap <silent><buffer><expr> <C-g>
            \ defx#do_action('print')
    endfunction
  augroup END
endfunction
