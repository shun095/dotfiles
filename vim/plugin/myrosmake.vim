let s:save_cpo = &cpo
set cpo&vim
if exists("g:loaded_myrosmake_plugin")
    finish
endif
let g:loaded_myrosmake_plugin = 1

command! RosmakePackage call myrosmake#rosmake("manifest.xml")
command! RosmakeWorkspace call myrosmake#rosmake("stack.xml")

let &cpo = s:save_cpo
unlet s:save_cpo
