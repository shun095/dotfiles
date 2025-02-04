scriptencoding utf-8

fun! mymisc#config#denops#setup() abort
  let g:denops_server_addr = '127.0.0.1:32123'
  " Run follwing command for instruction.
  " call denops_shared_server#install()

  " Interrupt the process of plugins via <C-c>
  noremap <silent> <C-c> <Cmd>call denops#interrupt()<CR><C-c>
  inoremap <silent> <C-c> <Cmd>call denops#interrupt()<CR><C-c>
  cnoremap <silent> <C-c> <Cmd>call denops#interrupt()<CR><C-c>

  " Restart Denops server
  command! DenopsRestart call denops#server#restart()

  " Fix Deno module cache issue
  command! DenopsFixCache call denops#cache#update(#{reload: v:true})
endfunction
