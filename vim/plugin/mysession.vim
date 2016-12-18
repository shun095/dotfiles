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

" Init
" let mysession#session_loaded = s:false
" let mysession#session_loaded = s:true

if !exists("mysession#myvimsessions_folder")
    let mysession#myvimsessions_folder = "~/.vimsessions"
endif

let mysession#save_session_flag = s:true " TabMerge, ClearSession時用のフラグ
let mysession#save_window_file = expand(mysession#myvimsessions_folder) . '/.vimwinpos'

if isdirectory(expand(mysession#myvimsessions_folder)) != 1
    call mkdir(expand(mysession#myvimsessions_folder),"p")
endif

if has("gui_running")
    if filereadable(expand(mysession#save_window_file))
        execute "source" mysession#save_window_file
    endif
endif

augroup MYSESSIONVIM
    autocmd!
    " nestedしないとSyntaxなどの設定が繁栄されない（BufReadとかがたぶん呼ばれない）
    autocmd VimEnter * nested if @% == '' && mysession#getbufbyte() == 0 | call mysession#load_session("default.vim",s:false) | endif
    autocmd VimLeavePre * call mysession#save_window(mysession#save_window_file)
    autocmd VimLeavePre * if mysession#save_session_flag == s:true | call mysession#save_session("default.vim",s:true) | endif

    " いつか実装したいTabマージ機構
    " autocmd VimEnter * nested if @% != '' || mysession#getbufbyte() != 0 | call mysession#tab_merge()
    " バックアップ用
    " autocmd CursorHold * if mysession#save_session_flag == s:true | call mysession#save_session("default.vim",s:false) | endif
    " autocmd CursorHoldI * if mysession#save_session_flag == s:true | call mysession#save_session("default.vim",s:false) | endif

augroup END

" command! TabMerge call mysession#tab_merge()
command! SessionClearAndQuit call mysession#clear_session()
command! SessionLoadLast call mysession#load_session("default.vim",s:true)
command! SessionLoadSaved call mysession#load_session("savedsession.vim",s:true)
command! SessionSave call mysession#save_session("savedsession.vim",s:true)
command! SessionLoadClearedSession call mysession#load_session('.backup.vim',s:true)

let &cpo = s:save_cpo
unlet s:save_cpo
