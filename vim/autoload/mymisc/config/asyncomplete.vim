scriptencoding utf-8

function! mymisc#config#asyncomplete#setup() abort
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
  "   let l:startcols = []
  "   for [l:source_name, l:matches] in items(a:matches)
  "     let l:startcol = l:matches['startcol']
  "     let l:base = a:options['typed'][l:startcol - 1:]
  "     for l:item in l:matches['items']
  "       if stridx(l:item['word'], l:base) == 0
  "         let l:startcols += [l:startcol]
  "         call add(l:items, l:item)
  "       endif
  "     endfor
  "   endfor

  "   let a:options['startcol'] = min(l:startcols)

  "   call asyncomplete#preprocess_complete(a:options, l:items)
  " endfunction

  function! s:preprocessor(options, matches) abort
    call timer_start(1, function('s:sort_by_priority_preprocessor', [a:options, a:matches]))
  endfunction

  function! s:sort_by_priority_preprocessor(options, matches, timer) abort
    let l:items = []
    let l:startcols = []
    if match(a:options['typed'],'^\s*$') >= 0
      return
    endif
    for [l:source_name, l:matches] in items(a:matches)
      let l:startcol = l:matches['startcol']
      let l:base = a:options['typed'][l:startcol - 1:]
      let l:startcols += [l:startcol]
      let l:priority = get(asyncomplete#get_source_info(l:source_name),'priority',0)
      for l:item in l:matches['items']
        if stridx(l:item['word'], l:base) != 0
          continue
        endif
        let l:item['priority'] = l:priority
        let l:items += [l:item]
      endfor
    endfor

    call asyncomplete#preprocess_complete(a:options, sort(l:items, {a, b -> b['priority'] - a['priority']}))
  endfunction


  " function! s:preprocess_fuzzy(ctx, matches) abort
  "   let l:visited = {}
  "   let l:items = []
  "   let l:expression = ""

  "   for char_nr in str2list(a:ctx['base'])
  "     let char = nr2char(char_nr) 
  "     let l:expression .= char . '\k*'
  "   endfor

  "   for [l:source_name, l:matches] in items(a:matches)
  "     for l:item in l:matches['items']
  "       if match(l:item['word'], l:expression) == 0
  "         call add(l:items, l:item)
  "       endif
  "     endfor
  "   endfor

  "   call asyncomplete#preprocess_complete(a:ctx, l:items)
  " endfunction

  let g:asyncomplete_preprocessor = [function('s:preprocessor')]
  " let g:asyncomplete_preprocessor = [function('s:preprocess_fuzzy')]
  let g:asyncomplete_popup_delay = 100

  augroup vimrc_asyncomplete
    autocmd!
    autocmd InsertLeave * if pumvisible() == 0 | pclose | endif
  augroup END
endfunction
