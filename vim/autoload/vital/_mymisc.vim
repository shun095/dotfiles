let s:_plugin_name = expand('<sfile>:t:r')

fun! vital#{s:_plugin_name}#new() abort
  return vital#{s:_plugin_name[1:]}#new()
endf

fun! vital#{s:_plugin_name}#function(funcname) abort
  silent! return function(a:funcname)
endf
