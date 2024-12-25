scriptencoding utf-8

fun! mymisc#config#ddu#setup() abort
  let win_height  = '&lines - 10'
  let win_width   = '&columns / 2 - 3'
  let win_col     = 1
  let win_row     = 0
  let preview_row = 3
  let preview_col = '&columns / 2'

  function s:hoge(args)
    return #{ text: strftime('%c',getftime(a:args['item']['treePath'])) }
  endfunction

  call ddu#custom#patch_global({
        \  'ui': 'filer',
        \  'uiParams': {
        \    'filer': {
        \      'split': 'horizontal',
        \      'winHeight': win_height,
        \      'winWidth': win_width,
        \      'winRow': win_row,
        \      'winCol': win_col,
        \      'previewFloating': v:true,
        \      'previewHeight': win_height,
        \      'previewWidth': win_width,
        \      'previewRow': preview_row,
        \      'previewCol': preview_col,
        \    },
        \  },
        \  'sourceOptions': {
        \    'file': {
        \      'columns': [
        \               {
        \                   'name': 'devicon_filename'
        \               },
        \               {
        \                   'name': 'custom',
        \                   'params': {
        \                       'getLengthCallbackId': denops#callback#register({ _ -> 4 }),
        \                       'getTextCallbackId': denops#callback#register(function('s:hoge'))
        \                   }
        \            }
        \           ],
        \           'sorters': ['sorter_treefirst']
        \       }
        \  },
        \  'filterParams': {
        \    'matcher_fzf': {
        \      'highlightMatched': 'Search',
        \    },
        \  },
        \  'kindOptions': {
        \    'file': {
        \      'defaultAction': 'open',
        \    },
        \    'word': {
        \      'defaultAction': 'append',
        \    },
        \  },
        \  'actionOptions': {
        \    'narrow': {
        \      'quit': v:true,
        \    },
        \  },
        \})
        " uiParams memo:
        " \    'ff': {
        " \      'ignoreEmpty': v:true,
        " \      'split': 'horizontal',
        " \      'startAutoAction': v:true,
        " \      'autoAction': { 'name': 'preview', 'delay': 0, },
        " \      'prompt': '> ',
        " \      'winHeight': win_height,
        " \      'winWidth': win_width,
        " \      'winRow': win_row,
        " \      'winCol': win_col,
        " \      'previewFloating': v:true,
        " \      'previewHeight': win_height,
        " \      'previewWidth': win_width,
        " \      'previewRow': preview_row,
        " \      'previewCol': preview_col,
        " \    },

  " call ddu#custom#patch_local('file_rec', {
  "       \  'sources': [{
  "       \    'name':'file_rec',
  "       \    'params': {
  "       \      'ignoredDirectories': ['.git', 'var', 'node_modules', ]
  "       \    },
  "       \  }],
  "       \})

  call ddu#custom#patch_local('filer', {
        \  'ui': 'filer',
        \  'sources': [
        \    {'name': 'file', 'params': {}},
        \  ],
        \  'resume': v:true,
        \ })

  " call ddu#custom#patch_local('grep', {
  "       \  'sourceParams' : {
  "       \    'rg' : {
  "       \      'args': ['--column', '--no-heading', '--color', 'never', '-i'],
  "       \    },
  "       \   },
  "       \  'uiParams': {
  "       \    'ff': {
  "       \      'startFilter': v:false,
  "       \     }
  "       \   },
  "       \  'resume': v:true,
  "       \ })

  " nnoremap <Leader>b <Cmd>Ddu buffer -ui-param-ff-startFilter=v:false<CR>
  " nnoremap <Leader>o <Cmd>Ddu line<CR>
  " nnoremap <Leader>r <Cmd>Ddu register -ui-param-ff-startFilter=v:false<CR>
  " nnoremap <Leader>f <Cmd>Ddu -name=file_rec<CR>
  nnoremap <Leader>e <Cmd>Ddu -name=filer<CR>

  " nnoremap <Leader>g <Cmd>Ddu rg -name=grep -source-param-rg-input='`'Pattern: '->input('<cword>'->expand())`'<CR>
  " nnoremap <C-g> <Cmd>Ddu -name=grep<CR>
  " nnoremap <C-n> <Cmd>call ddu#ui#multi_actions(['cursorNext', 'itemAction'], 'grep')<CR>
  " nnoremap <C-p> <Cmd>call ddu#ui#multi_actions(['cursorPrevious', 'itemAction'], 'grep')<CR>

  "--------------------
  " FF
  "--------------------
  " autocmd FileType ddu-ff call s:ddu_ff_settings()
  " function! s:ddu_ff_settings() abort
  "   nnoremap <buffer><silent> <CR> <Cmd>call ddu#ui#do_action('itemAction')<CR>
  "   nnoremap <buffer><silent> s <Cmd>call ddu#ui#do_action('toggleSelectItem')<CR>
  "   nnoremap <buffer><silent> i <Cmd>call ddu#ui#do_action('openFilterWindow')<CR>
  "   nnoremap <buffer><silent> q <Cmd>call ddu#ui#do_action('quit')<CR>
  "   nnoremap <buffer><silent> <C-g> <Cmd>call ddu#ui#do_action('quit')<CR>
  " endfunction
  " autocmd FileType ddu-ff-filter call s:ddu_filter_my_settings()
  " function! s:ddu_filter_my_settings() abort
  "   inoremap <buffer> <C-n> <Nop>
  "   inoremap <buffer> <C-p> <Nop>
  "   nnoremap <buffer> <CR> :q<CR>
  "   nnoremap <buffer> q :q<CR>
  "   inoremap <buffer> <CR> <ESC>:q<CR>
  "   inoremap <buffer> jj <ESC>:q<CR>
  "   inoremap <buffer> jk <ESC>:q<CR>
  "   inoremap <buffer> kj <ESC>:q<CR>
  "   inoremap <buffer> kk <ESC>:q<CR>
  " endfunction

  "--------------------
  " Filer
  "--------------------


  autocmd FileType ddu-filer call s:ddu_filer_my_settings()
  function! s:ddu_filer_my_settings() abort
    nnoremap <buffer><silent> q <Cmd>call ddu#ui#do_action('quit')<CR>
    nnoremap <buffer> <Leader>e <Cmd>Ddu -name=filer<Space>

    nnoremap <buffer><silent><expr> <CR>
          \  ddu#ui#get_item()->get('isTree', v:false) ?
          \    "<Cmd>call ddu#ui#do_action('expandItem', {'mode': 'toggle'})<CR>" :
          \    "<Cmd>call ddu#ui#do_action('itemAction')<CR>"
    nnoremap <buffer><silent><expr> o
          \  ddu#ui#get_item()->get('isTree', v:false) ?
          \    "<Cmd>call ddu#ui#do_action('expandItem', {'mode': 'toggle'})<CR>" :
          \    "<Cmd>call ddu#ui#do_action('itemAction')<CR>"
    nnoremap <buffer><silent><expr> h
          \  ddu#ui#get_item()->get('isTree', v:false) ?
          \    "<Cmd>call ddu#ui#do_action('collapseItem')<CR>" :
          \    "<Cmd>call ddu#ui#do_action('togglePreview')<CR>"
    nnoremap <buffer><silent><expr> l
          \  ddu#ui#get_item()->get('isTree', v:false) ?
          \    "<Cmd>call ddu#ui#do_action('expandItem')<CR>" :
          \    "<Cmd>call ddu#ui#do_action('togglePreview')<CR>"
    " nnoremap <buffer><silent> j j<Cmd>call ddu#ui#do_action('preview')<CR>
    " nnoremap <buffer><silent> k k<Cmd>cal ddu#ui#do_action('preview')<CR>
    " nnoremap <buffer><silent> <C-d> <C-d><Cmd>cal ddu#ui#do_action('preview')<CR>
    " nnoremap <buffer><silent> <C-u> <C-u><Cmd>cal ddu#ui#do_action('preview')<CR>
    " nnoremap <buffer><silent> <C-f> <C-f><Cmd>cal ddu#ui#do_action('preview')<CR>
    " nnoremap <buffer><silent> <C-b> <C-b><Cmd>cal ddu#ui#do_action('preview')<CR>
    nnoremap <buffer><silent> <C-p> <Cmd>cal ddu#ui#do_action('togglePreview')<CR>
    nnoremap <buffer><silent> C <Cmd>call ddu#ui#do_action('itemAction', {'name': 'copy'})<CR>
    nnoremap <buffer><silent> P <Cmd>call ddu#ui#do_action('itemAction', {'name': 'paste'})<CR>
    nnoremap <buffer><silent> D <Cmd>call ddu#ui#do_action('itemAction', {'name': 'delete'})<CR>
    nnoremap <buffer><silent> R <Cmd>call ddu#ui#do_action('itemAction', {'name': 'rename'})<CR>
    nnoremap <buffer><silent> M <Cmd>call ddu#ui#do_action('itemAction', {'name': 'move'})<CR>
    nnoremap <buffer><silent> F <Cmd>call ddu#ui#do_action('itemAction', {'name': 'newFile'})<CR>
    nnoremap <buffer><silent> K <Cmd>call ddu#ui#do_action('itemAction', {'name': 'newDirectory'})<CR>
    nnoremap <buffer><silent> y <Cmd>call ddu#ui#do_action('itemAction', {'name': 'yank'})<CR>
  endfunction
endf
