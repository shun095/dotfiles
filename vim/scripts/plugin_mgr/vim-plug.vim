
let s:save_cpo = &cpo
set cpo&vim

if exists("g:plugin_mgr")
  finish
endif

let g:plugin_mgr = {
      \ 'plugin_dir': escape(substitute($HOME.'/.vim/plugged','\','/','g'),' '),
      \ 'manager_dir': escape(substitute($HOME.'/.vim/autoload','\','/','g'),' '),
      \ 'enabled': false,
      \}

fun! g:plugin_mgr.install() abort
  let succeeded = g:false

  exe printf('!curl -fLo "%s/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim',substitute($HOME,'\','/','g'))

  if v:shell_error == 0
    let succeeded = g:true
  else
    echoerr "vim-plug couldn't be installed correctly."
  endif

  return succeeded
endfun

fun! g:plugin_mgr.deploy() abort
  if !filereadable(self.manager_dir . '/plug.vim')
    let self.enabled = g:false
    if self.install()
      exe 'source ' . self.manager_dir . '/plug.vim'
      let self.enabled = g:true
    endif
  endif
endf

fun! g:plugin_mgr.init() abort
  let g:plug_window = 'topleft new'
  set runtimepath+=$HOME/.vim
  call plug#begin(self.plugin_dir)
  source $MYDOTFILES/vim/scripts/plugin_mgr/vim-plug_list.vim
  call plug#end()

  source $MYVIMHOME/scripts/lazy_hooks.vim

  augroup _myplug
    autocmd!
    for plugname in keys(g:plugs)
      if has_key(g:plugs[plugname], 'event')
        if type(g:plugs[plugname]['event']) == v:t_string
          execute 'autocmd ' . g:plugs[plugname]['event'] . ' * call g:plugin_mgr.lazy_hook(''' . plugname . ''')'

        elseif type(g:plugs[plugname]['event']) == v:t_list
          for cmd in g:plugs[plugname]['event']
            execute 'autocmd ' . cmd . ' * call g:plugin_mgr.lazy_hook(''' . plugname . ''')'
          endfor

        endif
      elseif g:plugin_mgr.lazy_hook_available(plugname)
        execute 'autocmd VimEnter * call g:plugin_mgr.lazy_hook('''.plugname.''')'
      endif
    endfor
  augroup END

endfun


let &cpo = s:save_cpo
unlet s:save_cpo
