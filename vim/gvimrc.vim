" vim: set foldmethod=marker:
scriptencoding utf-8

if has('gui_running')
	let s:true = 1
	let s:false = 0

	set linespace=1
	set cmdheight=3
	set guioptions=rchb
	" フォントを設定
	if has('win32')
		set guifont=Myrica_M_for_Powerline:h12
		" set guifont=ＭＳ_ゴシック:h10
		" set guifont=Ricty_Diminished_for_Powerline:h11
	elseif has('unix')
		" set guifont=Ricty\ Diminished\ for\ Powerline\ 11
		set guifont=Myrica\ M\ 12
	endif

	set vb t_vb=
endif
