if exists('g:loaded_themis_denops')
  finish
endif
let g:loaded_themis_denops = 1

augroup themis-denops
  autocmd!
  autocmd User DenopsPluginPost:themis-denops call denops#notify('themis-denops', 'init', [])
augroup END

