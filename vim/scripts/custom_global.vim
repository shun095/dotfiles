scriptencoding utf-8

if &compatible
  set nocompatible
en

aug vimrc_custom_global
  au!
  if mymisc#startup#plug_tap('lexima.vim')
    au VimEnter * call lexima#init()
  en
  au InsertEnter * imap <silent><expr> <CR> <SID>my_cr_main()
  au InsertEnter * imap <silent><expr> <TAB> <SID>my_tab_main()
  au InsertEnter * imap <silent><expr> <C-e> <SID>my_ctrle_main()
  au InsertEnter * au! vimrc_custom_global InsertEnter
aug END

if mymisc#startup#plug_tap('neosnippet.vim')
  smap <expr> <Tab>
        \ neosnippet#expandable_or_jumpable() ?
        \   "\<Plug>(neosnippet_expand_or_jump)":
        \   "\<Plug>(RemapUltiSnipsJumpForwardTrigger)"
en

fun! s:my_close_pair_function() abort
  if mymisc#startup#plug_tap('auto-pairs')
    retu "\<CR>\<C-R>=AutoPairsReturn()\<CR>"
  elseif mymisc#startup#plug_tap('lexima.vim')
    retu "\<C-R>=lexima#expand('<CR>', 'i')\<CR>"
  elseif mymisc#startup#plug_tap('delimitMate')
    retu "\<Plug>delimitMateCR"
  else
    retu "\<CR>"
  en
endf

fun! s:my_cr_main() abort
  if pumvisible()
    if mymisc#startup#plug_tap('neosnippet.vim') && neosnippet#expandable()
      retu "\<Plug>(neosnippet_expand)"
    else
      retu "\<C-r>=".s:SID()."try_ultisnips_expand() ? \"\" : ".s:SID()."my_cr_noulti() \<CR>"
    en
  else
    retu s:my_close_pair_function()
  en
endf

fun! s:my_cr_noulti()
  if mymisc#startup#plug_tap('deoplete.nvim')
    retu "\<C-r>=deoplete#close_popup()\<CR>"
  elseif mymisc#startup#plug_tap("asyncomplete.vim")
    retu asyncomplete#close_popup()
  else
    retu "\<C-y>"
  en
endf

fun! s:my_ctrle_main() abort
  if pumvisible()
    if mymisc#startup#plug_tap('asyncomplete.vim')
      retu asyncomplete#cancel_popup()
    else
      retu "\<C-e>"
    en
  else
    retu "\<End>"
  en
endf

fun! s:my_tab_main() abort
  if pumvisible()
    retu "\<C-n>"
  elseif mymisc#startup#plug_tap('vim-vsnip') && vsnip#available(1)
    retu "\<Plug>(vsnip-expand-or-jump)"
  elseif mymisc#startup#plug_tap('neosnippet.vim') && neosnippet#expandable_or_jumpable()
    retu "\<Plug>(neosnippet_expand_or_jump)"
  else
    retu "\<C-r>=".s:SID()."try_ultisnips_expand() ? \"\" : ".s:SID()."my_tab_noulti()\<CR>"
  en
endf

fun! s:try_ultisnips_expand()
  if exists("*UltiSnips#ExpandSnippetOrJump")
    call UltiSnips#ExpandSnippetOrJump()
    retu g:ulti_expand_or_jump_res
  else
    retu ""
  en
endf

fun! s:my_tab_noulti() abort
  if s:check_back_space()
    retu "\<TAB>"
  else
    if mymisc#startup#plug_tap('deoplete.nvim')
      retu "\<C-r>=deoplete#mappings#manual_complete()\<CR>"
    elseif mymisc#startup#plug_tap('YouCompleteMe')
      call feedkeys("\<C-space>")
      retu ""
    elseif mymisc#startup#plug_tap('asyncomplete.vim')
      retu "\<C-r>=asyncomplete#force_refresh()\<CR>"
    elseif mymisc#startup#plug_tap('ddc.vim')
      retu "\<C-r>=ddc#map#manual_complete()\<CR>"
    else
      retu "\<C-n>"
    en
  en
endf

fun! s:SID()
  retu matchstr(expand('<sfile>'), '\zs<SNR>\d\+_\zeSID$')
endf

fun! s:check_back_space() abort
  let col = col('.') - 1
  retu !col || getline('.')[col - 1]  =~ '\s'
endf
