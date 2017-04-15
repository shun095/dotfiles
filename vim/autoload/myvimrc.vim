fun myvimrc#ImInActivate() abort
  let fcitx_dbus = system('fcitx-remote -a')
  if fcitx_dbus != ''
    call system('fcitx-remote -c')
  endif
endf
fun myvimrc#confirm_do_dein_install() abort
  augroup vimrc_dein_install_plugs
    autocmd!
  augroup END
  let l:confirm_plugins_install = confirm(
        \"Some plugins are not installed yet. Install now?",
        \"&yes\n&no",2
        \)
  if l:confirm_plugins_install == 1
    call dein#install()
  else
    echomsg "Plugins were not installed. Please install after."
  endif
endf
fun myvimrc#NiceLexplore(open_on_bufferdir) abort
  " 常に幅35で開く
  let g:netrw_winsize = float2nr(round(30.0 / winwidth(0) * 100))
  if a:open_on_bufferdir == 1
    Lexplore %:p:h
  else
    Lexplore
  endif
  let g:netrw_winsize = 50
endf
" Auto updating vimrc
fun myvimrc#git_auto_updating() abort
  if !exists("g:called_mygit_func")
    let s:save_cd = getcwd()
    exe 'cd ' . $MYDOTFILES
    let s:git_callback_count = 0
    let s:git_qflist = []
    if has('job')
      call job_start('git pull', {'callback': 'myvimrc#git_callback', 'exit_cb': 'myvimrc#git_end_callback'})
    else
      call vimproc#system("git pull &")
    endif
    execute "cd " . s:save_cd
    unlet s:save_cd
    let g:called_mygit_func = 1
  endif
endf
fun myvimrc#git_callback(ch, msg) abort
  let s:git_callback_count+=1
  call add(s:git_qflist, {'text':a:msg})
  " echom "Myvimrc: " . a:msg
endf
fun myvimrc#git_end_callback(ch, msg) abort
  call setqflist(s:git_qflist)
  if s:git_callback_count > 1
    echohl WarningMsg
    echom "New vimrc was downloaded. Please restart to use it!!"
    echohl none
    cope
    if has('gui_running')
      sleep 1
      let l:confirm = confirm("Restart Now?", "&yes\n&no", 2)
      if l:confirm == 1
        Restart
      endif
    endif
    " else
    " echomsg "git git_callback_count was " . s:git_callback_count
  endif
endf

fun myvimrc#copypath()
  let @" = expand("%:p")
  let @* = expand("%:p")
  let @+ = expand("%:p")
endf

fun myvimrc#command_at_destdir(destination,commandlist)
  let l:previous_cwd = getcwd()
  exe 'cd ' . a:destination
  for command in a:commandlist
    exe command
  endfor
  exe 'cd ' . l:previous_cwd
endf
fun myvimrc#find_project_dir(searchname_arg) abort

  if type(a:searchname_arg) == 1 " stringのとき
    let l:arg_is_string = 1
    let l:searchname = a:searchname_arg
  elseif type(a:searchname_arg) == 3 " listのとき
    let l:arg_is_string = 0
    let l:index = 0
    let l:searchname = a:searchname_arg[l:index]
  else
    echoerr 'Argument is not appropriate to myvimrc#find_project_dir()'
    return
  endif

  let l:destdir = ''

  while l:destdir == '' && l:searchname !=# ''
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

  return l:destdir
endf
fun myvimrc#ctags_project() abort
  let l:tags_dir = myvimrc#find_project_dir('tags')

  if l:tags_dir ==# ''
    let l:tags_dir = myvimrc#find_project_dir('.git')
  endif

  if l:tags_dir ==# ''
    echohl WarningMsg
    echom "Appropriate directory couldn't be found!! (There is no tags file or git directory.)"
    echohl none
  else
    call myvimrc#command_at_destdir(l:tags_dir,['call system("ctags -R")'])
  endif
endf
