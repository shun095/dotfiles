if exists('g:loaded_denops_langchain')
  finish
endif
let g:loaded_denops_langchain = 1

augroup langchain
  autocmd!
  autocmd User DenopsPluginPost:langchain call denops#notify('langchain', 'init', [])
augroup END

