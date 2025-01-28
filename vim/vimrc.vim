" vim:set foldmethod=marker:
if !1 | finish | en

scriptencoding utf-8

let g:msgs_on_startup = []

try

  if !exists('$MYDOTFILES')
    let $MYDOTFILES = $HOME . '/dotfiles'
  en

  so $MYDOTFILES/vim/scripts/basic_config.vim

  " PLUGIN MANAGER SETUP {{{

  " so $MYDOTFILES/vim/scripts/plugin_mgr/dein.vim
  so $MYDOTFILES/vim/scripts/plugin_mgr/vim-plug.vim
  " so $MYDOTFILES/vim/scripts/plugin_mgr/vim-jetpack.vim

  let g:plugin_mgr['enabled'] = g:use_plugins

  " Install plugin manager if it's not available
  cal g:plugin_mgr['load']()

  " }}} PLUGIN MANAGER SETUP END

  if g:plugin_mgr['enabled'] == v:true
    " WHEN PLUGINS ARE ENABLED {{{

    " Local settings
    if filereadable($HOME . '/localrcs/vim-local.vim')
      so $HOME/localrcs/vim-local.vim
    en

    " vimproc
    let g:vimproc#download_windows_dll = 1

    " Initialize plugin manager
    if g:plugin_mgr['init']() ==# 'installing'

      aug vimplug_install
        au!
        au VimEnter * cal g:plugin_mgr['install_plugins']()
      aug END
      finish
    en

    try
      " Load settings of plugins
      so $MYVIMHOME/scripts/lazy_hooks.vim
      so $MYVIMHOME/scripts/custom.vim
      so $MYVIMHOME/scripts/custom_global.vim

      " Local after settings
      if filereadable($HOME . '/localrcs/vim-localafter.vim')
        so $HOME/localrcs/vim-localafter.vim
      en
    catch
      cal add(g:msgs_on_startup, 'Error in custom.vim!')
      cal add(g:msgs_on_startup, 'Caught "' . v:exception . '" in ' . v:throwpoint)
    endt

    " Colorschemes
    try
      se background=dark
      if has('gui_running') || $COLORTERM ==# "truecolor"
        colorscheme iceberg
      else
        colorscheme default
        if !has('gui_running')
          se background=dark
        en
      en
    catch
      colorscheme default
      if !has('gui_running')
        se background=dark
      en
    endt

    " hi! Terminal ctermbg=black guibg=black
    " }}} WHEN PLUGINS ARE ENABLED END
  else
    " WHEN PLUGINS ARE DISABLED {{{
    filetype plugin indent on
    syntax enable

    colorscheme default
    if !has('gui_running')
      se background=dark
    en
    " }}} WHEN PLUGINS ARE DISABLED END
  en

  " Let default pwd to $HOME on Windows
  if getcwd() ==# $VIMRUNTIME
    cd $HOME
  en
catch
  " HANDLE ERROR {{{
  cal add(g:msgs_on_startup, 'Error in vimrc!')
  cal add(g:msgs_on_startup, 'Caught "' . v:exception . '" in ' . v:throwpoint)
  if g:is_test
    cal writefile(g:msgs_on_startup, $VADER_OUTPUT_FILE)
    for s:msg in g:msgs_on_startup
      " mymisc#utilが読み込まれないこともあるためここで定義
      exe "echohl ErrorMsg"
      exe "echomsg " . string(s:msg)
      exe "echohl none"
    endfo
    cq!
  en
  " }}}
fina
  " HANDLE ERROR {{{
  aug VIMRC
    for s:msg in g:msgs_on_startup
      " mymisc#utilが読み込まれないこともあるためここで定義
      exe "au VimEnter * echohl ErrorMsg"
      exe "au VimEnter * echomsg " . string(s:msg)
      exe "au VimEnter * echohl none"
    endfo
  aug END
  " }}}
endt
