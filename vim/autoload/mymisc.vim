﻿scriptencoding utf-8
if &compatible
  set nocompatible
endif

let s:V = vital#mymisc#new()
let s:File = s:V.import('System.File')

function! mymisc#ime_deactivate() abort
  if !has('mac') && !g:mymisc_fcitx_is_available
    return
  endif

  if g:mymisc_fcitx_is_available
    let fcitx_dbus = system('fcitx-remote -a')
    if fcitx_dbus !=# ''
      call system('fcitx-remote -c')
    endif
  elseif has('mac')
    if executable('swim')
      call system('swim use com.google.inputmethod.Japanese.Roman')
      if v:shell_error
        call system('swim use com.apple.inputmethod.Kotoeri.Roman')
      endif
      if v:shell_error
        call system('swim use com.apple.keylayout.ABC')
      endif
    endif
  else
  endif
endf

" Auto updating vimrc
function! mymisc#git_auto_updating() abort
  if !exists('g:called_mygit_func')
    let s:save_cd = getcwd()
    exe 'cd ' . $MYDOTFILES
    let s:git_newer_exists = g:true
    let s:git_qflist = []

    echo 'Checking dotfiles repository...'
    if has('job')
      call job_start('git pull', {'callback': 'mymisc#git_callback', 'exit_cb': 'mymisc#git_end_callback'})
    elseif has('nvim')
      call jobstart('git pull', 
            \ {'on_stdout': 'mymisc#git_callback_nvim',
            \  'on_stderr': 'mymisc#git_callback_nvim',
            \  'on_exit': 'mymisc#git_end_callback_nvim'})
    else
      if mymisc#plug_tap('vimproc.vim')
        call vimproc#system('git pull &')
      endif
    endif
    " call system("git pull")
    execute 'cd ' . escape(s:save_cd, ' ')
    unlet s:save_cd
    let g:called_mygit_func = 1
  endif
endf

function! mymisc#git_callback_nvim(ch, msg, event) abort
  for msgstr in a:msg
    if msgstr !=# ''
      call mymisc#git_callback(a:ch, msgstr)
    endif
  endfor
endf

function! mymisc#git_end_callback_nvim(ch, msg, event) abort
  let exit_code = string(a:msg)
  call mymisc#git_end_callback(a:ch, exit_code)  
endf

function! mymisc#git_callback(ch, msg) abort
  call add(s:git_qflist, {'text':a:msg})

  if match(a:msg,'Already up') == 0
    let s:git_newer_exists = g:false
    echo 'dotfiles are up-to-date.'
    return
  endif

  if match(a:msg,'fatal: unable to access') == 0 ||
        \ match(a:msg, 'fatal: Could not read from remote repository.') == 0
    let s:git_newer_exists = g:false
    call mymisc#util#log_warn('Couldn''t connect to github.')
    return
  endif
endf

function! mymisc#git_end_callback(ch, msg) abort
  if s:git_qflist == []
    call mymisc#util#log_warn('Couldn''t get git information')
    return
  endif

  call setqflist(s:git_qflist)
  if s:git_newer_exists == g:true
    call mymisc#util#log_warn('New vimrc was downloaded. Please restart to use it!!')
    cope
    if has('gui_running') && exists(":Restart")
      sleep 1
      let l:confirm = confirm('Restart Now?', "&yes\n&no", 2)
      if l:confirm == 1
        Restart
      endif
    endif
  endif
endf

function! mymisc#copypath() abort
  let @" = expand('%:p')
  let @* = expand('%:p')
  let @+ = expand('%:p')
endf

function! mymisc#copyfname() abort
  let @" = expand('%:t')
  let @* = expand('%:t')
  let @+ = expand('%:t')
endfun

function! mymisc#copydirpath() abort
  let @" = expand('%:p:h')
  let @* = expand('%:p:h')
  let @+ = expand('%:p:h')
endf

function! mymisc#fzf(src, cmd) abort
  if !executable("fzf")
    call mymisc#util#log_warn("fzf is not installed.")
    return
  endif
  let l:opts = fzf#wrap()

  for s in ['sink', 'sink*']
    if has_key(l:opts, s)
      call remove(l:opts, s)
    endif
  endfor

  let l:opts['sink'] = a:cmd
  let l:opts['source'] = a:src
  call fzf#run(l:opts)
endf

function! mymisc#cd_history() abort
  call mymisc#fzf(
        \ 'tac $HOME/.cd_history | sed -e "s?^'.getcwd().'\$??g" | sed ''s/#.*//g'' | sed ''/^\s*$/d'' | cat',
        \ 'cd')
endf

function! mymisc#command_at_destdir(destination,commandlist) abort
  if a:destination ==# ''
    call mymisc#util#log_warn("Destination dir must be specified for mymisc#command_at_destdir")
    return
  endif

  if type(a:commandlist) != 3
    call mymisc#util#log_warn("Command list shoud be list for mymisc#command_at_destdir")
    return
  endif

  let l:previous_cwd = getcwd()
  exe 'cd ' . a:destination
  for command in a:commandlist
    exe command
  endfor
  exe 'cd ' . l:previous_cwd
endf

function! mymisc#find_project_dir(searchname_arg) abort

  if type(a:searchname_arg) == 1 " stringのとき
    let l:arg_is_string = 1
    let l:searchname = a:searchname_arg
  elseif type(a:searchname_arg) == 3 " listのとき
    let l:arg_is_string = 0
    let l:index = 0
    let l:searchname = a:searchname_arg[l:index]
  else
    echoerr 'Argument is not appropriate to mymisc#find_project_dir()'
    return
  endif

  let l:destdir = ''

  while l:destdir ==# '' && l:searchname !=# ''
    let l:target = findfile(l:searchname, expand('%:p').';')

    if l:target ==# ''
      let l:target = finddir(l:searchname, expand('%:p').';')
    endif

    if l:target ==# ''
      let l:destdir = ''
    else
      let l:target = fnamemodify(l:target, ':p')
      if isdirectory(l:target)
        let l:destdir = fnamemodify(l:target, ':h:h')
      else
        let l:destdir = fnamemodify(l:target, ':h')
      endif
    endif

    if l:arg_is_string == 1 " stringのとき
      let l:searchname = ''
    else " listのとき
      let l:index = l:index + 1
      if l:index < len(a:searchname_arg)
        let l:searchname = a:searchname_arg[l:index]
      else
        let l:searchname = ''
      endif
    endif
  endwhile

  if l:destdir ==# ''
    let l:destdir = getcwd()
  endif

  return l:destdir
endf

function! mymisc#ctags_project(project_marker_list) abort
  let l:tags_dir = mymisc#find_project_dir(a:project_marker_list)

  if l:tags_dir ==# ''
    echohl WarningMsg
    echom "Appropriate directory couldn't be found!! (There is no tags file or git directory.)"
    echohl none
    return
  endif

  call mymisc#command_at_destdir(l:tags_dir,['let g:mymisc_system_msg = system("ctags -R")'])
  if !v:shell_error
    echomsg 'Tags file was made at: ' . l:tags_dir
  else
    echohl WarningMsg
    echomsg 'Ctags failed with code '.v:shell_error.'. Target directory was ' . l:tags_dir
    let msg = split(g:mymisc_system_msg, "\n")
    for m in msg
      echomsg "[mymisc] ".m
    endfor
    echohl none
  endif
endf

function! mymisc#print_callback(ch,msg) abort
  echom a:msg
endf

function! mymisc#job_start(cmd) abort
  call job_start(a:cmd,{'callback':'mymisc#print_callback'})
endfun

function! mymisc#previm_save_html(dirpath) abort
  if a:dirpath ==# ''
    let dirpath = './' . expand('%:t:r')
  endif

  let dirpath = fnamemodify(dirpath,':p')

  if s:File.copy_dir(fnamemodify(previm#make_preview_file_path('.'),':p'), dirpath)
    echomsg 'Previm HTML saved at :' . dirpath
  else
    echoerr 'Previm HTML save failed'
  endif
endf

function! mymisc#tabline() abort
  let s = ''
  for i in range(tabpagenr('$'))
    " 強調表示グループの選択
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " タブページ番号の設定 (マウスクリック用)
    let s .= '%' . (i + 1) . 'T'

    if i + 1 == tabpagenr()
      let s .= '%4*'
    else
      let s .= '%5*'
    endif

    let s .= (i + 1) 
    let s .= '(' . tabpagewinnr(i + 1, '$') . ')'

    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " ラベルは MyTabLabel() で作成する
    let s .= ' %{mymisc#tabname(' . (i + 1) . ')} '
  endfor

  " 最後のタブページの後は TabLineFill で埋め、タブページ番号をリセッ
  " トする
  let s .= '%#TabLineFill#%T'

  " カレントタブページを閉じるボタンのラベルを右添えで作成
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%XX'
  endif

  return s
endfunction

function! mymisc#tabname(n) abort
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let name = expand('#'.buflist[winnr - 1].':p')
  let fmod = ':~:.'
  let _ = ''

  if empty(name)
    let _ .= '[No Name]'
  else
    let _ .= substitute(fnamemodify(name, fmod), '\v\w\zs.{-}\ze(\\|/)', '', 'g')
  endif

  let _ = substitute(_, '\\', '/', 'g')
  return _
endfunction

function! mymisc#plug_tap(name) abort
  if exists('*dein#tap')
    return dein#tap(a:name)
  elseif exists(':Plug')
    return has_key(g:plugs,a:name)
  else
    return g:false
  endif
endf

function! mymisc#preview_window_is_opened() abort
  for nr in range(1, winnr('$'))
    if getwinvar(nr, "&pvw") == 1
      " found a preview
      return 1
    endif  
  endfor
  return 0
endfun

function! mymisc#set_statusline_vars() abort
  if exists('*tagbar#currenttag()')
    let w:mymisc_status_tagbar = ''
    let w:mymisc_status_tagbar .= tagbar#currenttag('[%s] ','')
  endif

  if exists('*fugitive#head()') 
    let w:mymisc_status_git = ''
    if fugitive#head() !=# ''
      let w:mymisc_status_git .= fugitive#head() . ' '
    endif
  endif

  try
    if gina#component#repo#preset() !=# ''
      let w:mymisc_status_git = ''
      let track_repo = gina#component#repo#track()
      if track_repo !=# ''
        let w:mymisc_status_git .= track_repo
        let w:mymisc_status_git .= ' < '
      endif
      let w:mymisc_status_git .= gina#component#repo#branch()
      let w:mymisc_status_git .= ' '
    endif
  catch 
  endtry

  if exists('*GitGutterGetHunkSummary()')
    let w:mymisc_status_gitgutter = ''
    let gutter_lst = GitGutterGetHunkSummary()
    let w:mymisc_status_gitgutter .= '+' . gutter_lst[0]
    let w:mymisc_status_gitgutter .= '~' . gutter_lst[1]
    let w:mymisc_status_gitgutter .= '-' . gutter_lst[2]
    let w:mymisc_status_gitgutter .= ' '
  endif
endf


" Forked from https://qiita.com/shiena/items/1dcb20e99f43c9383783
function! mymisc#mintty_sh(term_name, shell_exe_path, locale_exe_path) abort
  let l:mydotfiles = substitute($MYDOTFILES, '\', '/', 'g')
  let l:mydotfiles = substitute(l:mydotfiles, '\C^\([A-Z]\)\:', '/\1', '')

  let l:editor = substitute($EDITOR, '\', '/', 'g')
  let l:editor = substitute(l:editor, '\C^\([A-Z]\)\:', '/\1', '')
  " 日本語Windowsの場合`ja`が設定されるので、入力ロケールに合わせたUTF-8に設定しなおす
  let l:env = {
        \ 'LANG': systemlist('"' . a:locale_exe_path . '" -iU')[0],
        \ 'VIMRUNTIME': "",
        \ 'MYDOTFILES': l:mydotfiles,
        \ 'EDITOR': l:editor
        \ }

  " remote連携のための設定
  " if has('clientserver')
  "   call extend(l:env, {
  "         \ 'GVIM': $VIMRUNTIME,
  "         \ 'VIM_SERVERNAME': v:servername,
  "         \ })
  " endif

  " term_startでgit for windowsのbashを実行する
  call term_start([a:shell_exe_path, '-l'], {
        \ 'term_name': a:term_name,
        \ 'env': l:env,
        \ })
endf

function! mymisc#toggle_preview_window()
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

