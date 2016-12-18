" vim:set foldmethod=marker:
scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

let s:true = 1
let s:false = 0

" check buffer size
function! mysession#getbufbyte()"{{{
    let byte = line2byte(line('$') + 1)
    if byte == -1
        return 0
    else
        return byte - 1
    endif
endfunction"}}}

" LOADING SESSION
function! mysession#load_session(session_name,notify_flag) abort "{{{
    " let mysession#session_loaded = s:true
    if filereadable(expand(g:mysession#myvimsessions_folder . '/' . a:session_name))
        execute "source" g:mysession#myvimsessions_folder . "/" . a:session_name
        if a:notify_flag == s:true
            echom "Session file the name of '" . g:mysession#myvimsessions_folder . "/" . a:session_name . "' was loaded."
        endif
    else
        if a:notify_flag == s:true
            echom "No session file the name of '" . g:mysession#myvimsessions_folder . "/" . a:session_name . "'."
        endif
    endif
endfunction "}}}

" SAVING SESSION
function! mysession#save_session(session_name,notify_flag) abort "{{{
    " if g:mysession#session_loaded == s:true
    execute  "mksession! "  g:mysession#myvimsessions_folder . "/" . a:session_name
    if a:notify_flag == s:true
        echom "Session saved to '" . g:mysession#myvimsessions_folder . "/" . a:session_name . "'."
    endif
endfunction "}}}

" SAVING WINDOW POSITION
function! mysession#save_window(save_window_file) abort "{{{
    let options = [
                \ 'winsize ' . &columns . ' ' . &lines,
                \ 'winpos ' . getwinposx() . ' ' . getwinposy(),
                \ ]
    call writefile(options, a:save_window_file)
endfunction "}}}

" SESSION CREAR
function! mysession#clear_session() abort "{{{
    call g:mysession#save_session("default.vim",s:false)
    call rename(expand(g:mysession#myvimsessions_folder) . '/default.vim',
                \ expand(g:mysession#myvimsessions_folder) . '/.backup.vim')
    let g:mysession#save_session_flag = s:false
    quitall
endfunction "}}}

" TABMERGING " 複数タブのときの動作がだめ
" function! mysession#tab_merge() abort "{{{
"     if len(split(serverlist())) > 1
"         tabnew
"         tabprevious
"         let s:send_file_path = expand("%:p")
"         quit
"         let s:server_list = split(serverlist(),"\n")
"
"         for s:exist_sever_name in s:server_list
"             if s:exist_sever_name != v:servername
"                 let s:send_server_name = s:exist_sever_name
"                 break
"             endif
"         endfor
"         " echom l:send_server_name
"         call remote_send(s:send_server_name, "<ESC><ESC>:tabnew " . s:send_file_path . "<CR>")
"         call remote_foreground(s:send_server_name)
"         let g:mysession#save_session_flag = s:false
"         quitall
"     else
"         echo "ウィンドウがひとつだけのためマージできません"
"     endif
" endfunction "}}}

" START UP LOADING (DESABLED)
" function! mysession#load_session_on_startup() abort "{{{
" 	if has("vim_starting")
" 		if filereadable(g:mysession#save_session_file)
" 			"ほかにVimが起動していなければ
" 			" if len(split(serverlist())) == 1 || serverlist() == ''
" 			if serverlist() == ""
" 				silent source expand("g:mysession#myvimsessions_folder") .  "/default.vim"
" 			endif
" 			" デバッグ用
" 			" source expand("g:mysession#myvimsessions_folder"). /default.vim
" 		endif
" 	endif
" endfunction "}}}


let &cpo = s:save_cpo
unlet s:save_cpo
