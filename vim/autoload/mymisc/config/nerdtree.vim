scriptencoding utf-8

fun! mymisc#config#nerdtree#setup() abort
  nno <Leader>e :NERDTreeFocus<CR>
  nno <Leader>E :NERDTreeFind<CR>
  nno <Leader><c-e> :NERDTreeCWD<CR>
  nno <Leader>n :NERDTree<space>

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

  aug vimrc_nerdtree
    au!
    au FileType nerdtree nno <buffer> j 0j
    au FileType nerdtree nno <buffer> k 0k
  aug END
endf
