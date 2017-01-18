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

fun myrosmake#find_project_dir(filename) abort
  " init variable
  let l:package_dir = ''

  " ----Reference from help about finddir()---- {{{
  " finddir()
  " 最初に見つかったディレクトリのパスを返す。そのディレクトリがカレントディレクトリの
  " 下にある場合は相対パスを返す。そうでなければ絶対パスを返す。
  " findfile() is same as finddir()
  " }}}
  let l:rosxmlfile = findfile(a:filename, expand('%:p').';')

  if l:rosxmlfile !=# '' && (l:rosxmlfile[0] !=# '/') " ファイルが存在し、絶対パス表記でなかったら
    let l:package_dir = getcwd() . '/' . l:rosxmlfile
  else " ファイルが存在しないか、絶対パス表記だったら
    let l:package_dir = l:rosxmlfile
  endif

  if l:package_dir ==# ''
    echohl WarningMsg
    echom "Appropriate directory couldn't be found!! (There is no stack/manifest.xml file.)"
    echohl none
  else
    " ファイル名をパスから削除
    let l:package_dir = substitute(l:package_dir, a:filename, '', 'g')
  endif

  return l:package_dir
endf

fun myrosmake#cd_command_cdreturn(destination,commandlist) abort
  let l:previous_cwd = getcwd()
  exe 'cd ' . a:destination
  for command in a:commandlist
    exe command
  endfor
  exe 'cd ' . l:previous_cwd
endf
