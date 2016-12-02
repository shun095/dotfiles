" vim:set foldmethod=marker:
scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

if exists("g:loaded_mysession_plugin")
    finish
endif
let g:loaded_mysession_plugin = 1

let s:true = 1
let s:false = 0

" MY SESSION FUNCTIONS
" let g:save_session_file = expand('~/.vimsessions/default.vim')

" Init
" let g:session_loaded = s:false
" let g:session_loaded = s:true
if !exists("g:myvimsessions_folder")
    let g:myvimsessions_folder = "~/.vimsessions"
endif

" グローバルやめてぇ～～～～
let g:save_session_flag = s:true " TabMerge, ClearSession時用のフラグ
let g:save_window_file = expand(g:myvimsessions_folder) . '/.vimwinpos'

if isdirectory(expand(g:myvimsessions_folder)) != 1
    call mkdir(expand(g:myvimsessions_folder),"p")
endif

augroup MYSESSIONVIM
    autocmd!
    " nestedしないとSyntaxなどの設定が繁栄されない（BufReadとかがたぶん呼ばれない）
    autocmd VimEnter * nested if @% == '' && mysession#getbufbyte() == 0 | call mysession#load_session("default.vim",s:false) | endif
    " autocmd VimEnter * nested if @% != '' || mysession#getbufbyte() != 0 | call mysession#tab_merge()
    " バックアップ用
    " autocmd CursorHold * if g:save_session_flag == s:true | call mysession#save_session("default.vim",s:false) | endif
    " autocmd CursorHoldI * if g:save_session_flag == s:true | call mysession#save_session("default.vim",s:false) | endif

    autocmd VimLeavePre * call mysession#save_window(g:save_window_file)
    autocmd VimLeavePre * if g:save_session_flag == s:true | call mysession#save_session("default.vim",s:true) | endif
augroup END

" command! TabMerge call mysession#tab_merge()
command! SessionSave call mysession#save_session("savedsession.vim",s:true)
command! SessionLoadSaved call mysession#load_session("savedsession.vim",s:true)
command! SessionLoadLast call mysession#load_session("default.vim",s:true)
command! SessionLoadBackup call mysession#load_session('.backup.vim',s:true)
command! SessionClearAndQuit call mysession#clear_session()


let &cpo = s:save_cpo
unlet s:save_cpo
