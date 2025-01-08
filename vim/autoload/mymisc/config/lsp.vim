scriptencoding utf-8

fun! mymisc#config#lsp#setup() abort
  " let g:lsp_log_verbose = 1
  " let g:lsp_log_file = $MYVIMRUNTIME . "/vim-lsp.log"
  let g:lsp_log_verbose = 0
  let g:lsp_log_file = ""

  let g:lsp_diagnostics_echo_cursor                      = 1
  let g:lsp_diagnostics_float_cursor                     = 0
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
    let l:hl = hlget(a:source_group_name, v:true)
    let l:hl[0]["name"] = a:target_group_name

    let l:hl[0]["term"] = get(l:hl[0], "term", {})
    let l:hl[0]["cterm"] = get(l:hl[0], "cterm", {})
    let l:hl[0]["gui"] = get(l:hl[0], "gui", {})

    cal extend(l:hl[0]["term"], a:patch)
    cal extend(l:hl[0]["cterm"], a:patch)
    cal extend(l:hl[0]["gui"], a:patch)
    cal hlset(l:hl)
  endfunction

  aug vimrc_vimlsp
    au!
    if has('patch-8.2.3578')
      au VimEnter * cal s:patch_highlight_attributes("Comment","lspInlayHintsParameter",   {"italic":    v:true})
      au VimEnter * cal s:patch_highlight_attributes("Comment","lspInlayHintsType",        {"italic":    v:true})
      au VimEnter * cal s:patch_highlight_attributes("Error","LspErrorVirtualText",        {"underline": v:true})
      au VimEnter * cal s:patch_highlight_attributes("Todo","LspWarningVirtualText",       {"underline": v:true})
      au VimEnter * cal s:patch_highlight_attributes("Normal","LspInformationVirtualText", {"underline": v:true})
      au VimEnter * cal s:patch_highlight_attributes("Normal","LspHintVirtualText",        {"underline": v:true})
    en
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
