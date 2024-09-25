scriptencoding utf-8

fun! mymisc#config#airline#setup() abort
  let g:airline#extensions#tabline#enabled = 0
  let g:airline#extensions#tabline#tab_nr_type = 1
  let g:airline#extensions#tabline#show_buffers = 0
  let g:airline_powerline_fonts = 1
  let g:airline_skip_empty_sections = 1
  let g:airline_left_sep = "\ue0b8"
  let g:airline_left_alt_sep = "\ue0b9"
  let g:airline_right_sep = "\ue0ba"
  let g:airline_right_alt_sep = "\ue0bb"


  let g:airline_symbols = extend(
        \ get(g:,'airline_symbols', {}),
        \ {
        \   'notexists': '[?]',
        \   'dirty': '[!]',
        \   'crypt': '',
        \   'linenr': ' :',
        \   'maxlinenr': '',
        \   'colnr': ' :',
        \ },
        \ 'force')
endf
