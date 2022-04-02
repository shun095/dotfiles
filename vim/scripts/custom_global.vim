scriptencoding utf-8

if &compatible
  set nocompatible
endif

augroup vimrc_custom_global
  autocmd!
  if mymisc#startup#plug_tap('lexima.vim')
    autocmd VimEnter * call lexima#init()
  endif
  autocmd InsertEnter * imap <silent><expr> <CR> <SID>my_cr_main()
  autocmd InsertEnter * imap <silent><expr> <TAB> <SID>my_tab_main()
  autocmd InsertEnter * imap <silent><expr> <C-e> <SID>my_ctrle_main()
  autocmd InsertEnter * autocmd! vimrc_custom_global InsertEnter
augroup END

if mymisc#startup#plug_tap('neosnippet.vim')
  smap <expr> <Tab>
        \ neosnippet#expandable_or_jumpable() ?
        \   "\<Plug>(neosnippet_expand_or_jump)":
        \   "\<Plug>(RemapUltiSnipsJumpForwardTrigger)"
endif

function! s:my_close_pair_function() abort
  if mymisc#startup#plug_tap('auto-pairs')
    return "\<CR>\<C-R>=AutoPairsReturn()\<CR>"
  elseif mymisc#startup#plug_tap('lexima.vim')
    return "\<C-R>=lexima#expand('<CR>', 'i')\<CR>"
  elseif mymisc#startup#plug_tap('delimitMate')
    return "\<Plug>delimitMateCR"
  else
    return "\<CR>"
  endif
endfunction

function! s:my_cr_main() abort
  if pumvisible()
    if mymisc#startup#plug_tap('neosnippet.vim') && neosnippet#expandable()
      return "\<Plug>(neosnippet_expand)"
    else
      return "\<C-r>=".s:SID()."try_ultisnips_expand() ? \"\" : ".s:SID()."my_cr_noulti() \<CR>"
    endif
  else
    return s:my_close_pair_function()
  endif
endfunction

function! s:my_cr_noulti()
  if mymisc#startup#plug_tap('deoplete.nvim')
    return "\<C-r>=deoplete#close_popup()\<CR>"
  elseif mymisc#startup#plug_tap("asyncomplete.vim")
    return asyncomplete#close_popup()
  else
    return "\<C-y>"
  endif
endfunction

function! s:my_ctrle_main() abort
  if pumvisible()
    if mymisc#startup#plug_tap('asyncomplete.vim')
      return asyncomplete#cancel_popup()
    else
      return "\<C-e>"
    endif
  else
    return "\<End>"
  endif
endfunction

function! s:my_tab_main() abort
  if pumvisible()
    return "\<C-n>"
  elseif mymisc#startup#plug_tap('vim-vsnip') && vsnip#available(1)
    return "\<Plug>(vsnip-expand-or-jump)"
  elseif mymisc#startup#plug_tap('neosnippet.vim') && neosnippet#expandable_or_jumpable()
    return "\<Plug>(neosnippet_expand_or_jump)"
  else
    return "\<C-r>=".s:SID()."try_ultisnips_expand() ? \"\" : ".s:SID()."my_tab_noulti()\<CR>"
  endif
endfunction

function! s:try_ultisnips_expand()
  if exists("*UltiSnips#ExpandSnippetOrJump")
    call UltiSnips#ExpandSnippetOrJump()
    return g:ulti_expand_or_jump_res
  else
    return ""
  endif
endfunction

function! s:my_tab_noulti() abort
  if s:check_back_space()
    return "\<TAB>"
  else
    if mymisc#startup#plug_tap('deoplete.nvim')
      return "\<C-r>=deoplete#mappings#manual_complete()\<CR>"
    elseif mymisc#startup#plug_tap('YouCompleteMe')
      call feedkeys("\<C-space>")
      return ""
    elseif mymisc#startup#plug_tap('asyncomplete.vim')
      return "\<C-r>=asyncomplete#force_refresh()\<CR>"
    else
      return "\<C-n>"
    endif
  endif
endfunction

function! s:SID()
  return matchstr(expand('<sfile>'), '\zs<SNR>\d\+_\zeSID$')
endfun

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction
