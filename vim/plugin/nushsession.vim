" vim:set foldmethod=marker:
scriptencoding utf-8
augroup NUSHSESSION
	autocmd!
	" ==========セッション復帰用自作スクリプト==========
	set sessionoptions=curdir,help,slash,tabpages
	" MY SESSION FUNCTIONS {{{
	" let g:save_session_file = expand('~/.vimsessions/default.vim')

	let g:save_window_file = expand('~/.vimwinpos')
	let s:save_session_flag = 0

	" autocmd VimEnter * nested execute("LoadLastSession")
	" nestedしないとSyntaxなどの設定が繁栄されない（BufReadとかがたぶん呼ばれない）
	autocmd VimEnter * nested if @% == '' && s:GetBufByte() == 0 | execute("LoadLastSession") | endif
	
	function! s:GetBufByte()
		let byte = line2byte(line('$') + 1)
		if byte == -1
			return 0
		else
			return byte - 1
		endif
	endfunction

	" 新しいWindowを開かずタブで開く
	" 	autocmd VimEnter * call s:open_with_tab()

	" TABMERGING
	function! s:tab_merge() abort"{{{
		if len(split(serverlist())) > 1
			tabnew
			tabprevious
			let s:send_file_path = expand("%")
			quit
			call remote_send("GVIM","<ESC><ESC>:tabnew " . s:send_file_path . "<CR>")
			call remote_foreground("GVIM")
			let s:save_session_flag = 1
			quitall
		else
			echo "ウィンドウがひとつだけのためマージできません"
		endif
	endfunction "}}}

	" LOADING SESSION
	function! s:load_session(session_name) abort "{{{
		execute "source" "~/.vimsessions/" . a:session_name
		execute "e!"
	endfunction "}}}

	" SAVING SESSION 
	function! s:save_session(session_name) abort "{{{
		if s:save_session_flag != 1
			execute  "mksession! "  "~/.vimsessions/". a:session_name
		endif
	endfunction "}}}

	" SAVING WINDOW POSITION
	function! s:save_window() abort "{{{
		let options = [
					\ 'set columns=' . &columns,
					\ 'set lines=' . &lines,
					\ 'winpos ' . getwinposx() . ' ' . getwinposy(),
					\ ]
		call writefile(options, g:save_window_file)
	endfunction "}}}

	" SESSION CREAR (DESABLED)
	" function! s:clear_session() abort "{{{
	" 	call s:save_session()
	" 	call rename(expand($HOME) . '/.vimsessions/default.vim' ,expand($HOME) . '/.vimsessions/backup.vim')
	"
	" 	let s:save_session_flag = 1
	" 	quitall
	" endfunction "}}}


	" START UP LOADING (DESABLED)
	" function! s:load_session_on_startup() abort "{{{
	" 	if has("vim_starting")
	" 		if filereadable(g:save_session_file)
	" 			"ほかにVimが起動していなければ
	" 			" if len(split(serverlist())) == 1 || serverlist() == ''
	" 			if serverlist() == ""
	" 				silent source ~/.vimsessions/default.vim
	" 			endif
	" 			" デバッグ用
	" 			" source ~/.vimsessions/default.vim
	" 		endif
	" 	endif
	" endfunction "}}}


	autocmd VimLeavePre * call s:save_window()
	autocmd VimLeavePre * call s:save_session("lastsession.vim")

	command! TabMerge call s:tab_merge()
	command! LoadLastSession call s:load_session("lastsession.vim")

	" command! ClearSession call s:clear_session()
	" call s:load_session_on_startup()
	" ==========セッション復帰用自作スクリプトここまで========== " }}}
augroup END
