scriptencoding utf-8

fun! mymisc#config#quickrun#setup() abort
  " quickrun modules
  " quickrun-hook-add-include-option {{{
  let s:hook = {
        \ 'name': 'add_include_option',
        \ 'kind': 'hook',
        \ 'config': {
        \   'enable': 0,
        \   },
        \ }

  fun! s:hook.on_module_loaded(session, context)
    let l:clang_complete = findfile(".clang_complete",".;")
    if l:clang_complete ==# ""
      return
    endif
    let a:session.config.cmdopt .= ' '.join(readfile(l:clang_complete))

    let paths = filter(split(&path, ','), "len(v:val) && v:val !=#'.' && v:val !~# 'mingw'")
    if len(paths)
      let a:session.config.cmdopt .= ' -I'.join(paths, ' -I')
    endif
  endf

  call quickrun#module#register(s:hook, 1)
  unlet s:hook
  " }}}

  let s:quickrun_winheight = g:myvimrc_term_winheight
  let g:quickrun_no_default_key_mappings = 1
  let g:quickrun_config = get(g:, 'quickrun_config', {})
  let g:quickrun_config['_'] = {
        \   'hook/close_quickfix/enable_hook_loaded' : 1,
        \   'hook/close_quickfix/enable_success'     : 1,
        \   'hook/close_buffer/enable_hook_loaded'   : 1,
        \   'hook/close_buffer/enable_failure'       : 1,
        \   'hook/inu/enable'                        : 1,
        \   'hook/inu/wait'                          : 1,
        \   'outputter'                              : 'multi:buffer:quickfix',
        \   'outputter/buffer/split'                 : 'botright '.s:quickrun_winheight,
        \   'outputter/quickfix/open_cmd'            : 'copen '.s:quickrun_winheight,
        \ }

  if has('terminal')
    let g:quickrun_config['_']['runner']                    = 'terminal'
    let g:quickrun_config['_']['runner/terminal/opener']    = 'botright '.s:quickrun_winheight.'split'
    let g:quickrun_config['_']['runner/terminal/into']      = 0
  elseif has('job')
    let g:quickrun_config['_']['runner']                    = 'job'
    let g:quickrun_config['_']['runner/job/interval']       = 100
  else
    let g:quickrun_config['_']['runner']                    = 'system'
    let g:quickrun_config['python'] = {
          \ 'command' : 'python',
          \ 'cmdopt' : '-u',
          \ }
  endif

  let g:quickrun_config['markdown'] = {
        \ 'type': 'markdown/pandoc',
        \ 'cmdopt': '-s --quiet',
        \ 'outputter' : 'browser',
        \ 'runner': 'system',
        \ }
  let g:quickrun_config['cpp'] = {
        \ 'hook/add_include_option/enable' : 1
        \ }

  if has('win32')
    let s:quickrun_windows_config = get(g:, 'quickrun_windows_config', {})
    let s:quickrun_windows_config['cpp'] = {
          \ 'exec' : ['%c %o %s -o %s:p:r' . '.exe', '%s:p:r' . '.exe %a'],
          \ }
    call extend(g:quickrun_config['cpp'], s:quickrun_windows_config['cpp'])
    unlet s:quickrun_windows_config
  endif

  nmap <silent> <Leader>R :<C-u>QuickRun<CR>
  nno <expr><silent> <C-c> quickrun#is_running() ?
        \ <SID>mymisc_quickrun_sweep() : "\<C-c>"

  fun! s:mymisc_quickrun_sweep()
    echo 'Quickrun Interrupted'
    call quickrun#sweep_sessions()
  endf
endf

