scriptencoding utf-8

function! mymisc#config#memolist#setup() abort
  let g:memolist_prompt_tags = 1
  " let g:memolist_memo_suffix = 'txt'
  " let g:memolist_unite = 1
  " let g:memolist_denite = 1
  " let g:memolist_vimfiler = 1
  " let g:memolist_vimfiler_option = '-force-quit'
  " let g:memolist_ex_cmd = 'Denite file_rec '
  " if mymisc#plug_tap('nerdtree')
  " let g:memolist_ex_cmd = 'e'
  " endif

  let g:memolist_memo_suffix = "md"

  nmap <Leader>mn :<C-u>MemoNew<cr>
  " if mymisc#plug_tap('denite.nvim')
  "   nnoremap <Leader>ml :execute ":Denite" "-path='".g:memolist_path."'" "file_rec"<cr>
  if mymisc#plug_tap('defx.nvim')
    nnoremap <Leader>ml :<C-u>execute "Defx " . expand(g:memolist_path)<CR>
  else
    nnoremap <Leader>ml :<C-u>MemoList<CR>
  endif
  if mymisc#plug_tap('fzf.vim')
    let g:memolist_path = get(g:,'memolist_path',$HOME . '/memo')
    nnoremap <Leader>mf :<C-u>execute ":FZF " . expand(g:memolist_path)<CR>
  endif
endfunction
