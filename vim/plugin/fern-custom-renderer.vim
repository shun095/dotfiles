if exists('g:loaded_denops_mymisc')
  finish
endif
let g:loaded_denops_mymisc = 1

augroup fern-custom-renderer
  autocmd!
  autocmd User DenopsPluginPost:fern-custom-renderer call denops#notify('fern-custom-renderer', 'init', [])
augroup END

