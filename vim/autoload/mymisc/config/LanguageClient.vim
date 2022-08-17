scriptencoding utf-8

fun! mymisc#config#LanguageClient#setup() abort
  " let g:LanguageClient_loggingLevel = 'DEBUG'
  " let g:LanguageClient_loggingFile = $MYVIMRUNTIME.'/languageClient.log'
  " let g:LanguageClient_serverStderr = $MYVIMRUNTIME.'/languageServer.log'

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
        \ [$MYVIMRUNTIME.'/clangd']
  let g:LanguageClient_serverCommands['hpp'] =
        \ [$MYVIMRUNTIME.'/clangd']
  let g:LanguageClient_serverCommands['c'] =
        \ [$MYVIMRUNTIME.'/clangd']
  let g:LanguageClient_serverCommands['h'] =
        \ [$MYVIMRUNTIME.'/clangd']
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
  aug vimrc_langclient
    au!
    au FileType vue setlocal iskeyword+=$ iskeyword+=-
    au FileType c,cpp,h,hpp,python nno <buffer> <C-]> :call LanguageClient#textDocument_definition()<CR>
  aug END

  com! LC call LanguageClient_contextMenu()
  com! LCHover call LanguageClient#textDocument_hover()
  com! LCDefinition call LanguageClient#textDocument_definition()
  com! LCTypeDefinition call LanguageClient#textDocument_typeDefinition()
  com! LCImplementation call LanguageClient#textDocument_implementation()
  com! LCRename call LanguageClient#textDocument_rename()
  com! LCDocumentSymbol call LanguageClient#textDocument_documentSymbol()
  com! LCReferences call LanguageClient#textDocument_references()
  com! LCCodeAction call LanguageClient#textDocument_codeAction()
  com! LCCompletion call LanguageClient#textDocument_completion()
  com! LCFormatting call LanguageClient#textDocument_formatting()
  com! -range LCRangeFormatting call LanguageClient#textDocument_rangeFormatting()
  com! -bang LCDocumentHighlight if empty('<bang>')
        \ | call LanguageClient#textDocument_documentHighlight()
        \ | else
          \ | call LanguageClient#clearDocumentHighlight()
          \ | endif

endf
