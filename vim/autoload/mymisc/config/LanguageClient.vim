scriptencoding utf-8

function! mymisc#config#LanguageClient#setup() abort
  " let g:LanguageClient_loggingLevel = 'DEBUG'
  " let g:LanguageClient_loggingFile = $HOME.'/.vim/languageClient.log'
  " let g:LanguageClient_serverStderr = $HOME.'/.vim/languageServer.log'

  let g:LanguageClient_serverCommands = {}
  if has('win32')
    let g:LanguageClient_serverCommands['javascript'] =
          \ [$APPDATA.'/npm/javascript-typescript-stdio.cmd']
    let g:LanguageClient_serverCommands['typescript'] =
          \ [$APPDATA.'/npm/javascript-typescript-stdio.cmd']
    let g:LanguageClient_serverCommands['vue'] =
          \ [$APPDATA.'/npm/vls.cmd']
  else
    let g:LanguageClient_serverCommands['javascript'] =
          \ ['javascript-typescript-stdio']
    let g:LanguageClient_serverCommands['typescript'] =
          \ ['javascript-typescript-stdio']
    let g:LanguageClient_serverCommands['vue'] =
          \ ['vls']
  endif

  let g:LanguageClient_serverCommands['cpp'] =
        \ [$HOME.'/.vim/clangd']
  let g:LanguageClient_serverCommands['hpp'] =
        \ [$HOME.'/.vim/clangd']
  let g:LanguageClient_serverCommands['c'] =
        \ [$HOME.'/.vim/clangd']
  let g:LanguageClient_serverCommands['h'] =
        \ [$HOME.'/.vim/clangd']
  let g:LanguageClient_serverCommands['rust'] =
        \ ['rls']
  let g:LanguageClient_serverCommands['python'] =
        \ ['python', '-m', 'pyls']
  let g:LanguageClient_diagnosticsEnable = 1

  let g:LanguageClient_diagnosticsDisplay =
        \ {
        \   1: {
        \     "name": "Error",
        \     "texthl": "ALEError",
        \     "signText": "E",
        \     "signTexthl": "ALEErrorSign",
        \   },
        \   2: {
        \     "name": "Warning",
        \     "texthl": "ALEWarning",
        \     "signText": "W",
        \     "signTexthl": "ALEWarningSign",
        \   },
        \   3: {
        \     "name": "Information",
        \     "texthl": "ALEInfo",
        \     "signText": "I",
        \     "signTexthl": "ALEInfoSign",
        \   },
        \   4: {
        \     "name": "Hint",
        \     "texthl": "ALEInfo",
        \     "signText": "H",
        \     "signTexthl": "ALEInfoSign",
        \   },
        \ }
  augroup vimrc_langclient
    autocmd!
    autocmd FileType vue setlocal iskeyword+=$ iskeyword+=-
    autocmd FileType c,cpp,h,hpp,python nnoremap <buffer> <C-]> :call LanguageClient#textDocument_definition()<CR>
  augroup END

  command! LC call LanguageClient_contextMenu()
  command! LCHover call LanguageClient#textDocument_hover()
  command! LCDefinition call LanguageClient#textDocument_definition()
  command! LCTypeDefinition call LanguageClient#textDocument_typeDefinition()
  command! LCImplementation call LanguageClient#textDocument_implementation()
  command! LCRename call LanguageClient#textDocument_rename()
  command! LCDocumentSymbol call LanguageClient#textDocument_documentSymbol()
  command! LCReferences call LanguageClient#textDocument_references()
  command! LCCodeAction call LanguageClient#textDocument_codeAction()
  command! LCCompletion call LanguageClient#textDocument_completion()
  command! LCFormatting call LanguageClient#textDocument_formatting()
  command! -range LCRangeFormatting call LanguageClient#textDocument_rangeFormatting()
  command! -bang LCDocumentHighlight if empty('<bang>')
        \ | call LanguageClient#textDocument_documentHighlight()
        \ | else
          \ | call LanguageClient#clearDocumentHighlight()
          \ | endif

endfunction
