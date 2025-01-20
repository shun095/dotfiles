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


  function! s:patch_highlight_attributes(source_group_name, target_group_name, patch) abort
    if has('patch-8.2.3578')
      let l:hl = hlget(a:source_group_name, v:true)
      let l:hl[0]["name"] = a:target_group_name

      let l:hl[0]["term"] = get(l:hl[0], "term", {})
      let l:hl[0]["cterm"] = get(l:hl[0], "cterm", {})
      let l:hl[0]["gui"] = get(l:hl[0], "gui", {})

      cal extend(l:hl[0]["term"], a:patch)
      cal extend(l:hl[0]["cterm"], a:patch)
      cal extend(l:hl[0]["gui"], a:patch)
      cal hlset(l:hl)
    elseif has('nvim')
      let l:hl = nvim_get_hl(0, {'name': a:source_group_name, 'link': v:false})

      let l:hl["cterm"] = get(l:hl, "cterm", {})

      cal extend(l:hl, a:patch)
      cal extend(l:hl["cterm"], a:patch)
      cal nvim_set_hl(0, a:target_group_name, l:hl)
    endif
  endfunction

  aug vimrc_vimlsp
    au!
    au ColorScheme * cal s:patch_highlight_attributes("DiagnosticHint",  "lspInlayHintsParameter",    {"italic":    v:true})
    au ColorScheme * cal s:patch_highlight_attributes("DiagnosticHint",  "lspInlayHintsType",         {"italic":    v:true})

    au ColorScheme * highlight! LspErrorHighlight       term=underline cterm=underline gui=underline
    au ColorScheme * highlight! LspWarningHighlight     term=underline cterm=underline gui=underline
    au ColorScheme * highlight! LspInformationHighlight term=underline cterm=underline gui=underline
    au ColorScheme * highlight! LspHintHighlight        term=underline cterm=underline gui=underline

    au ColorScheme * cal s:patch_highlight_attributes("DiagnosticError", "LspErrorText",       {})
    au ColorScheme * cal s:patch_highlight_attributes("DiagnosticWarn",  "LspWarningText",     {})
    au ColorScheme * cal s:patch_highlight_attributes("DiagnosticInfo",  "LspInformationText", {})
    au ColorScheme * cal s:patch_highlight_attributes("DiagnosticHint",  "LspHintText",        {})

    au ColorScheme * cal s:patch_highlight_attributes("DiagnosticError", "LspErrorVirtualText",       {})
    au ColorScheme * cal s:patch_highlight_attributes("DiagnosticWarn",  "LspWarningVirtualText",     {})
    au ColorScheme * cal s:patch_highlight_attributes("DiagnosticInfo",  "LspInformationVirtualText", {})
    au ColorScheme * cal s:patch_highlight_attributes("DiagnosticHint",  "LspHintVirtualText",        {})
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
