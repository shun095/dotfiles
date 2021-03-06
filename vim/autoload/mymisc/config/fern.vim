scriptencoding utf-8

function! mymisc#config#fern#setup() abort

  nnoremap <Leader>e :FernDo :<CR>
  nnoremap <Leader>E :Fern %:h -drawer -reveal=%:p<CR>
  nnoremap <Leader><c-e> :Fern . -drawer -reveal=%:p<CR>
  nnoremap <Leader>n :Fern<space>

  function! s:init_fern() abort
    " Write custom code here

    IndentLinesDisable
    nnoremap <buffer> q :<C-u>close<CR>
    nmap <buffer> <CR> <Plug>(fern-action-open-or-enter)
    nmap <buffer> I <Plug>(fern-action-hidden:toggle)
    nmap <buffer> <C-l> <Plug>(fern-action-reload:all)
    nmap <buffer> o <Plug>(fern-action-open-or-expand)
    nmap <buffer> O <Plug>(fern-action-open:split)
    nmap <buffer> S <Plug>(fern-action-open:vsplit)
    nmap <buffer> x <Plug>(fern-action-collapse)
    nmap <buffer> X <Plug>(fern-action-open:system)
    nmap <buffer> F <Plug>(fern-action-new-file)
    nmap <buffer> u <Plug>(fern-action-leave)
    nmap <buffer> <Plug>(fern-action-zoom) <Plug>(fern-action-zoom:full)
    " Prevent from default mapping
    nmap <buffer> N N
    unmap <buffer> N
    nmap <buffer> n n
    unmap <buffer> n
  endfunction

  augroup vimrc_fern
    autocmd! *
    autocmd FileType fern call s:init_fern()
  augroup END
endfunction
