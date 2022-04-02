scriptencoding utf-8
if &compatible
  set nocompatible
endif

fun! mymisc#startup#plug_tap(name) abort
  if exists('*dein#tap')
    return dein#tap(a:name)
  elseif exists(':Jetpack')
    return jetpack#tap(a:name)
  elseif exists(':Plug')
    return has_key(g:plugs,a:name)
  else
    return g:false
  endif
endf
