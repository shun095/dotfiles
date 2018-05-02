scriptencoding utf-8
if &compatible
  set nocompatible
endif

let s:V = vital#mymisc#new()
let s:File = s:V.import('System.File')

fun! mymisc#ImInActivate() abort
  let fcitx_dbus = system('fcitx-remote -a')
  if fcitx_dbus !=# ''
    call system('fcitx-remote -c')
  endif
endf

fun! mymisc#NiceLexplore(open_on_bufferdir) abort
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
fun! mymisc#git_auto_updating() abort
  if !exists('g:called_mygit_func')
    let s:save_cd = getcwd()
    exe 'cd ' . $MYDOTFILES
    let s:git_newer_exists = g:true
    let s:git_qflist = []
    if has('job')
      call job_start('git pull', {'callback': 'mymisc#git_callback', 'exit_cb': 'mymisc#git_end_callback'})
    else
      call vimproc#system('git pull &')
    endif
    " call system("git pull")
    execute 'cd ' . escape(s:save_cd, ' ')
    unlet s:save_cd
    let g:called_mygit_func = 1
  endif
endf

fun! mymisc#git_callback(ch, msg) abort
  if match(a:msg,'Already up') == 0
    let s:git_newer_exists = g:false
  endif

  if match(a:msg,'fatal: unable to access') == 0
    let s:git_newer_exists = g:false
    echomsg 'Couldn''t connect to github'
  endif

  call add(s:git_qflist, {'text':a:msg})
  " echom "mymisc: " . a:msg
endf

fun! mymisc#git_end_callback(ch, msg) abort
  if s:git_qflist == []
    echom 'Couldn''t get git information'
    return
  endif

  call setqflist(s:git_qflist)
  if s:git_newer_exists == g:true
    echohl WarningMsg
    echom 'New vimrc was downloaded. Please restart to use it!!'
    echohl none
    cope
    if has('gui_running')
      sleep 1
      let l:confirm = confirm('Restart Now?', "&yes\n&no", 2)
      if l:confirm == 1
        Restart
      endif
    endif
    " else
    " echomsg "git git_callback_count was " . s:git_callback_count
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

fun! mymisc#command_at_destdir(destination,commandlist) abort
  let l:previous_cwd = getcwd()
  exe 'cd ' . a:destination
  for command in a:commandlist
    exe command
  endfor
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

  return l:destdir
endf

fun! mymisc#ctags_project() abort
  let l:tags_dir = mymisc#find_project_dir('tags')

  if l:tags_dir ==# ''
    let l:tags_dir = mymisc#find_project_dir('.git')
  endif

  if l:tags_dir ==# ''
    echohl WarningMsg
    echom "Appropriate directory couldn't be found!! (There is no tags file or git directory.)"
    echohl none
  else
    call mymisc#command_at_destdir(l:tags_dir,['call system("ctags -R")'])
    echomsg 'tags file made at ' . l:tags_dir
  endif
endf

fun! mymisc#gnometerm_detection(ch, msg) abort
  let gnome_term_ver = split(split(a:msg)[2], '\.')
  call mymisc#set_tmux_code(gnome_term_ver)
endf

fun! mymisc#set_tmux_code(gnome_term_ver) abort
  " if a:gnome_term_ver[0] == 3 && a:gnome_term_ver[1] > 12
    " if exists('$TMUX')
      " let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
      " let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
    " else
      " let &t_SI = '[5 q'
      " let &t_EI = '[2 q'
    " endif
  " endif
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

fun! mymisc#test() abort
  return s:File.copy(expand('~/old.txt'),expand('~/new.txt'))
endf

fun! mymisc#statusline_tagbar() abort
  let str = ''
  if exists('*tagbar#currenttag()')
    let str .= tagbar#currenttag('[%s]','')
  endif
  return str
endf

fun! mymisc#statusline_fugitive() abort
  let str = ''
  if exists('*fugitive#head()') 
    if fugitive#head() !=# ''
      let str .= ' ' . fugitive#head() . ' '
    endif
  endif
  return str
endf

fun! mymisc#statusline_gitgutter() abort
  let str = ''
  if exists('*fugitive#head()') 
    if fugitive#head() !=# ''
      if exists('*GitGutterGetHunkSummary()')
        let gutter_lst = GitGutterGetHunkSummary()
        let str .= '+' . gutter_lst[0] 
        let str .= '~' . gutter_lst[1] 
        let str .= '-' . gutter_lst[2]
      endif
    endif
  endif
  return str
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

fun! mymisc#plug_tap(name) abort
  if exists('*dein#tap')
    return dein#tap(a:name)
  elseif exists(':Plug')
    return has_key(g:plugs,a:name)
  else
    return g:false
  endif
endf

" set tabline=%!mymisc#tabline()

