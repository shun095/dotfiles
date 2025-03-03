scriptencoding utf-8

fun! mymisc#config#fzf#setup() abort
  if exists("g:ctrlp_user_command") && g:ctrlp_user_command !=# ''
    let $FZF_DEFAULT_COMMAND = substitute(g:ctrlp_user_command,'%s','.','g')
  endif

  nno <Leader><Leader> :<C-u>execute ":Files " . mymisc#find_project_dir(g:mymisc_projectdir_reference_files)<CR>
  nno <Leader>T        :<C-u>Tags<CR>
  nno <Leader>al       :<C-u>Lines<CR>
  nno <Leader>b        :<C-u>Buffers<CR>
  nno <Leader>c        :<C-u>Files<CR>
  nno <Leader>f        :<C-u>execute ":Files " . mymisc#find_project_dir(g:mymisc_projectdir_reference_files)<CR>
  nno <Leader>gr       :<C-u>Grep<Space>
  nno <Leader>l        :<C-u>BLines<CR>
  nno <Leader>o        :<C-u>BTags<CR>
  " r
  nno <Leader>u        :<C-u>History<CR>
  nno <Leader>`        :<C-u>Marks<CR>

  com! -bang -nargs=* Grep
        \ call fzf#vim#grep(
        \   substitute(&grepprg, '\$\*', '', 'g' ).' --color=always '.shellescape(<q-args>).' .', 0,
        \   <bang>0 ? fzf#vim#with_preview('up:60%')
        \           : fzf#vim#with_preview('right:50%:hidden', 'ctrl-/'),
        \   <bang>0)

  com! -bang -nargs=* Rg
        \ call fzf#vim#grep(
        \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 0,
        \   <bang>0 ? fzf#vim#with_preview('up:60%')
        \           : fzf#vim#with_preview('right:50%:hidden', 'ctrl-/'),
        \   <bang>0)

  com! -bang -nargs=* GGrep
        \ call fzf#vim#grep(
        \   'git grep --line-number '.shellescape(<q-args>), 0,
        \   extend({ 'dir': systemlist('git rev-parse --show-toplevel')[0] },
        \          <bang>0 ? fzf#vim#with_preview('up:60%')
        \                  : fzf#vim#with_preview('right:50%:hidden', 'ctrl-/')),
        \   <bang>0)

  exe "com! Dotfiles :FZF " . $MYDOTFILES
  " vimのpopup windowは行番号が消えたり、GGrepに失敗(Gitリポジトリ外で実行するなど)
  " した場合に表示が壊れたり不安定
  if has('nvim')
    let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.9 }}
  else
  " tmuxを使うとテストができない
  " if exists('$TMUX')
  "   let g:fzf_layout = { 'tmux': 'bottom,50%' }
  " else
    let g:fzf_layout = { 'window': 'botright 20new' }
  endif
  " endif

  if has('nvim')
    aug vimrc_fzf
      au!
      if exists(':IndentLinesDisable')
        au FileType fzf IndentLinesDisable
      endif
      au FileType fzf setl nonumber norelativenumber
      au FileType fzf nno <buffer> <ESC> i<ESC>
    aug END
  endif
endf
