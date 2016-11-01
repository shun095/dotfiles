" vim: set foldmethod=marker:
scriptencoding utf-8
if has("gui_running")
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

	augroup GUIENTER
		autocmd!
		if g:ostype == "win"
			" autocmd GUIEnter * set transparency=255
		else
		endif
	augroup END
	set vb t_vb=

	" if g:use_plugins_flag == s:true
	" 	" 有効なcolorschemeを選択
	" 	" colorscheme summerfruit256
	" 	" colorscheme molokai
	" 	" colorscheme inkpot
	" 	" colorscheme hybrid
	" 	" colorscheme solarized
	" 	" colorscheme itg_flat
	" 	" colorscheme pyte
	" 	" colorscheme morning
	" 	" colorscheme landscape
	" 	" colorscheme onedark
	" 	" set background=dark
	" else
	"  	colorscheme default
	"  	set background=light
	" endif
	" GUI版でのタブ等特殊文字表示色指定
	" highlight! link SpecialKey Special
endif
