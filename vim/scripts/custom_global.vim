scriptencoding utf-8

if &compatible
  set nocompatible
endif

augroup vimrc_custom_global
  autocmd!
  if mymisc#plug_tap('lexima.vim')
    autocmd VimEnter * call lexima#init()
  endif
  autocmd VimEnter * imap <expr><CR> <SID>my_cr_main()
  autocmd VimEnter * imap <expr><TAB> <SID>my_tab_main()
augroup END

smap <expr> <Tab>
      \ neosnippet#expandable_or_jumpable() ? 
      \   "\<Plug>(neosnippet_expand_or_jump)":
      \   "\<Plug>(RemapUltiSnipsJumpForwardTrigger)"
smap <S-Tab> <Plug>(RemapUltiSnipsJumpBackwardTrigger)
autocmd FileType c,cpp,h,hpp,python nnoremap <buffer> K :call <SID>toggle_preview_window()<CR>

fun! s:toggle_preview_window()
  if mymisc#preview_window_is_opened()
    normal z
  else
    if mymisc#plug_tap('YouCompleteMe')
      YcmCompleter GetDoc
    elseif mymisc#plug_tap('LanguageClient-neovim')
      call LanguageClient#textDocument_hover()
    elseif mymisc#plug_tap('vim-lsp')
      LspHover
    else
      normal! K
    endif
  endif
endf

function! s:my_close_pair_function() abort
  if mymisc#plug_tap('auto-pairs')
    return "\<CR>\<C-R>=AutoPairsReturn()\<CR>"
  elseif mymisc#plug_tap('lexima.vim')
    return "\<C-R>=lexima#expand('<CR>', 'i')\<CR>"
  elseif mymisc#plug_tap('delimitMate')
    return "\<Plug>delimitMateCR"
  else
    return "\<CR>"
  endif
endfunction

function! s:my_cr_main() abort
  if pumvisible()
    if mymisc#plug_tap('neosnippet.vim') && neosnippet#expandable()
      return "\<Plug>(neosnippet_expand)"
    else
      return "\<C-r>=".s:SID()."try_ultisnips_expand() ? \"\" : ".s:SID()."my_cr_noulti() \<CR>"
    endif
  else
    return s:my_close_pair_function()
  endif
endfunction

function! s:my_cr_noulti()
  if mymisc#plug_tap('deoplete.nvim')
    return "\<C-r>=deoplete#close_popup()\<CR>"
  elseif mymisc#plug_tap("asyncomplete.vim")
    return asyncomplete#close_popup()
  else
    return "\<C-y>"
  endif
endfunction

function! s:my_tab_main() abort
  if pumvisible()
    return "\<C-n>"
  elseif mymisc#plug_tap('neosnippet.vim') && neosnippet#expandable_or_jumpable()
    return "\<Plug>(neosnippet_expand_or_jump)" 
  else
    return "\<C-r>=".s:SID()."try_ultisnips_expand() ? \"\" : ".s:SID()."my_tab_noulti() \<CR>"
  endif
endfunction

function! s:try_ultisnips_expand()
  call UltiSnips#ExpandSnippetOrJump()
  return g:ulti_expand_or_jump_res
endfunction

function! s:my_tab_noulti() abort
  if s:check_back_space()
    return "\<TAB>"
  else
    if mymisc#plug_tap('deoplete.nvim')
      return "\<C-r>=deoplete#mappings#manual_complete()\<CR>"
    elseif mymisc#plug_tap('YouCompleteMe')
      call feedkeys("\<C-space>")
      return ""
    elseif mymisc#plug_tap('asyncomplete.vim')
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
