let s:hook = {
      \ 'name' : 'stdin_thrower',
      \ 'kind' : 'hook', 
      \ 'config' : {
      \   'enable' : 0,
      \   },
      \ }

function! s:hook.on_module_loaded(session, context)
endfunction
