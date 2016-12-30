function! myvimrc#ImInActivate() abort
	let fcitx_dbus = system('fcitx-remote -a')
	if fcitx_dbus != ''
		call system('fcitx-remote -c')
	endif
endfunction

function! myvimrc#confirm_do_dein_install() abort
	if !exists("g:my_dein_install_confirmed")
		let s:confirm_plugins_install = confirm(
					\"Some plugins are not installed yet. Install now?",
					\"&yes\n&no",2
					\)
		if s:confirm_plugins_install == 1
			call dein#install()
		else
			echomsg "Plugins were not installed. Please install after."
		endif
		let g:my_dein_install_confirmed = 1
	endif
endfunction

function! myvimrc#NiceLexplore(open_on_bufferdir) abort
	" 常に幅35で開く
	let g:netrw_winsize = float2nr(round(30.0 / winwidth(0) * 100))
	if a:open_on_bufferdir == 1
		Lexplore %:p:h
	else
		Lexplore
	endif
	let g:netrw_winsize = 50
endfunction

function! myvimrc#git_auto_updating() abort
	if !exists("g:called_mygit_func")
		let s:save_cd = getcwd()
		cd ~/dotfiles/
		let s:git_callback_count = 0
		let s:git_qflist = []
		if has('job')
			call job_start('git pull', {'callback': 'myvimrc#git_callback', 'exit_cb': 'myvimrc#git_end_callback'})
		else
			call vimproc#system("git pull &")
		endif
		execute "cd " . s:save_cd
		unlet s:save_cd
		let g:called_mygit_func = 1
	endif
endfunction

" Auto updating vimrc
function! myvimrc#git_callback(ch, msg) abort
	let s:git_callback_count+=1
	call add(s:git_qflist, {'text':a:msg})
	" echom "Myvimrc: " . a:msg
endfunction

function! myvimrc#git_end_callback(ch, msg) abort
	call setqflist(s:git_qflist)
	if s:git_callback_count > 1
		echohl WarningMsg
		echom "New vimrc was downloaded. Please restart to use it!!"
		echohl none
		cope
		if has('gui_running')
			sleep 1
			let l:confirm = confirm("Restart Now?", "&yes\n&no", 2)
			if l:confirm == 1
				Restart
			endif
		endif
		" else
		" echomsg "git git_callback_count was " . s:git_callback_count
	endif
endfunction

fun myvimrc#copypath()
	let @" = expand("%:p")
	let @* = expand("%:p")
	let @+ = expand("%:p")
endf

fun myvimrc#cd_command_cdreturn(destination,commandlist)
	let l:previous_cwd = getcwd()
	exe 'cd ' . a:destination
	for command in a:commandlist
		exe command
	endfor
	exe 'cd ' . l:previous_cwd
endf

fun! myvimrc#find_project_dir(filename) abort
	" init variable
	let l:package_dir = ''

	" ----Reference from help about finddir()---- {{{
	" finddir()
	" 最初に見つかったディレクトリのパスを返す。そのディレクトリがカレントディレクトリの
	" 下にある場合は相対パスを返す。そうでなければ絶対パスを返す。
	" findfile() is same as finddir()
	" }}}
	let l:rosxmlfile = findfile(a:filename, expand('%:p').';')

	if l:rosxmlfile !=# '' && (l:rosxmlfile[0] !=# '/') " ファイルが存在し、絶対パス表記でなかったら
		let l:package_dir = getcwd() . '/' . l:rosxmlfile
	else " ファイルが存在しないか、絶対パス表記だったら
		let l:package_dir = l:rosxmlfile
	endif

	if l:package_dir ==# ''
		echohl WarningMsg
		echom "Appropriate directory couldn't be found!! (There is no " . a:filename . " file.)"
		echohl none
	else
		" ファイル名をパスから削除
		let l:package_dir = fnamemodify(l:package_dir, ':h')
	endif

	return l:package_dir
endf

fun! myvimrc#ctags_project() abort
	let l:tags_dir = myvimrc#find_project_dir('tags')
	if l:tags_dir !=# ''
		call myvimrc#cd_command_cdreturn(l:tags_dir,['call system("ctags -R")'])
	endif
endf
" function! s:move_cursor_pos_mapping(str, ...)
"     let left = get(a:, 1, "<Left>")
"     let lefts = join(map(split(matchstr(a:str, '.*<Cursor>\zs.*\ze'), '.\zs'), 'left'), "")
"     return substitute(a:str, '<Cursor>', '', '') . lefts
" endfunction

" function! s:count_serch_number(str)
"     return s:move_cursor_pos_mapping(a:str, "\<Left>")
" endfunction



" function! s:set_statusline() abort
"     if !exists("g:loaded_lightline")
"         " statusline settings
"         set statusline=%F%m%r%h%w%q%=
"         set statusline+=[%{&fileformat}]
"         set statusline+=[%{has('multi_byte')&&\&fileencoding!=''?&fileencoding:&encoding}]
"         set statusline+=%y
"         set statusline+=%4p%%%5l:%-3c
"     endif
" endfunction
