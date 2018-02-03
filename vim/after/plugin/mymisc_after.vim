fun! mymisc_after#write_log()
  redir @z
  mes
  redir END
  let content = split(@z, '\n')
  call writefile(content, expand('$HOME/vimlog.txt'))
endf

augroup mymisc_after
  " autocmd VimLeave * call mymisc_after#write_log()
augroup END
