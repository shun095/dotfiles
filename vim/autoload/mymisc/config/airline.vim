scriptencoding utf-8

fun! mymisc#config#airline#setup() abort
  let g:airline#extensions#tabline#enabled = 1
  let g:airline_powerline_fonts = 1
  let g:airline_skip_empty_sections = 1
  let g:airline_left_sep = "\ue0b8"
  let g:airline_left_alt_sep = "\ue0b9"
  let g:airline_right_sep = "\ue0ba"
  let g:airline_right_alt_sep = "\ue0bb"
  let g:airline#extensions#tabline#left_sep = "\ue0bc"
  let g:airline#extensions#tabline#left_alt_sep = "\ue0bd"
  let g:airline#extensions#tabline#right_sep = "\ue0be"
  let g:airline#extensions#tabline#right_alt_sep = "\ue0bf"

  let g:airline_symbols = extend(
        \ get(g:,'airline_symbols', {}),
        \ {
        \   'notexists': '[?]',
        \   'dirty': '[!]',
        \   'crypt': '',
        \   'linenr': ' :',
        \   'maxlinenr': '',
        \   'colnr': ' :',
        \   'whitespace': 'Ξ',
        \ },
        \ 'force')
endf
