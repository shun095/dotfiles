" vim: set foldmethod=marker:
scriptencoding utf-8

if has("gui_running")
    let s:true = 1
    let s:false = 0

    set linespace=1
    set cmdheight=2
    set guioptions=rchb
    " フォントを設定
    if has("win32")
        " set guifont=Myrica_M_for_Powerline:h12
        set guifont=ＭＳ_ゴシック:h10
        " set guifont=Ricty_Diminished_for_Powerline:h12
    elseif has("unix")
        set guifont=Ricty\ Diminished\ for\ Powerline\ 12
        " set guifont=Myrica\ M\ for\ Powerline\ 12
    endif

    set vb t_vb=

    " if g:use_plugins_flag == s:true
    "     " 有効なcolorschemeを選択
    "     " colorscheme summerfruit256
    "     " colorscheme molokai
    "     " colorscheme inkpot
    "     " colorscheme hybrid
    "     " colorscheme solarized
    "     " colorscheme itg_flat
    "     " colorscheme pyte
    "     " colorscheme morning
    "     " colorscheme landscape
    "     " colorscheme onedark
    "     " set background=dark
    " else
    "     colorscheme default
    "     set background=light
    " endif
    " GUI版でのタブ等特殊文字表示色指定
    " highlight! link SpecialKey Special
endif
