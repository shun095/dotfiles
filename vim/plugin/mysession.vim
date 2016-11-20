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

let s:save_session_flag = s:true " TabMerge, ClearSession時用のフラグ
let s:save_window_file = expand(g:myvimsessions_folder) . '/.vimwinpos'

if isdirectory(expand(g:myvimsessions_folder)) != 1
    call mkdir(expand(g:myvimsessions_folder),"p")
endif

augroup MYSESSIONVIM
    autocmd!
    " nestedしないとSyntaxなどの設定が繁栄されない（BufReadとかがたぶん呼ばれない）
    autocmd VimEnter * nested if @% == '' && s:getbufbyte() == 0 | call s:load_session("default.vim") | endif
    autocmd CursorHold * if s:save_session_flag == s:true | call s:save_session("default.vim",s:false) | endif
    autocmd CursorHoldI * if s:save_session_flag == s:true | call s:save_session("default.vim",s:false) | endif
    autocmd VimLeavePre * call s:save_window(s:save_window_file)
    autocmd VimLeavePre * if s:save_session_flag == s:true | call s:save_session("default.vim",s:true) | endif
augroup END

" command! TabMerge call s:tab_merge()
command! SaveSession call s:save_session("savedsession.vim",s:true)
command! LoadSavedSession call s:load_session("savedsession.vim")
command! LoadLastSession call s:load_session("default.vim")
command! LoadBackupSession call s:load_session('.backup.vim')
command! ClearSessionAndQuit call s:clear_session()

function! s:getbufbyte()
    let byte = line2byte(line('$') + 1)
    if byte == -1
        return 0
    else
        return byte - 1
    endif
endfunction

" LOADING SESSION
function! s:load_session(session_name) abort "{{{
    if has("gui_running")
        if filereadable(expand(s:save_window_file))
            execute "source" s:save_window_file
        endif
    endif
    " let g:session_loaded = s:true
    if filereadable(expand(g:myvimsessions_folder . '/' . a:session_name))
        execute "source" g:myvimsessions_folder . "/" . a:session_name
        echom "Session file the name of '" . g:myvimsessions_folder . "/" . a:session_name . "' was loaded."
    else
        echom "No session file the name of '" . g:myvimsessions_folder . "/" . a:session_name . "'."
    endif
endfunction "}}}
" SAVING SESSION
function! s:save_session(session_name,notify_flag) abort "{{{
    " if g:session_loaded == s:true
    execute  "mksession! "  g:myvimsessions_folder . "/" . a:session_name
    if a:notify_flag == s:true
        echom "Session saved to '" . g:myvimsessions_folder . "/" . a:session_name . "'."
    endif
endfunction "}}}
" SAVING WINDOW POSITION
function! s:save_window(save_window_file) abort "{{{
    let options = [
                \ 'set columns=' . &columns,
                \ 'set lines=' . &lines,
                \ 'winpos ' . getwinposx() . ' ' . getwinposy(),
                \ ]
    call writefile(options, a:save_window_file)
endfunction "}}}
" SESSION CREAR
function! s:clear_session() abort "{{{
    call s:save_session("default.vim",s:false)
    call rename(expand(g:myvimsessions_folder) . '/default.vim',
                \ expand(g:myvimsessions_folder) . '/.backup.vim')
    let s:save_session_flag = s:false
    quitall
endfunction "}}}
" TABMERGING
" function! s:tab_merge() abort "{{{
"     if len(split(serverlist())) > 1
"         tabnew
"         tabprevious
"         let l:send_file_path = expand("%")
"         quit
"         " let l:server_list = split(serverlist(),"\n")
"         " let l:send_server_name = l:server_list[0]
"         " echom l:send_server_name
"         call remote_send( "GVIM", "<ESC><ESC>:tabnew " . l:send_file_path . "<CR>")
"         call remote_foreground("GVIM")
"         let s:save_session_flag = s:false
"         quitall
"     else
"         echo "ウィンドウがひとつだけのためマージできません"
"     endif
" endfunction "}}}
" START UP LOADING (DESABLED)
" function! s:load_session_on_startup() abort "{{{
" 	if has("vim_starting")
" 		if filereadable(g:save_session_file)
" 			"ほかにVimが起動していなければ
" 			" if len(split(serverlist())) == 1 || serverlist() == ''
" 			if serverlist() == ""
" 				silent source expand("g:myvimsessions_folder") .  "/default.vim"
" 			endif
" 			" デバッグ用
" 			" source expand("g:myvimsessions_folder"). /default.vim
" 		endif
" 	endif
" endfunction "}}}

let &cpo = s:save_cpo
unlet s:save_cpo
