scriptencoding utf-8
if &compatible
  set nocompatible
endif

let s:V = vital#mymisc#new()
let s:File = s:V.import('System.File')
let s:Promise = s:V.import('Async.Promise')

fun! mymisc#wait(ms)
  retu s:Promise.new({resolve -> timer_start(a:ms, resolve)})
endf

fun! mymisc#wait_curhold(ms, callback)
  let s:old_updatetime = &updatetime
  let &updatetime = a:ms
  let s:callback = a:callback
  function! g:Mymisc_tmp_function() abort
    cal s:callback()
    augroup mymisc_wait
      au!
    augroup END
    let &updatetime = s:old_updatetime
    unlet s:callback
    unlet s:old_updatetime
  endfunction

  augroup mymisc_wait
    au!
    cal execute("au CursorHold * call Mymisc_tmp_function() | delfunction Mymisc_tmp_function")
  augroup END
endf

fun! mymisc#ime_deactivate() abort
  if !has('mac') && !g:mymisc_fcitx_is_available
    return
  endif

  if g:mymisc_fcitx_is_available
    let fcitx_dbus = system('fcitx-remote -a')
    if fcitx_dbus !=# ''
      call system('fcitx-remote -c')
    endif
  elseif has('mac')
    if executable('im-select')
      call system('im-select com.apple.keylayout.ABC')
    else
      echomsg 'Install "im-select" to enable auto IME deactivation.'
    endif
  else
  endif
endf

" Auto updating vimrc
fun! mymisc#git_auto_updating() abort
  if !exists('g:called_mygit_func')
    let s:save_cd = getcwd()
    exe 'cd ' . $MYDOTFILES
    let s:git_newer_exists = v:true
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
      if mymisc#startup#plug_tap('vimproc.vim')
        call vimproc#system('git pull &')
      endif
    endif
    " call system("git pull")
    execute 'cd ' . escape(s:save_cd, ' ')
    unlet s:save_cd
    let g:called_mygit_func = 1
  endif
endf

fun! mymisc#git_callback_nvim(ch, msg, event) abort
  for msgstr in a:msg
    if msgstr !=# ''
      call mymisc#git_callback(a:ch, msgstr)
    endif
  endfo
endf

fun! mymisc#git_end_callback_nvim(ch, msg, event) abort
  let exit_code = string(a:msg)
  call mymisc#git_end_callback(a:ch, exit_code)  
endf

fun! mymisc#git_callback(ch, msg) abort
  call add(s:git_qflist, {'text':a:msg})

  if match(a:msg,'Already up') == 0
    let s:git_newer_exists = v:false
    echo 'dotfiles are up-to-date.'
    return
  endif

  if match(a:msg,'fatal: unable to access') == 0 ||
        \ match(a:msg, 'fatal: Could not read from remote repository.') == 0
    let s:git_newer_exists = v:false
    call mymisc#util#log_warn('Couldn''t connect to github.')
    return
  endif
endf

fun! mymisc#git_end_callback(ch, msg) abort
  if s:git_qflist == []
    call mymisc#util#log_warn('Couldn''t get git information')
    return
  endif

  call setqflist(s:git_qflist)
  if s:git_newer_exists == v:true
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

fun! mymisc#copypath() abort
  let @" = expand('%:p')
  let @* = expand('%:p')
  let @+ = expand('%:p')
endf

fun! mymisc#copyfname() abort
  let @" = expand('%:t')
  let @* = expand('%:t')
  let @+ = expand('%:t')
endfun

fun! mymisc#copydirpath() abort
  let @" = expand('%:p:h')
  let @* = expand('%:p:h')
  let @+ = expand('%:p:h')
endf

fun! mymisc#fzf(src, cmd) abort
  if !executable("fzf")
    call mymisc#util#log_warn("fzf is not installed.")
    return
  endif
  let l:opts = fzf#wrap()

  for s in ['sink', 'sink*']
    if has_key(l:opts, s)
      call remove(l:opts, s)
    endif
  endfo

  let l:opts['sink'] = a:cmd
  let l:opts['source'] = a:src
  call fzf#run(l:opts)
endf

fun! mymisc#cd_history() abort
  call mymisc#fzf(
        \ 'tac $HOME/.cd_history | sed -e "s?^'.getcwd().'\$??g" | sed ''s/#.*//g'' | sed ''/^\s*$/d'' | cat',
        \ 'cd')
endf

fun! mymisc#command_at_destdir(destination,commandlist) abort
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
  endfo
  exe 'cd ' . l:previous_cwd
endf

fun! mymisc#find_project_dir(searchname_arg) abort

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

fun! mymisc#ctags_project(project_marker_list) abort
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
    endfo
    echohl none
  endif
endf

fun! mymisc#print_callback(ch,msg) abort
  echom a:msg
endf

fun! mymisc#job_start(cmd) abort
  call job_start(a:cmd,{'callback':'mymisc#print_callback'})
endfun

fun! mymisc#previm_save_html(dirpath) abort
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

fun! mymisc#tabline() abort
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
  endfo

  " 最後のタブページの後は TabLineFill で埋め、タブページ番号をリセッ
  " トする
  let s .= '%#TabLineFill#%T'

  " カレントタブページを閉じるボタンのラベルを右添えで作成
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%XX'
  endif

  return s
endf

fun! mymisc#tabname(n) abort
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let name = expand('#'.buflist[winnr - 1].':p')
  let fmod = ':~:.'
  let tabname = ''

  if empty(name)
    let tabname .= '[No Name]'
  else
    let tabname .= substitute(fnamemodify(name, fmod), '\v\w\zs.{-}\ze(\\|/)', '', 'g')
  endif

  let tabname = substitute(tabname, '\\', '/', 'g')
  return tabname
endf


fun! mymisc#preview_window_is_opened() abort
  for nr in range(1, winnr('$'))
    if getwinvar(nr, "&pvw") == 1
      " found a preview
      return 1
    endif  
  endfo
  return 0
endfun

fun! mymisc#set_statusline_vars() abort
  if exists('*tagbar#currenttag()')
    let w:mymisc_status_tagbar = ''
    let w:mymisc_status_tagbar .= tagbar#currenttag('[%s] ','')
  endif

  if exists('*fugitive#Head()') 
    let w:mymisc_status_git = ''
    if fugitive#Head() !=# ''
      let w:mymisc_status_git .= fugitive#Head() . ' '
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
  endt

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
fun! mymisc#mintty_sh(term_name, shell_exe_path, locale_exe_path) abort
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

fun! mymisc#toggle_preview_window()
  if mymisc#preview_window_is_opened()
    normal z
  else
    if mymisc#startup#plug_tap('YouCompleteMe')
      YcmCompleter GetDoc
    elseif mymisc#startup#plug_tap('LanguageClient-neovim')
      call LanguageClient#textDocument_hover()
    elseif mymisc#startup#plug_tap('vim-lsp')
      LspHover
    else
      normal! K
    endif
  endif
endf


function! mymisc#patch_highlight_attributes(source_group_name, target_group_name, patch) abort
  if has('patch-8.2.3578')
    let l:hl = hlget(a:source_group_name, v:true)
    let l:hl[0]["name"] = a:target_group_name

    let l:hl[0]["term"] = get(l:hl[0], "term", {})
    let l:hl[0]["cterm"] = get(l:hl[0], "cterm", {})
    let l:hl[0]["gui"] = get(l:hl[0], "gui", {})

    cal extend(l:hl[0]["term"], a:patch)
    cal extend(l:hl[0]["cterm"], a:patch)
    cal extend(l:hl[0]["gui"], a:patch)
    cal hlset(l:hl)
  elseif has('nvim')
    let l:hl = nvim_get_hl(0, {'name': a:source_group_name, 'link': v:false})

    let l:hl["cterm"] = get(l:hl, "cterm", {})

    cal extend(l:hl, a:patch)
    cal extend(l:hl["cterm"], a:patch)
    cal nvim_set_hl(0, a:target_group_name, l:hl)
  endif
endfunction
