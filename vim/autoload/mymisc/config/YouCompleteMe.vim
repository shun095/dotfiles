scriptencoding utf-8

fun! mymisc#config#YouCompleteMe#setup() abort
  let g:ycm_global_ycm_extra_conf = $MYDOTFILES . '/vim/scripts/.ycm_extra_conf.py'
  let g:ycm_min_num_of_chars_for_completion = 3
  let g:ycm_complete_in_comments = 1
  let g:ycm_collect_identifiers_from_comments_and_strings = 1
  let g:ycm_collect_identifiers_from_tags_files = 1
  let g:ycm_seed_identifiers_with_syntax = 1
  let g:ycm_add_preview_to_completeopt = 1
  let g:ycm_autoclose_preview_window_after_insertion = 1
  let g:ycm_python_binary_path = 'python'

  let g:ycm_error_symbol = 'E'
  let g:ycm_warning_symbol = 'W'

  let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
  let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
  " au VIMRCCUSTOM FileType python nno <buffer> K :<C-u>YcmCompleter GetDoc<CR>
  nno <leader><c-]> :<C-u>YcmCompleter GoTo<CR>
  nno <leader>} :<C-u>YcmCompleter GoToDefinition<CR>
  nno <leader>{ :<C-u>YcmCompleter GoToDeclaration<CR>
  aug vimrc_ycm
    au!
    au FileType c,cpp,h,hpp,python nno <buffer> <c-]> :<C-u>YcmCompleter GoTo<CR>
  aug END
endf
