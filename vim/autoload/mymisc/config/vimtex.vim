scriptencoding utf-8

fun! mymisc#config#vimtex#setup() abort
  aug vimrc_vimtex
    au!
    au BufReadPre *.tex let b:vimtex_main = 'main.tex'
  aug END

  let g:vimtex_compiler_latexmk_engines = { '_' : '-pdfdvi' }
  let g:vimtex_compiler_latexmk = {
        \   'background' : 1,
        \   'build_dir' : '',
        \   'callback' : 1,
        \   'continuous' : 1,
        \   'executable' : 'latexmk',
        \   'options' : [
        \     '-pdfdvi',
        \     '-verbose',
        \     '-file-line-error',
        \     '-synctex=1',
        \     '-interaction=nonstopmode',
        \     '-f',
        \   ],
        \ }

  if has('win32')
    let g:vimtex_view_general_viewer = 'SumatraPDF'
    let g:vimtex_view_general_options
          \ = '-reuse-instance -forward-search @tex @line @pdf'
          \ . ' -inverse-search "gvim --servername ' . v:servername
          \ . ' --remote-send \"^<C-\^>^<C-n^>'
          \ . ':drop \%f^<CR^>:\%l^<CR^>:normal\! zzzv^<CR^>'
          \ . ':execute ''drop '' . fnameescape(''\%f'')^<CR^>'
          \ . ':\%l^<CR^>:normal\! zzzv^<CR^>'
          \ . ':call remote_foreground('''.v:servername.''')^<CR^>^<CR^>\""'
    let g:vimtex_view_general_options_latexmk = '-reuse-instance'
  elseif has('unix')""
    if executable('qpdfview')
      let g:vimtex_view_general_viewer = 'qpdfview'
      let g:vimtex_view_general_options
            \ = '--unique @pdf\#src:@tex:@line:@col'
      let g:vimtex_view_general_options_latexmk = '--unique'
      " qpdfview side: Edit>Settings>Behavior>Source editor
      "   gvim --remote-expr "vimtex#view#reverse_goto(%2, '%1')"
    else
      let g:vimtex_view_general_viewer = 'xdg-open'
    endif
  endif
endf
