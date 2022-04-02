scriptencoding utf-8

fun! mymisc#config#ctrlp#setup() abort
  " let g:ctrlp_max_files = 20000
  let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:20,results:20'
  let g:ctrlp_show_hidden = 1
  let g:ctrlp_use_caching = 1
  let g:ctrlp_user_command_async = 1

  " let g:ctrlp_root_markers = ['.ctrlproot']
  let g:ctrlp_mruf_default_order = 1
  let s:ctrlp_match_funcs = []

  let g:ctrlp_types = ['fil', 'buf']

  if mymisc#plug_tap('ctrlp-matchfuzzy')
    call add(s:ctrlp_match_funcs, 'ctrlp_matchfuzzy#matcher')
  elseif mymisc#plug_tap('cpsm') " ========== For cpsm
    " let s:cpsm_path = expand('$HOME') . '/.vim/dein/repos/github.com/nixprime/cpsm'
    let s:cpsm_path = expand('$HOME') . '/.vim/plugged/cpsm'

    if !filereadable(s:cpsm_path . '/bin/cpsm_py.pyd') && !filereadable(s:cpsm_path . '/bin/cpsm_py.so')
      au VimEnter * echomsg "Cpsm has not been built yet."
    else
      call add(s:ctrlp_match_funcs,'cpsm#CtrlPMatch')
    endif
    let g:cpsm_query_inverting_delimiter = ' '
  elseif mymisc#plug_tap('ctrlp-py-matcher') " ========== For pymatcher
    call add(s:ctrlp_match_funcs, 'pymatcher#PyMatch')
  endif

  fun! MigemoMatch(items, str, limit, mmode, ispath, crfile, regex)
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
    endt
  endf
  
  if executable('migemogrep')
    call add(s:ctrlp_match_funcs, 'MigemoMatch')
  endif

  if len(s:ctrlp_match_funcs) > 0
    let s:ctrlp_match_func_idx = 0
    let g:ctrlp_match_func = {'match': s:ctrlp_match_funcs[s:ctrlp_match_func_idx]}
  endif

  fun! s:ctrlp_rotate_matchers() abort
    if len(s:ctrlp_match_funcs) ==# 0
      return
    endif
    let s:ctrlp_match_func_idx = s:ctrlp_match_func_idx + 1
    if len(s:ctrlp_match_funcs) <= s:ctrlp_match_func_idx
      let s:ctrlp_match_func_idx = 0
    endif

    let g:ctrlp_match_func = {'match': s:ctrlp_match_funcs[s:ctrlp_match_func_idx]}
    echomsg "Current CtrlP match function: " . string(s:ctrlp_match_funcs[s:ctrlp_match_func_idx])
  endf

  aug vimrc_ctrlp
    au!
    au VimEnter * com! -n=? -com=dir CtrlPMRUFiles
          \ let s:tmp_ctrlp_match_func = g:ctrlp_match_func |
          \ let g:ctrlp_match_func = {} |
          \ cal ctrlp#init('mru', { 'dir': <q-args> }) |
          \ let g:ctrlp_match_func = s:tmp_ctrlp_match_func
  aug END

  com! CtrlPOldFiles call ctrlp#init(ctrlp#oldfiles#id())

  nno <Leader><Leader> :<C-u>CtrlP<CR>
  nno <Leader>T        :<C-u>CtrlPTag<CR>
  nno <Leader>al       :<C-u>CtrlPLine<CR>
  nno <Leader>b        :<C-u>CtrlPBuffer<CR>
  nno <Leader>c        :<C-u>CtrlPCurWD<CR>
  nno <Leader>f        :<C-u>CtrlP<CR>
  " gr
  nno <Leader>l        :<C-u>CtrlPLine %<CR>
  nno <Leader>o        :<C-u>CtrlPBufTag<CR>
  nno <Leader>r        :<C-u>CtrlPRegister<CR>
  nno <Leader>u        :<C-u>CtrlPOldFiles<CR>
  nno <Leader>`        :<C-u>CtrlPMark<CR>

  nno <Leader>pp       :<C-u>CtrlP<CR>
  nno <Leader>pT       :<C-u>CtrlPTag<CR>
  nno <Leader>pal      :<C-u>CtrlPLine<CR>
  nno <Leader>pb       :<C-u>CtrlPBuffer<CR>
  nno <Leader>pc       :<C-u>CtrlPCurWD<CR>
  nno <Leader>pf       :<C-u>CtrlP<CR>
  " gr
  nno <Leader>pl       :<C-u>CtrlPLine %<CR>
  nno <Leader>po       :<C-u>CtrlPBufTag<CR>
  nno <Leader>pr       :<C-u>CtrlPRegister<CR>
  nno <Leader>pu       :<C-u>CtrlPOldFiles<CR>
  nno <Leader>p`       :<C-u>CtrlPMark<CR>

  nno <Leader>pm       :<C-u>call <SID>ctrlp_rotate_matchers()<CR>

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
    " Brought and modified from denite
    let g:ctrlp_user_command = 'find -L %s -path "*/.git/*" -prune -o -path "*/.hg/*" -prune -o -path "*/.svn/*" -prune -o -type l -print -o -type f -print'
  else
    let g:ctrlp_user_command = ''
  endif

  unlet s:ctrlp_command_options
endf
