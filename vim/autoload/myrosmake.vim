scriptencoding utf-8

let s:rosmake_errorformat = ','
      \ . '%+G[ rosmake ] Built %.%#,'
      \ . '%I[ rosmake ] %m output to directory %.%#,'
      \ . '%Z[ rosmake ] %f %.%#,'

fun myrosmake#rosmake(filename) abort
  if !executable('rosmake')
    echohl WarningMsg
    echomsg "Command 'rosmake' is not executable. Please source setup.bash/sh/zsh first."
    echohl none
  else

    let l:package_dir = myrosmake#find_project_dir(a:filename)

    if l:package_dir !=# ''
      let l:command = myrosmake#get_make_command()
      " cdして実行
      call myrosmake#cd_command_cdreturn(l:package_dir,[l:command])
    else
      echohl WarningMsg
      echom "Appropriate directory couldn't be found!! (There is no stack/manifest.xml file.)"
      echohl none
    endif
  endif
endf

fun myrosmake#make() abort
  " Save current settings
  let l:save_makeprg = &makeprg
  let l:save_errorformat = &errorformat

  set makeprg=rosmake\ --threads=12
  let &errorformat .= s:rosmake_errorformat
  make

  " Restore saved settings
  let &makeprg = l:save_makeprg
  let &errorformat = l:save_errorformat
endf

fun myrosmake#get_make_command() abort
  if exists(':QuickRun') == 2
    let l:config = {
          \ 'rosmake' : {
          \	'outputter/quickfix/errorformat' : &errorformat . s:rosmake_errorformat,
          \	'command' : 'rosmake',
          \	'args' : '--threads=12',
          \	'exec' : '%c %a',
          \	}
          \ }
    call extend(g:quickrun_config, l:config)
    let l:command = ':QuickRun rosmake'
  else
    let l:command = ':call myrosmake#make()'
  endif

  return l:command
endf

fun myrosmake#find_project_dir(searchname_arg) abort
  if type(a:searchname_arg) == 1 " stringのとき
    let l:arg_is_string = 1
    let l:searchname = a:searchname_arg
  elseif type(a:searchname_arg) == 3 " listのとき
    let l:arg_is_string = 0
    let l:index = 0
    let l:searchname = a:searchname_arg[l:index]
  else
    echoerr 'Argument is not appropriate to myrosmake#find_project_dir()'
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

fun myrosmake#cd_command_cdreturn(destination,commandlist) abort
  let l:previous_cwd = getcwd()
  exe 'cd ' . a:destination
  for command in a:commandlist
    exe command
  endfor
  exe 'cd ' . l:previous_cwd
endf
