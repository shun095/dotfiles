scriptencoding utf-8

fun! mymisc#config#memolist#setup() abort
  let g:memolist_prompt_tags = 0
  " let g:memolist_memo_suffix = 'txt'
  " let g:memolist_unite = 1
  " let g:memolist_denite = 1
  " let g:memolist_vimfiler = 1
  " let g:memolist_vimfiler_option = '-force-quit'
  " let g:memolist_ex_cmd = 'Denite file_rec '
  " if mymisc#startup#plug_tap('nerdtree')
  " let g:memolist_ex_cmd = 'e'
  " endif

  let g:memolist_memo_suffix = "md"
  let g:memolist_template_dir_path = $MYDOTFILES . "/vim/memolist/template"

  nmap <Leader>mn :<C-u>MemoNew<cr>
  " if mymisc#startup#plug_tap('denite.nvim')
  "   nno <Leader>ml :execute ":Denite" "-path='".g:memolist_path."'" "file_rec"<cr>
  if mymisc#startup#plug_tap('defx.nvim')
    nno <Leader>ml :<C-u>execute "Defx " . expand(g:memolist_path)<CR>
  elseif mymisc#startup#plug_tap('fern.vim')
    execute "tcd " . expand(g:memolist_path)
    nno <Leader>ml :<C-u>execute "Fern " . expand(g:memolist_path) . " -drawer -reveal=" . expand(g:memolist_path) . "/todo.txt"<CR>
  else
    nno <Leader>ml :<C-u>MemoList<CR>
  endif
  if mymisc#startup#plug_tap('fzf.vim')
    let g:memolist_path = get(g:,'memolist_path',$HOME . '/memo')

    nno <Leader>mf :<C-u>execute ":FZF " . expand(g:memolist_path)<CR>
  endif
endf
