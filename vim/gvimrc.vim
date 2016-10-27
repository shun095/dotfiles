" vim: set foldmethod=marker:
scriptencoding utf-8
if has("gui")
	let s:true = 1
	let s:false = 0

	set linespace=1
	set cmdheight=2
	set guioptions=rLchb
	set sessionoptions=curdir,help,slash,tabpages
	" フォントを設定
	if g:ostype == "win"
		set guifont=Ricty_Diminished_for_Powerline:h12:cSHIFTJIS
		" echo "os=windows"
	else
		set guifont=Ricty\ Diminished\ for\ Powerline\ 12
		" echo "os=others"
	endif

	execute "source" g:save_window_file
	augroup GUIENTER
		autocmd!
		" autocmd VimEnter * call s:load_session_on_startup()
		if g:ostype == "win"
			" autocmd GUIEnter * set transparency=255
		else
		endif
	augroup END
	set vb t_vb=

	if g:use_plugins_flag == s:true
		" 有効なcolorschemeを選択
		" colorscheme summerfruit256
		" colorscheme molokai
		" colorscheme inkpot
		" colorscheme hybrid
		" colorscheme solarized
		" colorscheme itg_flat
		" colorscheme pyte
		" colorscheme morning
		" colorscheme landscape
		colorscheme onedark
		set background=dark
	else
		colorscheme desert
		set background=dark
	endif
	" GUI版でのタブ等特殊文字表示色指定
	" highlight! link SpecialKey Special
	highlight! Normal  guifg=#abb2bf guibg=#0e1013 
	highlight! VertSplit guifg=#3E4452 guibg=#3E4452
	highlight! Folded guibg=#3E4452 guifg=#abb2bf
	highlight! FoldColumn guibg=#3E4452
endif
