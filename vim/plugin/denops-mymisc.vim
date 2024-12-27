if exists('g:loaded_denops_mymisc')
  finish
endif
let g:loaded_denops_mymisc = 1

augroup denops-mymisc
  autocmd!
  autocmd User DenopsPluginPost:denops-mymisc call denops#notify('denops-mymisc', 'init', [])
augroup END

