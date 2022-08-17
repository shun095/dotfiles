
let s:save_cpo = &cpo
set cpo&vim

if exists("g:plugin_mgr")
  finish
endif

" init_state: none/installing/installed
"   none:       Not installed
"   installing: Installing at this launch
"   installed:  Already installed
let g:plugin_mgr = {
      \ 'manager_dir': escape(substitute($MYVIMRUNTIME . '/pack/jetpack/opt/vim-jetpack/plugin','\','/','g'),' '),
      \ 'enabled': false,
      \ 'init_state': "none"
      \}

fun! g:plugin_mgr.install_plugins() abort
  Jetpack
  so ~/.vimrc
endf

fun! g:plugin_mgr.install() abort
  let succeeded = g:false

  if has('win32')
    call system(printf('curl -fLo "%s/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim" --create-dirs https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim', substitute($MYVIMRUNTIME,'\','/','g')))
  else
    call system(printf('curl -fLo "%s/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim" --create-dirs https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim', substitute($MYVIMRUNTIME,'\','/','g')))
  endif

  if v:shell_error == 0
    let succeeded = g:true
    echomsg "vim-jetpack installed."
  else
    echoerr "vim-jetpack couldn't be installed correctly."
  endif

  return succeeded
endfun

fun! g:plugin_mgr.load() abort
  if has('win32unix')
    if !isdirectory($MYVIMRUNTIME)
      mkdir($HOME . '/vimfiles')
      call system('powershell New-Item -ItemType SymbolicLink -Path "~/.vim" -Target "~/vimfiles"')
    endif
  endif

  if !filereadable(self['manager_dir'] . '/jetpack.vim')
    echomsg string(self['manager_dir'] . '/jetpack.vim')
    let self['enabled'] = g:false
    if self['install']()
      exe 'source ' . self['manager_dir'] . '/jetpack.vim'
      let self['enabled'] = g:true
      let self['init_state'] = "installing"
    endif
  else
    let self['init_state'] = "installed"
  endif
endf

fun! s:call_jetpacksync()
  JetpackSync
endf

fun! g:plugin_mgr.init() abort
  " let g:plug_window = 'topleft new'
  " Alias to Jetpack for migration from vim-plug
  com! -nargs=* Plug Jetpack <args>
  com! -nargs=* PlugInstall cal <SID>call_jetpacksync()
  com! -nargs=* PlugUpdate cal <SID>call_jetpacksync()
  com! -nargs=* PlugUpgrade cal g:plugin_mgr['install']() <args>

  packadd vim-jetpack
  let g:jetpack#optimization = 2
  call jetpack#begin()
  Jetpack 'tani/vim-jetpack', {'opt': 1}
  source $MYDOTFILES/vim/scripts/plugin_mgr/plugin-list.vim
  call jetpack#end()

  return self['init_state']

endf


let &cpo = s:save_cpo
unlet s:save_cpo
