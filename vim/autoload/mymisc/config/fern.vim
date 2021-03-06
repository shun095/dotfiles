scriptencoding utf-8

function! mymisc#config#fern#setup() abort

  nnoremap <silent> <Leader>e :FernDo :<CR>
  nnoremap <silent> <Leader>E :Fern %:h -drawer -reveal=%:p<CR>
  nnoremap <silent> <Leader><c-e> :Fern . -drawer -reveal=%:p<CR>
  nnoremap <silent> <Leader>n :Fern<space>

  function! s:init_fern() abort
    " Write custom code here

    IndentLinesDisable
    nnoremap <silent> <buffer> q                        :<C-u>close<CR>
    nmap     <silent> <buffer> <CR>                     <Plug>(fern-action-open-or-enter)
    nmap     <silent> <buffer> <2-LeftMouse>                     <Plug>(fern-action-open-or-enter)
    nmap     <silent> <buffer> I                        <Plug>(fern-action-hidden:toggle)
    nmap     <silent> <buffer> <C-l>                    <Plug>(fern-action-reload:all)
    nmap     <silent> <buffer> o                        <Plug>(fern-action-open-or-expand)
    nmap     <silent> <buffer> O                        <Plug>(fern-action-open:split)
    nmap     <silent> <buffer> S                        <Plug>(fern-action-open:vsplit)
    nmap     <silent> <buffer> x                        <Plug>(fern-action-collapse)
    nmap     <silent> <buffer> X                        <Plug>(fern-action-open:system)
    nmap     <silent> <buffer> F                        <Plug>(fern-action-new-file)
    nmap     <silent> <buffer> u                        <Plug>(fern-action-leave)
    nmap     <silent> <buffer> <Plug>(fern-action-zoom) <Plug>(fern-action-zoom:full)

    " Prevent from default mapping
    nmap  <silent> <buffer> N N
    unmap <silent> <buffer> N
    nmap  <silent> <buffer> n n
    unmap <silent> <buffer> n
  endfunction

  augroup vimrc_fern
    autocmd! *
    autocmd FileType fern call s:init_fern()
  augroup END
endfunction
