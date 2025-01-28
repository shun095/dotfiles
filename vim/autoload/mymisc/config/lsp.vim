scriptencoding utf-8

fun! mymisc#config#lsp#setup() abort
  " let g:lsp_log_verbose = 1
  " let g:lsp_log_file = $MYVIMRUNTIME . "/vim-lsp.log"
  let g:lsp_log_verbose = 0
  let g:lsp_log_file = ""

  let g:lsp_diagnostics_echo_cursor                      = 1
  let g:lsp_diagnostics_float_cursor                     = 0
  let g:lsp_diagnostics_highlights_enabled               = 1
  let g:lsp_diagnostics_virtual_text_align               = 'after'
  let g:lsp_diagnostics_virtual_text_enabled             = 1
  let g:lsp_diagnostics_virtual_text_insert_mode_enabled = 1
  let g:lsp_diagnostics_virtual_text_padding_left        = 4
  let g:lsp_diagnostics_virtual_text_prefix              = " ■ "

  let g:lsp_inlay_hints_enabled                          = 1

  let g:lsp_semantic_enabled                             = 1

  let g:lsp_show_workspace_edits                         = 1

  let g:lsp_work_done_progress_enabled                   = 1

  " NOTE: A>はLspCodeAction
  " let g:lsp_diagnostics_signs_error       = {'text': 'E'}
  " let g:lsp_diagnostics_signs_warning     = {'text': 'W'}
  " let g:lsp_diagnostics_signs_information = {'text': 'I'}
  " let g:lsp_diagnostics_signs_hint        = {'text': 'H'}

  " hi link LspErrorText ALEErrorSign
  " hi link LspWarningText ALEWarningSign
  " hi link LspInformationText ALEInfoSign
  " hi link LspHintText ALEInfoSign

  " :LspSettingsGlobalEditの一例
  " "eclipse-jdt-ls": {
  "     "root_uri_patterns": [
  "         ".git"
  "     ]
  " },
  " "pylsp-all": {
  "     "workspace_config": {
  "         "pylsp": {
  "             "plugins": {
  "                 "pycodestyle": {
  "                     "maxLineLength": 150
  "                 }
  "             }
  "         }
  "     }
  " }


  aug vimrc_vimlsp
    au!
    au ColorScheme iceberg cal mymisc#patch_highlight_attributes("DiagnosticHint",  "lspInlayHintsParameter",    {"italic":    v:true})
    au ColorScheme iceberg cal mymisc#patch_highlight_attributes("DiagnosticHint",  "lspInlayHintsType",         {"italic":    v:true})

    au ColorScheme iceberg highlight! LspErrorHighlight       term=underline cterm=underline gui=underline
    au ColorScheme iceberg highlight! LspWarningHighlight     term=underline cterm=underline gui=underline
    au ColorScheme iceberg highlight! LspInformationHighlight term=underline cterm=underline gui=underline
    au ColorScheme iceberg highlight! LspHintHighlight        term=underline cterm=underline gui=underline

    au ColorScheme iceberg cal mymisc#patch_highlight_attributes("DiagnosticError", "LspErrorText",       {})
    au ColorScheme iceberg cal mymisc#patch_highlight_attributes("DiagnosticWarn",  "LspWarningText",     {})
    au ColorScheme iceberg cal mymisc#patch_highlight_attributes("DiagnosticInfo",  "LspInformationText", {})
    au ColorScheme iceberg cal mymisc#patch_highlight_attributes("DiagnosticHint",  "LspHintText",        {})

    au ColorScheme iceberg cal mymisc#patch_highlight_attributes("DiagnosticError", "LspErrorVirtualText",       {})
    au ColorScheme iceberg cal mymisc#patch_highlight_attributes("DiagnosticWarn",  "LspWarningVirtualText",     {})
    au ColorScheme iceberg cal mymisc#patch_highlight_attributes("DiagnosticInfo",  "LspInformationVirtualText", {})
    au ColorScheme iceberg cal mymisc#patch_highlight_attributes("DiagnosticHint",  "LspHintVirtualText",        {})
    au FileType * nno <leader><c-]> :<C-u>LspDefinition<CR>
    au FileType * nno <leader>K :<C-u>call mymisc#toggle_preview_window()<CR>
    au FileType * nno <leader><C-k> :<C-u>call mymisc#toggle_preview_window()<CR>
    au FileType * vno <leader>= :<C-u>'<,'>LspDocumentRangeFormat<CR>
    au FileType * nno <leader>= :<C-u>LspDocumentFormatSync<CR>
    au FileType * nno <leader>=l :<C-u>LspDocumentFormatSync<CR>
    au FileType * nno <leader>=a :<C-u>ALEFix<CR>
  aug END
  " exe "au FileType * setl omnifunc=lsp#complete"
  " endf

  " call custom#myvimrc_vimlsp_setup()
endf

" vim: foldmethod=marker
