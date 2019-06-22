finish
" if exists('g:loaded_closebraces')
"   finish
" endif
" let g:loaded_closebraces = 1

let s:save_cpo = &cpo
set cpo&vim


call closebraces#init()

inoremap ( <C-r>=closebraces#insert('(')<CR>
inoremap ) <C-r>=closebraces#insert(')')<CR>
inoremap ' <C-r>=closebraces#insert('''')<CR>
inoremap <cr> <c-r>=closebraces#insert('cr')<cr>
inoremap <bs> <c-r>=closebraces#insert('bs')<cr>
inoremap <space> <c-r>=closebraces#insert('space')<cr>

let &cpo = s:save_cpo
unlet s:save_cpo
