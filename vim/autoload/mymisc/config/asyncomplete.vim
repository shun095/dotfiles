scriptencoding utf-8

fun! mymisc#config#asyncomplete#setup() abort
  if mymisc#startup#plug_tap('asyncomplete-file.vim')
    au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
          \ 'name': 'file',
          \ 'whitelist': ['*'],
          \ 'priority': -50,
          \ 'completor': function('asyncomplete#sources#file#completor')
          \ }))
  endif
  if mymisc#startup#plug_tap('asyncomplete-neosnippet.vim')
    au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#neosnippet#get_source_options({
          \ 'name': 'neosnippet',
          \ 'whitelist': ['*'],
          \ 'priority': 20,
          \ 'completor': function('asyncomplete#sources#neosnippet#completor'),
          \ }))
  endif
  if mymisc#startup#plug_tap('asyncomplete-ultisnips.vim')
    if has('python3') || has('python')
      au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
            \ 'name': 'ultisnips',
            \ 'whitelist': ['*'],
            \ 'priority': 10,
            \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
            \ }))
    endif
  endif
  if mymisc#startup#plug_tap('asyncomplete-buffer.vim')
    au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
          \ 'name': 'buffer',
          \ 'whitelist': ['*'],
          \ 'priority': -100,
          \ 'completor': function('asyncomplete#sources#buffer#completor'),
          \ }))
    " バッファが変わった時に補完候補を一旦クリアするか
    " let g:asyncomplete_buffer_clear_cache = 0
  endif

  imap <C-x><Space> <Plug>(asyncomplete_force_refresh)

  fun! s:preprocessor(options, matches) abort
    call timer_start(0, function('s:sort_by_priority_preprocessor', [a:options, a:matches]))
  endf

  fun! s:sort_by_priority_preprocessor(options, matches, timer) abort
    let l:items = []
    let l:startcols = []

    " let l:expression = '^' . join(map(str2list(a:options['base']), 'nr2char(v:val)'), '.*') " for fuzzy match
    for [l:source_name, l:matches] in items(a:matches)
      let l:startcol = l:matches['startcol']
      let l:base = a:options['typed'][l:startcol - 1:]
      let l:priority = get(asyncomplete#get_source_info(l:source_name),'priority',0)
      let l:source_items = []
      for l:item in l:matches['items']
        " if match(l:item['word'], l:expression) != 0 " for fuzzy match
        if stridx(l:item['word'], l:base) != 0
          continue
        endif
        let l:item['priority'] = l:priority
        call extend(l:source_items, [l:item])
      endfo
      if len(l:source_items) > 0
        call extend(l:startcols, [l:startcol])
      endif
      call extend(l:items, l:source_items)
    endfo

    let a:options['startcol'] = min(l:startcols)

    call asyncomplete#preprocess_complete(a:options, sort(l:items, {a, b -> b['priority'] - a['priority']}))
  endf

  " let g:asyncomplete_log_file = $MYVIMRUNTIME."/asyncomplete.log"
  let g:asyncomplete_preprocessor = [function('s:preprocessor')]
  let g:asyncomplete_popup_delay = 200
  let g:asyncomplete_auto_completeopt = 0
  " let g:asyncomplete_min_chars = 3

  aug vimrc_asyncomplete
    au!
    au InsertLeave * if pumvisible() == 0 | pclose | endif
  aug END
endf
