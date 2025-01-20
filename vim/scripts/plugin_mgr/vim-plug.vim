
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
      \ 'plugin_dir': escape(substitute($MYVIMRUNTIME . '/plugged','\','/','g'),' '),
      \ 'manager_dir': escape(substitute($MYVIMRUNTIME . '/autoload','\','/','g'),' '),
      \ 'enabled': v:false,
      \ 'init_state': "none"
      \}

fun! g:plugin_mgr.install_plugins() abort
  PlugInstall --sync | source ~/.vimrc
endf

fun! g:plugin_mgr.install() abort
  let succeeded = v:false

  cal system(printf('curl -fLo "%s/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim',substitute($MYVIMRUNTIME,'\','/','g')))

  if v:shell_error == 0
    let succeeded = v:true
  else
    echoerr "vim-plug couldn't be installed correctly."
  endif

  return succeeded
endf

fun! g:plugin_mgr.load() abort
  if !filereadable(self['manager_dir'] . '/plug.vim')
    let self['enabled'] = v:false
    if self['install']()
      exe 'source ' . self['manager_dir'] . '/plug.vim'
      let self['enabled'] = v:true
      let self['init_state'] = "installing"
    endif
  else
    let self['init_state'] = "installed"
  endif
endf

fun! g:plugin_mgr.init() abort
  " let g:plug_window = 'topleft new'
  set runtimepath+=$MYVIMRUNTIME
  cal plug#begin(self['plugin_dir'])
  source $MYDOTFILES/vim/scripts/plugin_mgr/plugin-list.vim
  cal plug#end()

  return self['init_state']

endf


let &cpo = s:save_cpo
unlet s:save_cpo
