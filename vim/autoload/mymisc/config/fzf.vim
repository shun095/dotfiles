scriptencoding utf-8

function! mymisc#config#fzf#setup() abort
  if exists("g:ctrlp_user_command") && g:ctrlp_user_command !=# ''
    let $FZF_DEFAULT_COMMAND = substitute(g:ctrlp_user_command,'%s','.','g')
  endif

  " for GVIM
  if !exists('$FZF_DEFAULT_OPTS')
    let $FZF_DEFAULT_OPTS="--height 50% --reverse --preview \"cat {}\" --preview-window=right:50%:hidden --bind=?:toggle-preview"
  endif

  function! s:history(arg, options, bang)
  let bang = a:bang || a:arg[len(a:arg)-1] == '!'
    let options = a:options
    if a:arg[0] == ':'
      call fzf#vim#command_history(options, bang)
    elseif a:arg[0] == '/'
      call fzf#vim#search_history(options, bang)
    else
      call fzf#vim#history(options, bang)
    endif
  endfunction

  command! -bang -nargs=* Grep
        \ call fzf#vim#grep(
        \   substitute(&grepprg, '\$\*', '', 'g' ).' -i --color=always '.shellescape(<q-args>).' .', 0,
        \   <bang>0 ? fzf#vim#with_preview('up:60%')
        \           : fzf#vim#with_preview('right:50%:hidden', '?'),
        \   <bang>0)

  command! -bang -nargs=* Rg
        \ call fzf#vim#grep(
        \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 0,
        \   <bang>0 ? fzf#vim#with_preview('up:60%')
        \           : fzf#vim#with_preview('right:50%:hidden', '?'),
        \   <bang>0)

  command! -bang -nargs=* History call s:history(<q-args>, {'options': '--no-sort'}, <bang>0)

  nnoremap <Leader><Leader> :<C-u>execute ":Files " . mymisc#find_project_dir(g:mymisc_projectdir_reference_files)<CR>
  nnoremap <Leader>T        :<C-u>Tags<CR>
  nnoremap <Leader>al       :<C-u>Lines<CR>
  nnoremap <Leader>b        :<C-u>Buffers<CR>
  nnoremap <Leader>c        :<C-u>Files<CR>
  nnoremap <Leader>f        :<C-u>execute ":Files " . mymisc#find_project_dir(g:mymisc_projectdir_reference_files)<CR>
  " gr
  nnoremap <Leader>l        :<C-u>BLines<CR>
  nnoremap <Leader>o        :<C-u>BTags<CR>
  " r
  nnoremap <Leader>u        :<C-u>History<CR>
  nnoremap <Leader>`        :<C-u>Marks<CR>

  command! -bang -nargs=* GGrep
        \ call fzf#vim#grep(
        \   'git grep --line-number '.shellescape(<q-args>), 0,
        \   extend({ 'dir': systemlist('git rev-parse --show-toplevel')[0] },
        \          <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?')),
        \   <bang>0)

  exe "command! Dotfiles :FZF " . $MYDOTFILES

  let g:fzf_layout = { 'window': 'botright 20new' }
  " augroup vimrc_fzf
  "   autocmd!
  "   autocmd  FileType fzf set laststatus=0 noshowmode noruler
  "         \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
  " augroup END
endfunction
