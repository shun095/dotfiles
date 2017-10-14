
let s:save_cpo = &cpo
set cpo&vim

if exists("g:plugin_mgr")
  finish
endif

let g:dein#install_max_processes = 16

let g:plugin_mgr = {
      \ 'plugin_dir': escape(substitute($HOME.'/.vim/dein','\','/','g'),' '),
      \ 'manager_dir': escape(substitute($HOME.'/.vim/dein/repos/github.com/Shougo/dein.vim','\','/','g'),' '),
      \ 'enabled': false,
      \}

fun! g:plugin_mgr.install() abort
  let succeeded = g:false

  let diag_message = 'Dein is not installed yet.Install now?'
  let install_confirm = confirm(diag_message,"&yes\n&no",2)

  if install_confirm == 1
    call mkdir(self.manager_dir, 'p')
    exe printf('!git clone %s %s', 'https://github.com/Shougo/dein.vim', '"' . self.manager_dir . '"')
    " インストールが完了したらフラグを立てる
    if v:shell_error == 0
      let succeeded = g:true
    else
      echoerr "Dein couldn't be installed correctly."
    endif
  endif

  return succeeded
endfun

fun! g:plugin_mgr.deploy() abort
  " Confirm whether or not install dein if not exists
  if !isdirectory(self.manager_dir) && self.enabled == g:true
    " deinがインストールされてない場合そのままではプラグインは使わない
    let self.enabled = g:false
    if self.install()
      let self.enabled = g:true
    endif
  endif
endf

fun! g:plugin_mgr.plug_install() abort
  augroup vimrc_dein_install_plugs
    autocmd!
  augroup END
  let l:confirm_plugins_install = confirm(
        \ 'Some plugins are not installed yet. Install now?',
        \ "&yes\n&no",2)
  if l:confirm_plugins_install == 1
    call dein#install()
  else
    echomsg 'Plugins are not installed. Please install later.'
  endif
endf

fun! g:plugin_mgr.init() abort
  " Dein main settings {{{
  exe 'set runtimepath+=' . g:plugin_mgr.manager_dir

  let plugins_toml = '$MYVIMHOME/tomlfiles/dein.toml'
  let plugins_lazy_toml = '$MYVIMHOME/tomlfiles/dein_lazy.toml'

  if dein#load_state(g:plugin_mgr.plugin_dir)
    call dein#begin(g:plugin_mgr.plugin_dir)
    call dein#add('Shougo/dein.vim')

    call dein#load_toml(plugins_toml,{'lazy' : 0})
    call dein#load_toml(plugins_lazy_toml,{'lazy' : 1})

    call dein#end()
    call dein#save_state()
  endif

  filetype plugin indent on
  syntax enable

  if dein#check_install()
    " インストールされていないプラグインがあれば確認
    if has('vim_starting')
      augroup vimrc_dein_install_plugs
        autocmd!
        autocmd VimEnter * call g:plugin_mgr.plug_install()
      augroup END
    else
      call g:plugin_mgr.plug_install()
    endif
  endif
endf

let &cpo = s:save_cpo
unlet s:save_cpo
