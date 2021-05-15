scriptencoding utf-8

function! mymisc#config#lsp#setup() abort
  " let g:lsp_log_verbose = 1
  " let g:lsp_log_file = $HOME . "/.vim/vim-lsp.log"
  augroup vimrc_vimlsp
    autocmd!
  augroup END

  let g:lsp_signs_enabled           = 1
  let g:lsp_signs_error             = {'text': 'E'}
  let g:lsp_signs_warning           = {'text': 'W'}
  let g:lsp_signs_information       = {'text': 'I'}
  let g:lsp_signs_hint              = {'text': 'H'}

  let g:lsp_diagnostics_echo_cursor = 1
  let g:lsp_diagnostics_echo_delay  = 1
  let g:lsp_textprop_enabled = 0

  hi link LspErrorText ALEErrorSign
  hi link LspWarningText ALEWarningSign
  hi link LspInformationText ALEInfoSign
  hi link LspHintText ALEInfoSign

  " let g:myvimrc_lsp_general_config = {}
  " let g:myvimrc_lsp_general_config['cpp'] =
  "       \   {
  "       \     'name': 'clangd',
  "       \     'filetype': ['cpp', 'c', 'hpp', 'h'],
  "       \     'is_executable': executable($HOME.'/.vim/clangd'),
  "       \     'cmd': [$HOME.'/.vim/clangd'],
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

  " function! custom#myvimrc_vimlsp_cmd(key, server_info) abort
  "   return get(g:myvimrc_lsp_general_config[a:key], 'cmd')
  " endfunction

  " function! custom#myvimrc_vimlsp_root_uri(key, server_info) abort
  "   return lsp#utils#path_to_uri(mymisc#find_project_dir(extend(get(g:myvimrc_lsp_general_config[a:key],'root_marker',[]), g:mymisc_projectdir_reference_files)))
  " endfunction

  " function! custom#myvimrc_vimlsp_setup() abort
  "   augroup vimrc_vimlsp
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
  "         exe "au FileType " . join(g:myvimrc_lsp_general_config[s:key]['filetype'], ",") . " command! -buffer LspKill call lsp#stop_server('".l:vimlsp_config['name']."')"
  "         exe "au FileType " . join(g:myvimrc_lsp_general_config[s:key]['filetype'], ",") . " echomsg \"Language Server for " . string(s:key) . " is available.\""
  "       else
  "         exe "au FileType " . join(g:myvimrc_lsp_general_config[s:key]['filetype'], ",") . " echoerr \"Language Server for " . string(s:key) . " is not available.\""
  "       endif
  "     endfor

  "     for s:lsp_filetype in g:myvimrc_vimlsp_filetypes
  "       exe "au FileType " . s:lsp_filetype . " nnoremap <buffer> <leader><c-]> :<C-u>LspDefinition<CR>"
  "       exe "au FileType " . s:lsp_filetype . " nnoremap <buffer> K :call <SID>toggle_preview_window()<CR>"
  "       exe "au FileType " . s:lsp_filetype . " vnoremap <buffer> <leader>= :<C-u>'<,'>LspDocumentRangeFormat<CR>"
  "       exe "au FileType " . s:lsp_filetype . " setl omnifunc=lsp#complete"
  "     endfor
  "   augroup END
  au FileType * nnoremap <leader><c-]> :<C-u>LspDefinition<CR>
  au FileType * nnoremap <leader>K :<C-u>call Myvimrc_toggle_preview_window()<CR>
  au FileType * nnoremap <leader><C-k> :<C-u>call Myvimrc_toggle_preview_window()<CR>
  au FileType * vnoremap <leader>= :<C-u>'<,'>LspDocumentRangeFormat<CR>
  au FileType * nnoremap <leader>= :<C-u>LspDocumentFormatSync<CR>
  au FileType * nnoremap <leader>=l :<C-u>LspDocumentFormatSync<CR>
  au FileType * nnoremap <leader>=a :<C-u>ALEFix<CR>
  " exe "au FileType * setl omnifunc=lsp#complete"
  " endfunction

  " call custom#myvimrc_vimlsp_setup()
endfunction
