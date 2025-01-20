scriptencoding utf-8

fun! mymisc#config#denops#setup() abort
  " Interrupt the process of plugins via <C-c>
  noremap <silent> <C-c> <Cmd>call denops#interrupt()<CR><C-c>
  inoremap <silent> <C-c> <Cmd>call denops#interrupt()<CR><C-c>
  cnoremap <silent> <C-c> <Cmd>call denops#interrupt()<CR><C-c>

  " Restart Denops server
  command! DenopsRestart call denops#server#restart()

  " Fix Deno module cache issue
  command! DenopsFixCache call denops#cache#update(#{reload: v:true})
endfunction
