" vim: set foldmethod=marker:
set linespace=1
set cmdheight=2
set guioptions=rLchb
set sessionoptions=curdir,help,slash,tabpages,winsize,winpos,resize
" フォントを設定
if ostype == "win"
	set guifont=Ricty_Diminished_for_Powerline:h11:cSHIFTJIS
	" echo "os=windows"
else
	set guifont=Ricty\ Diminished\ for\ Powerline\ 11
	" echo "os=others"
endif

augroup GUIENTER
	autocmd!
	" autocmd VimEnter * call s:load_session_on_startup()
	if ostype == "win"
		" autocmd GUIEnter * set transparency=255
	else
	endif
augroup END
set vb t_vb=

if g:no_plugins_flag != 1
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
else
	colorscheme industry
	set background=dark
endif
" GUI版でのタブ等特殊文字表示色指定
" highlight! link SpecialKey Special
" highlight! Normal ctermfg=145 ctermbg=16 guifg=#abb2bf guibg=#1d2026  font=Ricty_Diminished_for_Powerline:h11:cSHIFTJIS:qDRAFT
" "
	highlight! VertSplit guifg=#3E4452 guibg=#3E4452
