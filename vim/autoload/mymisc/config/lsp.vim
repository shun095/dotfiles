scriptencoding utf-8

fun! mymisc#config#lsp#setup() abort
  " let g:lsp_log_verbose = 1
  " let g:lsp_log_file = $MYVIMRUNTIME . "/vim-lsp.log"
  aug vimrc_vimlsp
    au!
  aug END

  let g:lsp_work_done_progress_enabled       = 1
  let g:lsp_diagnostics_virtual_text_enabled = 0
  let g:lsp_diagnostics_float_cursor         = 1
  let g:lsp_signs_enabled                    = 1

  " NOTE: A>はLspCodeAction
  let g:lsp_signs_error                      = {'text': 'E'}
  let g:lsp_signs_warning                    = {'text': 'W'}
  let g:lsp_signs_information                = {'text': 'I'}
  let g:lsp_signs_hint                       = {'text': 'H'}

  let g:lsp_diagnostics_echo_cursor          = 1
  let g:lsp_diagnostics_echo_delay           = 0
  let g:lsp_textprop_enabled                 = 0

  hi link LspErrorText ALEErrorSign
  hi link LspWarningText ALEWarningSign
  hi link LspInformationText ALEInfoSign
  hi link LspHintText ALEInfoSign

  " root_urlの検出がおかしい場合は:LspSettingsGlobalEditして下記のような設定を
  " すれば良い。
  " {
  "    "eclipse-jdt-ls": {
  "        "root_uri_patterns": [
  "            ".git"
  "        ]
  "    }
  " }


  " OLD Settings {{{

  " fun! Myvimrc_test_execute_command() abort
  "   let l:servers = lsp#get_allowed_servers()

  "   let l:command_id = lsp#_new_command()

  "   let g:lsp_settings = {
  "         \ 'eclipse-jdt-ls': {
  "         \   'args': [
  "         \     '-classpath ' . $MYVIMRUNTIME . '/plugged/vimspector/gadgets/windows/download/vscode-java-debug/0.26.0/root/extension/server/com.microsoft.java.debug.plugin-0.26.0.jar;'
  "         \   ]
  "         \ }}

  "   let l:server = l:servers[0]

  "   call lsp#send_request(l:server, {
  "       \ 'method': 'workspace/executeCommand',
  "       \ 'params': {
  "       \   'command': 'vscode.java.startDebugSession'
  "       \ },
  "       \ 'on_notification': function('s:handle_execute_command', [l:server, l:command_id, 'execute_command']),
  "       \ })
  "       " \   'arguments': "",
  " endf

  " fun! s:handle_execute_command(server, last_command_id, type, data) abort
  "   if a:last_command_id != lsp#_last_command()
  "       return
  "   endif

  "   if lsp#client#is_error(a:data['response'])
  "       call lsp#utils#error('Failed to retrieve '. a:type . ' for ' . a:server . ': ' . lsp#client#error_message(a:data['response']))
  "       return
  "   endif

  "   call vimspector#LaunchWithSettings({'DAPPort': a:data['response']['result']})
  " endf

  " let g:vimspector_enable_mappings = 'VISUAL_STUDIO'

  " com! LaunchDebug call Myvimrc_test_execute_command()

  " let g:myvimrc_lsp_general_config = {}
  " let g:myvimrc_lsp_general_config['cpp'] =
  "       \   {
  "       \     'name': 'clangd',
  "       \     'filetype': ['cpp', 'c', 'hpp', 'h'],
  "       \     'is_executable': executable($MYVIMRUNTIME.'/clangd'),
  "       \     'cmd': [$MYVIMRUNTIME.'/clangd'],
  "       \   }
  " let g:myvimrc_lsp_general_config['python'] =
  "       \   {
  "       \     'name': 'pyls',
  "       \     'filetype': ['python'],
  "       \     'is_executable': executable('pyls'),
  "       \     'cmd': ['python', '-m', 'pyls'],
  "       \   }
  " let g:myvimrc_lsp_general_config['vue'] =
  "       \   {
  "       \     'name': 'vls',
  "       \     'filetype': ['vue'],
  "       \     'is_executable': executable('vls') || executable($APPDATA.'/npm/vls.cmd'),
  "       \     'cmd': [&shell, &shellcmdflag, 'vls'],
  "       \   }
  " let g:myvimrc_lsp_general_config['typescript-language-server'] =
  "       \   {
  "       \     'name': 'typescript-language-server',
  "       \     'filetype': ['javascript', 'javascript.jsx', 'typescript'],
  "       \     'is_executable':
  "       \       executable('typescript-language-server')
  "       \       || executable($APPDATA.'/npm/typescript-language-server'),
  "       \     'cmd': [&shell, &shellcmdflag, 'typescript-language-server --stdio'],
  "       \   }
  " " let g:myvimrc_lsp_general_config['javascript-typescript-stdio'] =
  "       " \   {
  "       " \     'name': 'javascript-typescript-stdio',
  "       " \     'filetype': ['javascript', 'javascript.jsx', 'typescript'],
  "       " \     'is_executable':
  "       " \       executable('javascript-typescript-stdio')
  "       " \       || executable($APPDATA.'/npm/javascript-typescript-stdio'),
  "       " \     'cmd': [&shell, &shellcmdflag, 'javascript-typescript-stdio'],
  "       " \   }
  " let g:myvimrc_lsp_general_config['java'] =
  "       \   {
  "       \     'name': 'eclipse.jdt.ls',
  "       \     'filetype': ['java'],
  "       \     'is_executable': len(split(glob('~/eclipse.jdt.ls/plugins/org.eclipse.equinox.launcher_*.jar'))) == 1,
  "       \     'cmd': [
  "       \       'java',
  "       \       '-Declipse.application=org.eclipse.jdt.ls.core.id1',
  "       \       '-Dosgi.bundles.defaultStartLevel=4',
  "       \       '-Declipse.product=org.eclipse.jdt.ls.core.product',
  "       \       '-Dlog.level=ALL',
  "       \       '-noverify',
  "       \       '-Dfile.encoding=UTF-8',
  "       \       '-Xmx1G',
  "       \       '-jar',
  "       \       (len(split(glob('~/eclipse.jdt.ls/plugins/org.eclipse.equinox.launcher_*.jar'))) == 1 ?
  "       \         split(glob('~/eclipse.jdt.ls/plugins/org.eclipse.equinox.launcher_*.jar'))[0] : ""),
  "       \       '-configuration',
  "       \       fnamemodify("~", ":p") . '/eclipse.jdt.ls/' . (has('win32') ? 'config_win' : (has('mac') ? 'config_mac' : 'config_linux')),
  "       \       '-data',
  "       \       fnamemodify("~", ":p") . '/.eclipse.jdt.ls/workspace/',
  "       \     ],
  "       \     'root_marker': ['.git', '.project'],
  "       \   }

  " let g:myvimrc_lsp_general_config['go'] =
  "       \   {
  "       \     'name': 'gopls',
  "       \     'filetype': ['go'],
  "       \     'is_executable': executable('gopls'),
  "       \     'cmd': ['gopls', '-mode', 'stdio'],
  "       \   }

  " let g:myvimrc_lsp_general_config['bash'] =
  "       \   {
  "       \     'name': 'bash-language-server',
  "       \     'filetype': ['sh','bash'],
  "       \     'is_executable': executable('bash-language-server'),
  "       \     'cmd': [&shell, &shellcmdflag, 'bash-language-server start'],
  "       \   }

  " let g:myvimrc_vimlsp_config = {}
  " let g:myvimrc_vimlsp_filetypes = []
  " let g:myvimrc_vimlsp_disabled_filetypes = []

  " fun! custom#myvimrc_vimlsp_cmd(key, server_info) abort
  "   return get(g:myvimrc_lsp_general_config[a:key], 'cmd')
  " endf

  " fun! custom#myvimrc_vimlsp_root_uri(key, server_info) abort
  "   return lsp#utils#path_to_uri(mymisc#find_project_dir(extend(get(g:myvimrc_lsp_general_config[a:key],'root_marker',[]), g:mymisc_projectdir_reference_files)))
  " endf

  " fun! custom#myvimrc_vimlsp_setup() abort
  "   aug vimrc_vimlsp
  "     for s:key in keys(g:myvimrc_lsp_general_config)
  "       if g:myvimrc_lsp_general_config[s:key]['is_executable']

  "         let s:cmd_func = eval('function(''custom#myvimrc_vimlsp_cmd'',['''.s:key.'''])')
  "         let s:root_uri_func = eval('function(''custom#myvimrc_vimlsp_root_uri'',['''.s:key.'''])')

  "         let l:vimlsp_config = {}
  "         let l:vimlsp_config['name'] = g:myvimrc_lsp_general_config[s:key]['name']
  "         let l:vimlsp_config['cmd'] = s:cmd_func
  "         let l:vimlsp_config['whitelist'] = g:myvimrc_lsp_general_config[s:key]['filetype']
  "         let l:vimlsp_config['priority'] = 100
  "         let l:vimlsp_config['root_uri'] = s:root_uri_func
  "         exe "let l:vimlsp_config['workspace_config'] = " . string(get(g:myvimrc_lsp_general_config[s:key], 'workspace_config'))

  "         let g:myvimrc_vimlsp_config[s:key] = l:vimlsp_config
  "         call extend(g:myvimrc_vimlsp_filetypes, g:myvimrc_lsp_general_config[s:key]['filetype'])

  "         exe "au User lsp_setup call lsp#register_server(g:myvimrc_vimlsp_config['".s:key."'])"
  "         exe "au FileType " . join(g:myvimrc_lsp_general_config[s:key]['filetype'], ",") . " com! -buffer LspKill call lsp#stop_server('".l:vimlsp_config['name']."')"
  "         exe "au FileType " . join(g:myvimrc_lsp_general_config[s:key]['filetype'], ",") . " echomsg \"Language Server for " . string(s:key) . " is available.\""
  "       else
  "         exe "au FileType " . join(g:myvimrc_lsp_general_config[s:key]['filetype'], ",") . " echoerr \"Language Server for " . string(s:key) . " is not available.\""
  "       endif
  "     endfo

  "     for s:lsp_filetype in g:myvimrc_vimlsp_filetypes
  "       exe "au FileType " . s:lsp_filetype . " nno <buffer> <leader><c-]> :<C-u>LspDefinition<CR>"
  "       exe "au FileType " . s:lsp_filetype . " nno <buffer> K :call <SID>toggle_preview_window()<CR>"
  "       exe "au FileType " . s:lsp_filetype . " vno <buffer> <leader>= :<C-u>'<,'>LspDocumentRangeFormat<CR>"
  "       exe "au FileType " . s:lsp_filetype . " setl omnifunc=lsp#complete"
  "     endfo
  "   aug END
  " }}} OLD Settings END

  au FileType * nno <leader><c-]> :<C-u>LspDefinition<CR>
  au FileType * nno <leader>K :<C-u>call mymisc#toggle_preview_window()<CR>
  au FileType * nno <leader><C-k> :<C-u>call mymisc#toggle_preview_window()<CR>
  au FileType * vno <leader>= :<C-u>'<,'>LspDocumentRangeFormat<CR>
  au FileType * nno <leader>= :<C-u>LspDocumentFormatSync<CR>
  au FileType * nno <leader>=l :<C-u>LspDocumentFormatSync<CR>
  au FileType * nno <leader>=a :<C-u>ALEFix<CR>
  " exe "au FileType * setl omnifunc=lsp#complete"
  " endf

  " call custom#myvimrc_vimlsp_setup()
endf

" vim: foldmethod=marker
