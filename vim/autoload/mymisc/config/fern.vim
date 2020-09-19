scriptencoding utf-8

function! mymisc#config#fern#setup() abort
  nnoremap <Leader>e :FernDo :<CR>
  nnoremap <Leader>E :Fern %:h -drawer -reveal=%:p<CR>
  nnoremap <Leader><c-e> :Fern . -drawer -reveal=%:p<CR>
  nnoremap <Leader>n :Fern<space>
  augroup vimrc_fern
    autocmd! *
    autocmd FileType fern setl nonumber
    autocmd FileType fern IndentLinesDisable
    autocmd FileType fern nnoremap <buffer> q :<C-u>close<CR>
  augroup END
endfunction
