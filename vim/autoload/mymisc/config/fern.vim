scriptencoding utf-8

function! mymisc#config#fern#setup() abort
  nnoremap <Leader>e :FernFocus -drawer<CR>
  nnoremap <Leader>E :Fern %:h -drawer -reveal=%:p<CR>
  nnoremap <Leader><c-e> :Fern . -drawer -reveal=%:p<CR>
  nnoremap <Leader>n :Fern<space>
  augroup vimrc_fern
    autocmd! *
    autocmd FileType fern setl nonumber
    autocmd FileType fern IndentLinesDisable
    nnoremap <buffer> q <Plug>(fern-action
  augroup END
endfunction
