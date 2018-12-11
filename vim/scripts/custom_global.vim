scriptencoding utf-8

if &compatible
  set nocompatible
endif

augroup vimrc_custom_global
  autocmd!
  autocmd FileType c,cpp,h,hpp,python nnoremap <buffer> K :call <SID>toggle_preview_window()<CR>
  if mymisc#plug_tap('lexima.vim')
    autocmd VimEnter * call lexima#init()
  endif
  autocmd VimEnter * imap <expr><CR> <SID>my_cr_main()
augroup END

imap <expr><TAB> <SID>my_tab_main()

fun! s:toggle_preview_window()
  if mymisc#preview_window_is_opened()
    normal z
  else
    if mymisc#plug_tap('YouCompleteMe')
      YcmCompleter GetDoc
    elseif mymisc#plug_tap('LanguageClient-neovim')
      call LanguageClient#textDocument_hover()
    else
      normal! K
    endif
  endif
endf

if mymisc#plug_tap('auto-pairs')
  let g:AutoPairsMapCR = 0
  let g:AutoPairsFlyMode = 0
  let g:AutoPairsMultilineClose = 1
  let g:AutoPairsShortcutBackInsert = '<C-j>'
  function! s:my_close_pair_function() abort
    return "\<CR>\<C-R>=AutoPairsReturn()\<CR>"
  endfunction

elseif mymisc#plug_tap('lexima.vim')
  let g:lexima_ctrlh_as_backspace = 1
  function! s:my_close_pair_function() abort
    return "\<C-R>=lexima#expand('<CR>', 'i')\<CR>"
  endfunction

elseif mymisc#plug_tap('delimitMate')
  function! s:my_close_pair_function() abort
    return "\<Plug>delimitMateCR"
  endfunction

else
  function! s:my_close_pair_function() abort
    return "\<CR>"
  endfunction
endif


function! s:my_cr_main() abort
  if pumvisible()
    " if neosnippet#expandable()
    "   return "\<Plug>(neosnippet_expand)"
    " else
    return "\<C-r>=(".s:SID()."my_try_ulti() > 0)?\"\":".s:SID()."my_cr_noulti()\<CR>"
    " endif
  else
    return s:my_close_pair_function()
  endif
endfunction

function! s:my_cr_noulti()
  if mymisc#plug_tap('deoplete.nvim')
    return "\<C-r>=deoplete#close_popup()\<CR>"
  else
    call feedkeys("\<C-y>")
    return ""
  endif
endfunction

function! s:my_tab_main() abort
  if pumvisible()
    return "\<C-n>"
  elseif mymisc#plug_tap('neosnippet.vim')
    if neosnippet#expandable_or_jumpable()
      return "\<Plug>(neosnippet_expand_or_jump)" 
    endif
  else
    return "\<C-r>=(".s:SID()."my_try_ulti() > 0)?\"\":".s:SID()."my_tab_noulti()\<CR>"
  endif
endfunction

function! s:my_try_ulti()
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

