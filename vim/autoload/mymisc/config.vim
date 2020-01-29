" asyncomplete
" Version: 0.0.1
" Author: 
" License: 

let s:save_cpo = &cpo
set cpo&vim

function! mymisc#config#asyncomplete_setup()
  " let g:asyncomplete_log_file = $HOME."/.vim/asyncomplete.log"
  " call delete(g:asyncomplete_log_file)

  " if mymisc#plug_tap('asyncomplete-omni.vim')
  "   au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
  "         \ 'name': 'omni',
  "         \ 'whitelist': ['*'],
  "         \ 'blacklist': g:myvimrc_vimlsp_filetypes,
  "         \ 'priority': 80,
  "         \ 'completor': function('asyncomplete#sources#omni#completor')
  "         \  }))
  " endif

  " au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#tsuquyomi#get_source_options({
  "       \ 'name': 'tsuquyomi',
  "       \ 'whitelist': ['javascript','typescript'],
  "       \ 'priority': 100,
  "       \ 'completor': function('asyncomplete#sources#tsuquyomi#completor')
  "       \  }))

  " if mymisc#plug_tap('asyncomplete-necovim.vim')
  "   au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necovim#get_source_options({
  "         \ 'name': 'necovim',
  "         \ 'whitelist': ['vim'],
  "         \ 'priority': 100,
  "         \ 'completor': function('asyncomplete#sources#necovim#completor'),
  "         \ }))
  " endif

  if mymisc#plug_tap('asyncomplete-file.vim')
    au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
          \ 'name': 'file',
          \ 'whitelist': ['*'],
          \ 'priority': -50,
          \ 'completor': function('asyncomplete#sources#file#completor')
          \ }))
  endif

  if mymisc#plug_tap('asyncomplete-neosnippet.vim')
    au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#neosnippet#get_source_options({
          \ 'name': 'neosnippet',
          \ 'whitelist': ['*'],
          \ 'priority': -30,
          \ 'completor': function('asyncomplete#sources#neosnippet#completor'),
          \ }))
  endif

  if mymisc#plug_tap('asyncomplete-ultisnips.vim')
    if has('python3') || has('python')
      au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
            \ 'name': 'ultisnips',
            \ 'whitelist': ['*'],
            \ 'priority': -40,
            \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
            \ }))
    endif
  endif

  if mymisc#plug_tap('asyncomplete-buffer.vim')
    au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
          \ 'name': 'buffer',
          \ 'whitelist': ['*'],
          \ 'priority': -100,
          \ 'completor': function('asyncomplete#sources#buffer#completor'),
          \ }))
  endif

  imap <C-x><Space> <Plug>(asyncomplete_force_refresh)

  "--- Reference ---
  " function! s:default_preprocessor(options, matches) abort
  "   let l:items = []
  "   for [l:source_name, l:matches] in items(a:matches)
  "     for l:item in l:matches['items']
  "       if stridx(l:item['word'], a:options['base']) == 0
  "         call add(l:items, l:item)
  "       endif
  "     endfor
  "   endfor

  "   call asyncomplete#preprocess_complete(a:options, l:items)
  " endfunction

  function! s:sort_by_priority_preprocessor(options, matches) abort
    let l:items = []
    for [l:source_name, l:matches] in items(a:matches)
      for l:item in l:matches['items']
        if stridx(l:item['word'], a:options['base']) == 0
          let l:item['priority'] =
                \ get(asyncomplete#get_source_info(l:source_name),'priority',0)
          call add(l:items, l:item)
        endif
      endfor
    endfor

    let l:items = sort(l:items, {a, b -> b['priority'] - a['priority']})

    call asyncomplete#preprocess_complete(a:options, l:items)
  endfunction


  function! s:preprocess_fuzzy(ctx, matches) abort
    let l:visited = {}
    let l:items = []
    let l:expression = ""

    for char_nr in str2list(a:ctx['base'])
      let char = nr2char(char_nr) 
      let l:expression .= char . '\k*'
    endfor

    for [l:source_name, l:matches] in items(a:matches)
      for l:item in l:matches['items']
        if match(l:item['word'], l:expression) == 0
          call add(l:items, l:item)
        endif
      endfor
    endfor

    call asyncomplete#preprocess_complete(a:ctx, l:items)
  endfunction

  let g:asyncomplete_preprocessor = [function('s:sort_by_priority_preprocessor')]
  " let g:asyncomplete_preprocessor = [function('s:preprocess_fuzzy')]
  let g:asyncomplete_popup_delay = 200

  augroup vimrc_asyncomplete
    autocmd!
    autocmd InsertLeave * if pumvisible() == 0 | pclose | endif
  augroup END
endfunction

function! mymisc#config#YouCompleteMe_setup() abort
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
  " autocmd VIMRCCUSTOM FileType python nnoremap <buffer> K :<C-u>YcmCompleter GetDoc<CR>
  nnoremap <leader><c-]> :<C-u>YcmCompleter GoTo<CR>
  nnoremap <leader>} :<C-u>YcmCompleter GoToDefinition<CR>
  nnoremap <leader>{ :<C-u>YcmCompleter GoToDeclaration<CR>
  augroup vimrc_ycm
    autocmd!
    autocmd FileType c,cpp,h,hpp,python nnoremap <buffer> <c-]> :<C-u>YcmCompleter GoTo<CR>
  augroup END
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
