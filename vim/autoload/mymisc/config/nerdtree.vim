scriptencoding utf-8

function! mymisc#config#nerdtree#setup() abort
  nnoremap <Leader>e :NERDTreeFocus<CR>
  nnoremap <Leader>E :NERDTreeFind<CR>
  nnoremap <Leader><c-e> :NERDTreeCWD<CR>
  nnoremap <Leader>n :NERDTree<space>

  " let g:NERDTreeMapOpenSplit = 's'
  " let g:NERDTreeMapPreviewSplit = 'gs'
  " let g:NERDTreeMapOpenVSplit = 'v'
  " let g:NERDTreeMapPreviewVSplit = 'gv'

  let g:NERDTreeHijackNetrw = 1
  let g:NERDTreeQuitOnOpen = 0
  let g:NERDTreeShowHidden = 0
  let g:NERDTreeWinSize = 35

  let g:NERDTreeMinimalUI = 0
  let g:NERDTreeShowBookmarks = 0
  let g:NERDTreeHighlightCursorline = 1
  let g:NERDTreeIgnore = ['\.meta',
        \ '\.sw[po]',
        \ '\.pyc',
        \ '\.aux',
        \ '\.dvi',
        \ '\.fls',
        \ '\.synctex.gz',
        \ '\.synctex(busy)',
        \ '\.bbl',
        \ '\.blg',
        \ '\.toc',
        \ '\.fdb_latexmk'
        \ ]

  let g:NERDTreeDirArrowExpandable = '+'
  let g:NERDTreeDirArrowCollapsible = '-'
  if executable("trash-put")
    let g:NERDTreeRemoveFileCmd = 'trash-put '
    let g:NERDTreeRemoveDirCmd = 'trash-put '
  endif

  augroup vimrc_nerdtree
    autocmd!
    autocmd FileType nerdtree nnoremap <buffer> j 0j
    autocmd FileType nerdtree nnoremap <buffer> k 0k
  augroup END
endfunction
