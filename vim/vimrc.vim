" vim: set foldmethod=marker:
scriptencoding utf-8

augroup VIMRC
	autocmd!
	let s:true = 1
	let s:false = 0

	let $NUSHHOME=expand("$HOME") . "/dotfiles/vim"
	let g:use_plugins_flag = s:true

	" =====プラグインなしVerここから======= {{{
	" OSの判定
	if has('win32')
		let g:ostype = "win"
		if v:version >= 800
			set rop=type:directx
		endif
		set t_Co=8                     " ターミナルで16色を使う
	elseif has('mac')
		let g:ostype = "mac"
	else
		let g:ostype = "linux"
		set t_Co=256                   " ターミナルで256色を使う
	endif

	" バージョン検出
	if v:version >= 800
		set breakindent                " version8以降搭載の便利オプション
	endif

	syntax on                          " 色分けされる
	set diffopt=filler,iwhite,vertical " diffのときの挙動
	set nocursorline                   " カーソル行のハイライト
	set backspace=indent,eol,start     " バックスペース挙動のおまじない
	set clipboard=unnamed,unnamedplus  " ヤンクした文字列がクリップボードに入る(逆も）
	set ignorecase                     " 大文字小文字無視
	set smartcase                      " 大文字で始まる場合は無視しない
	" set foldmethod=syntax              " syntaxに応じて折りたたまれる(zRで全部開く、zMで全部閉じる）
	set tabstop=4                      " タブの挙動設定。挙動がややこしいのでヘルプ参照
	set shiftwidth=4
	set noexpandtab
	set smartindent
	set softtabstop=4
	set list                           " タブ,行末スペース、改行等の可視化,またその可視化時のマーク
	set listchars=tab:>-,trail:-,eol:$,extends:>,precedes:<,nbsp:%
	set wildmenu                       " コマンドの補完設定
	set wildmode=longest:full,full
	set laststatus=2                   " 下のステータスバーの表示
	set cmdheight=2                    " コマンドラインの高さ
	set showtabline=2                  " タブバーを常に表示
	set number                         " 行番号表示
	set hlsearch                       " 文字列検索時にハイライトする
	set ruler                          " 右下の現在行の表示
	set equalalways                    " splitしたときにウィンドウが同じ大きさになるよう調節する
	set tags=./tags;                   " タグファイルを上層に向かって探す
	set autoread                       " 他のソフトで開いてるファイルが変更されたとき自動で読み直す
	set noautochdir                    " 今開いてるファイルにカレントディレクトリを移動するか
	set scrolloff=5                    " カーソルが端まで行く前にスクロールし始める行数
	set ambiwidth=double               " 全角記号（「→」など）の文字幅を半角２つ分にする
	set mouse=a
	set background=dark

	" 文字コード自動判別優先順位の設定
	set fileencodings=utf-8,sjis,iso-2022-jp,cp932,euc-jp

	" 改行コード自動判別優先順位の設定
	set fileformats=unix,dos,mac
	set encoding=utf-8

	" set undofileでアンドゥデータをファイルを閉じても残しておく
	" 該当フォルダがなければ作成
	if isdirectory(expand("$HOME")."/.vim/undofiles") != 1
		call mkdir($HOME."/.vim/undofiles","p")
	endif
	set undodir=$HOME/.vim/undofiles
	set undofile

	" set backupでスワップファイルを保存する
	" 該当フォルダがなければ作成
	if isdirectory(expand("$HOME")."/.vim/backupfiles") != 1
		call mkdir($HOME."/.vim/backupfiles","p")
	endif
	set backupdir=$HOME/.vim/backupfiles
	set backup

	" 改行があっても真下に移動できるようになる
	nnoremap j gj
	nnoremap k gk
	nnoremap gj j
	nnoremap gk k

	" エスケープ２回でハイライトキャンセル
	nnoremap <silent> <ESC><ESC> :noh<CR>
	" 新しいタブショートカット
	" nnoremap tn :tabnew 

	cnoremap w!!! w !sudo tee > /dev/null %<CR>

	" 自作コマンド HtmlFormat(挙動は保証しない）
	function! s:htmlformat() abort
		if &filetype == "html" || &filetype == "xml"
			%s/>\s*</></g 
			%s/\v\<(.*).*\>\zs\s*\n*\s*\ze\<\/\1\>//g
			%s/\zs<br>\s*\ze[^$]/<br>/g
			normal gg=G
		else 
			:echo "HTMLファイルではありません"
		endif
	endfunction

	autocmd  FileType html command! HtmlFormat call s:htmlformat()
	" :CdCurrent で現在のファイルのディレクトリに移動できる(Kaoriyaに入ってて便利なので実装)
	command! CdCurrent cd\ %:h

	" タグを</で自動で閉じる
	autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o><Esc>F<i
	autocmd Filetype html inoremap <buffer> </ </<C-x><C-o><Esc>F<i
	autocmd Filetype eruby inoremap <buffer> </ </<C-x><C-o><Esc>F<i

	" タグ系のファイルならインデントを浅くする
	autocmd Filetype html set shiftwidth=2
	autocmd Filetype html set foldmethod=indent
	autocmd Filetype xml set shiftwidth=2
	autocmd Filetype xml set foldmethod=indent
	autocmd Filetype css set foldmethod=syntax

	autocmd FileType python setl autoindent
	autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
	autocmd FileType python setl expandtab tabstop=4 shiftwidth=4 softtabstop=4
	" QuickFixを自動で開く
	autocmd QuickFixCmdPost * cwindow
	autocmd FileType qf nnoremap <silent><buffer> q :quit<CR>
	autocmd FileType qf noremap <silent><buffer> p  <CR>*Nzz<C-w>p

	" ヘルプをqで閉じれるようにする
	autocmd FileType help nnoremap <silent><buffer>q :quit<CR> 

	" 	autocmd FileType vim setlocal path+=$VIM,$HOME/.vim/bundle

	let s:myplugins = expand("$HOME") . "/dotfiles/vim"
	execute 'set runtimepath+=' . s:myplugins

	" IMEの管理
	set iminsert=0
	" map <silent> <ESC> <ESC>:set iminsert=0<CR>
	if g:ostype == "linux"
		" linux用（fcitxでしか使えない）
		" echo "ime off script (on Linux)"
		function! ImInActivate() abort
			call system('fcitx-remote -c')
		endfunction
		imap <silent> <ESC> <ESC>:call ImInActivate()<CR>
	endif

	" tagファイルから色を付ける設定（ヘルプより引用）
	:map <F11>  :sp tags<CR>:%s/^\([^	:]*:\)\=\([^	]*\).*/syntax keyword Tag \2/<CR>:wq! tags.vim<CR>/^<CR><F12>
	:map <F12>  :so tags.vim<CR>:noh<CR>

	" =====プラグインなしVerここまで======= }}}
	"==================================================
	"USING DEIN VIM TO MANAGE PLUGIN
	"==================================================

	if g:use_plugins_flag == s:true
		"{{{ if use_plugins_flag == s:true
		if &compatible
			set nocompatible
		endif

		" vimprocが呼ばれる前に設定
		let g:vimproc#download_windows_dll = 1

		" 各プラグインをインストールするディレクトリ
		let s:plugin_dir = expand('$HOME') . '/.vim/dein/'
		" dein.vimをインストールするディレクトリをランタイムパスへ追加
		let s:dein_dir = s:plugin_dir . 'repos/github.com/Shougo/dein.vim'
		execute 'set runtimepath+=' . escape(s:dein_dir, ' ')

		" dein.vimがまだ入ってなければ 最初に`git clone`
		if !isdirectory(s:dein_dir)
			let s:dein_is_installed = s:false
			" deinを今インストールするか確認
			let s:confirm_dein_install = confirm("Dein is not installed yet.Install now?","&yes\n&no",2)

			" インストールする場合
			if s:confirm_dein_install == 1
				call mkdir(s:dein_dir, 'p')
				silent execute printf('!git clone %s %s', 'https://github.com/Shougo/dein.vim', '"' . s:dein_dir . '"')
				let s:dein_is_installed = s:true
			endif
		else
			let s:dein_is_installed = s:true
		endif

		if s:dein_is_installed == s:true
			filetype off
			filetype plugin indent off
			if g:use_plugins_flag == s:true
				"==================================================
				"DEIN BEGIN
				"==================================================
				let g:plugins_toml = '$NUSHHOME/dein.toml'
				let g:plugins_lazy_toml = '$NUSHHOME/dein_lazy.toml'

				if dein#load_state(s:plugin_dir,g:plugins_toml,g:plugins_lazy_toml)
					call dein#begin(s:plugin_dir)
					call dein#add('Shougo/dein.vim')

					call dein#load_toml(g:plugins_toml,{'lazy' : 0})
					call dein#load_toml(g:plugins_lazy_toml,{'lazy' : 1})

					call dein#end()
					call dein#save_state()
				endif

				if dein#check_install()
					let s:confirm_plugins_install = confirm("Some plugins are not installed yet. Install now?",
								\ "&yes\n&no",2)

					if s:confirm_plugins_install == 1
						call dein#install()
					else
						echomsg "Plugins were not installed. Please install after."
					endif
				endif

				filetype on
				filetype plugin indent on
				syntax enable
				"==================================================
				"DEIN END
				"==================================================
				" ターミナルでの色設定
				if g:ostype == "win"
					set background=dark
					colorscheme desert
					cd $HOME
				else
					set background=dark
					colorscheme onedark
					highlight! vertsplit term=reverse ctermfg=237 ctermbg=237
					highlight! normal ctermbg=233
					highlight! Folded ctermbg=236 ctermfg=none
					highlight! FoldColumn ctermbg=236
				endif
			else
				filetype on
				filetype plugin indent on
				syntax enable
			endif
		endif
		"}}}
	else "if use_plugins_flag = s:false
		set background=dark
		colorscheme desert
		let g:netrw_browse_split = 4
		let g:netrw_altv = 1
		let g:netrw_winsize = 20
		nnoremap <Leader>e :Vexplore<CR>
	endif " use_plugins_flag end

	" helptags $HOME/.vim/doc

augroup END
