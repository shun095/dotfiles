scriptencoding utf-8

function! mymisc#config#ctrlp#setup() abort
  " let g:ctrlp_max_files = 20000
  let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:20,results:20'
  let g:ctrlp_show_hidden = 1
  let g:ctrlp_use_caching = 1
  let g:ctrlp_user_command_async = 1

  " let g:ctrlp_root_markers = ['.ctrlproot']
  let g:ctrlp_mruf_default_order = 1
  let s:ctrlp_match_funcs = []

  let g:ctrlp_types = ['fil', 'buf']

  if mymisc#plug_tap('cpsm') " ========== For cpsm
    " let s:cpsm_path = expand('$HOME') . '/.vim/dein/repos/github.com/nixprime/cpsm'
    let s:cpsm_path = expand('$HOME') . '/.vim/plugged/cpsm'

    if !filereadable(s:cpsm_path . '/bin/cpsm_py.pyd') && !filereadable(s:cpsm_path . '/bin/cpsm_py.so')
      autocmd VimEnter * echomsg "Cpsm has not been built yet."
    else
      call add(s:ctrlp_match_funcs,'cpsm#CtrlPMatch')
    endif
    let g:cpsm_query_inverting_delimiter = ' '
  elseif mymisc#plug_tap('ctrlp-py-matcher') " ========== For pymatcher
    call add(s:ctrlp_match_funcs, 'pymatcher#PyMatch')
  endif

  function! MigemoMatch(items, str, limit, mmode, ispath, crfile, regex)
    let tmp = tempname()
    try
      if a:str =~ '^\s*$'
        return a:items
      endif
      call writefile(split(iconv(join(a:items, "\n"), &encoding, 'utf-8'), "\n"), tmp)
      return split(iconv(system(
            \  printf('migemogrep %s %s',
            \    shellescape(a:str),
            \    shellescape(tmp))), 'utf-8', &encoding), "\n")
    catch
      return []
    finally
      call delete(tmp)
    endtry
  endfunction
  
  if executable('migemogrep')
    call add(s:ctrlp_match_funcs, 'MigemoMatch')
  endif

  if len(s:ctrlp_match_funcs) > 0
    let s:ctrlp_match_func_idx = 0
    let g:ctrlp_match_func = {'match': s:ctrlp_match_funcs[s:ctrlp_match_func_idx]}
  endif

  function! s:ctrlp_rotate_matchers() abort
    if len(s:ctrlp_match_funcs) ==# 0
      return
    endif
    let s:ctrlp_match_func_idx = s:ctrlp_match_func_idx + 1
    if len(s:ctrlp_match_funcs) <= s:ctrlp_match_func_idx
      let s:ctrlp_match_func_idx = 0
    endif

    let g:ctrlp_match_func = {'match': s:ctrlp_match_funcs[s:ctrlp_match_func_idx]}
    echomsg "Current CtrlP match function: " . string(s:ctrlp_match_funcs[s:ctrlp_match_func_idx])
  endfunction

  augroup vimrc_ctrlp
    autocmd!
    autocmd VimEnter * com! -n=? -com=dir CtrlPMRUFiles
          \ let s:tmp_ctrlp_match_func = g:ctrlp_match_func |
          \ let g:ctrlp_match_func = {} |
          \ cal ctrlp#init('mru', { 'dir': <q-args> }) |
          \ let g:ctrlp_match_func = s:tmp_ctrlp_match_func
  augroup END

  command! CtrlPOldFiles call ctrlp#init(ctrlp#oldfiles#id())

  nnoremap <Leader><Leader> :<C-u>CtrlP<CR>
  nnoremap <Leader>T        :<C-u>CtrlPTag<CR>
  nnoremap <Leader>al       :<C-u>CtrlPLine<CR>
  nnoremap <Leader>b        :<C-u>CtrlPBuffer<CR>
  nnoremap <Leader>c        :<C-u>CtrlPCurWD<CR>
  nnoremap <Leader>f        :<C-u>CtrlP<CR>
  " gr
  nnoremap <Leader>l        :<C-u>CtrlPLine %<CR>
  nnoremap <Leader>o        :<C-u>CtrlPBufTag<CR>
  nnoremap <Leader>r        :<C-u>CtrlPRegister<CR>
  nnoremap <Leader>u        :<C-u>CtrlPOldFiles<CR>
  nnoremap <Leader>`        :<C-u>CtrlPMark<CR>

  nnoremap <Leader>pp       :<C-u>CtrlP<CR>
  nnoremap <Leader>pT       :<C-u>CtrlPTag<CR>
  nnoremap <Leader>pal      :<C-u>CtrlPLine<CR>
  nnoremap <Leader>pb       :<C-u>CtrlPBuffer<CR>
  nnoremap <Leader>pc       :<C-u>CtrlPCurWD<CR>
  nnoremap <Leader>pf       :<C-u>CtrlP<CR>
  " gr
  nnoremap <Leader>pl       :<C-u>CtrlPLine %<CR>
  nnoremap <Leader>po       :<C-u>CtrlPBufTag<CR>
  nnoremap <Leader>pr       :<C-u>CtrlPRegister<CR>
  nnoremap <Leader>pu       :<C-u>CtrlPOldFiles<CR>
  nnoremap <Leader>p`       :<C-u>CtrlPMark<CR>

  nnoremap <Leader>pm       :<C-u>call <SID>ctrlp_rotate_matchers()<CR>

  let s:ctrlp_command_options = '--hidden --nocolor --nogroup --follow -g ""'

  if g:mymisc_files_is_available
    let g:ctrlp_user_command = 'files %s -a'
  elseif g:mymisc_rg_is_available
    let g:ctrlp_user_command = 'rg %s --files --color=never --line-buffered --glob ""'
  elseif g:mymisc_pt_is_available
    let g:ctrlp_user_command = 'pt ' . s:ctrlp_command_options . ' %s'
  elseif g:mymisc_ag_is_available
    let g:ctrlp_user_command = 'ag ' . s:ctrlp_command_options . ' %s'
  elseif has('unix')
    " Brought from denite
    let g:ctrlp_user_command = 'find -L %s -path "*/.git/*" -prune -o  -type l -print -o -type f -print'
  else
    let g:ctrlp_user_command = ''
  endif

  unlet s:ctrlp_command_options
endfunction
