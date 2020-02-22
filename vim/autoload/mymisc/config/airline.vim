scriptencoding utf-8

function! mymisc#config#airline#setup() abort
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#tab_nr_type = 2
  let g:airline_powerline_fonts = 1
  let g:airline_skip_empty_sections = 1
  let g:airline_left_sep = ''
  let g:airline_left_alt_sep = ''
  let g:airline_right_sep = ''
  let g:airline_right_alt_sep = ''

  let g:airline_symbols = extend(
        \ get(g:,'airline_symbols', {}),
        \ {
        \   'notexists': '[?]',
        \   'dirty': '[!]',
        \   'crypt': ''
        \ },
        \ 'force')
endfunction
