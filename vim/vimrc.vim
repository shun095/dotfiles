" vim: set foldmethod=marker:
scriptencoding utf-8
let $NUSHHOME=expand("$HOME") . "/dotfiles/vim"
let g:no_plugins_flag = 0
" =====プラグインなしVerここから======= {{{
" OSの判定
if has('win32')
	let g:ostype = "win"
	if v:version >= 800
		set rop=type:directx
	endif
	set t_Co=16                    " ターミナルで16色を使う
elseif has('mac')
	let g:ostype = "mac"
else
	let g:ostype = "linux"
	set t_Co=256				   " ターミナルで256色を使う
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
set foldmethod=syntax              " syntaxに応じて折りたたまれる(zRで全部開く、zMで全部閉じる）
set tabstop=4                      " タブの挙動設定。挙動がややこしいのでヘルプ参照
set shiftwidth=4
set noexpandtab
set smartindent
set softtabstop=4
set list                           " タブ,行末スペース、改行等の可視化,またその可視化時のマーク
set listchars=tab:»-,trail:-,eol:｣,extends:»,precedes:«,nbsp:%
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
nnoremap tn :tabnew 

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

command! HtmlFormat call s:htmlformat()
" :CdCurrent で現在のファイルのディレクトリに移動できる(Kaoriyaに入ってて便利なので実装)
command! CdCurrent cd\ %:h

" タグを</で自動で閉じる
augroup MYXML "{{{
	autocmd!
	autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o><Esc>F<i
	autocmd Filetype html inoremap <buffer> </ </<C-x><C-o><Esc>F<i
	autocmd Filetype eruby inoremap <buffer> </ </<C-x><C-o><Esc>F<i
augroup END "}}}

augroup HTML
	autocmd!
	" タグ系のファイルならインデントを浅くする
	autocmd Filetype html set shiftwidth=2
	autocmd Filetype html set foldmethod=indent
	autocmd Filetype xml set shiftwidth=2
	autocmd Filetype xml set foldmethod=indent
	autocmd Filetype css set foldmethod=syntax
augroup END

augroup MYQUICKFIX
	autocmd!
	" autocmd QuickFixCmdPost * if len(getqflist()) != 0 | copen | else | cclose |endif
	autocmd QuickFixCmdPost * cwindow
	autocmd FileType qf nnoremap <silent><buffer> q :quit<CR>
	autocmd FileType qf noremap <silent><buffer> p  <CR>*Nzz<C-w>p
augroup END

augroup MYHELP
	autocmd!
	autocmd FileType help nnoremap <silent><buffer>q :quit<CR> 
augroup END

" augroup VIM_PATH
" 	autocmd!
" 	autocmd FileType vim setlocal path+=$VIM,$HOME/.vim/bundle
" augroup END

" ==========セッション復帰用自作スクリプト==========
set sessionoptions=curdir,help,slash,tabpages,winsize,winpos,resize
" MY SESSION FUNCTIONS {{{
" let g:save_session_file = expand('~/.vimsessions/default.vim')

let g:save_window_file = expand('~/.vimwinpos')
let s:save_session_flag = 0

augroup RESTORE
	autocmd!
	" autocmd VimEnter * :LoadLastSession
augroup END

" 新しいWindowを開かずタブで開く
" augroup OPEN_WITH_TAB
" 	autocmd!
" 	autocmd VimEnter * call s:open_with_tab()
" augroup END

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

" SESSION CREAR (DESABLED)
" function! s:clear_session() abort "{{{
" 	call s:save_session()
" 	call rename(expand($HOME) . '/.vimsessions/default.vim' ,expand($HOME) . '/.vimsessions/backup.vim')
"
" 	let s:save_session_flag = 1
" 	quitall
" endfunction "}}}

" LOADING SESSION
function! s:load_session(session_name) abort "{{{
	execute "source" "~/.vimsessions/" . a:session_name
endfunction "}}}

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

augroup AUTOSAVE_ONLEAVE
	autocmd!
	autocmd VimLeavePre * call s:save_window()
	autocmd VimLeavePre * call s:save_session("lastsession.vim")
augroup END 

command! TabMerge call s:tab_merge()
command! LoadLastSession call s:load_session("lastsession.vim")
execute "source" g:save_window_file

" command! ClearSession call s:clear_session()
" call s:load_session_on_startup()
" ==========セッション復帰用自作スクリプトここまで========== " }}}

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
command! TagMakeColorring  :sp tags<CR>:%s/^\([^	:]*:\)\=\([^	]*\).*/syntax keyword Tag \2/<CR>:wq! tags.vim<CR>/^<CR><F12>
command! TagColorring :so tags.vim<CR>

" =====プラグインなしVerここまで======= }}}
"==================================================
"USING DEIN VIM TO MANAGE PLUGIN
"==================================================
filetype off
filetype plugin indent off

if g:no_plugins_flag != 1 "{{{
	if &compatible
		set nocompatible
	endif

	set background=dark
	" 各プラグインをインストールするディレクトリ
	let s:plugin_dir = expand('$HOME') . '/.vim/dein/'
	" dein.vimをインストールするディレクトリをランタイムパスへ追加
	let s:dein_dir = s:plugin_dir . 'repos/github.com/Shougo/dein.vim'
	execute 'set runtimepath+=' . escape(s:dein_dir, ' ')
	" dein.vimがまだ入ってなければ 最初に`git clone`
	if !isdirectory(s:dein_dir)
		call mkdir(s:dein_dir, 'p')
		silent execute printf('!git clone %s %s', 'https://github.com/Shougo/dein.vim', '"' . s:dein_dir . '"')
	endif
	"==================================================
	"DEIN BEGIN
	"==================================================
	let g:plugins_toml = '$NUSHHOME/dein.toml'
	let g:plugins_lazy_toml = '$NUSHHOME/dein_lazy.toml'
	if dein#load_state(s:plugin_dir,g:plugins_toml,g:plugins_lazy_toml)
		call dein#begin(s:plugin_dir)
		call dein#add('Shougo/dein.vim')
		call dein#add('vim-scripts/errormarker.vim')

		call dein#load_toml(g:plugins_toml,{'lazy' : 0})
		call dein#load_toml(g:plugins_lazy_toml,{'lazy' : 1})

		call dein#end()
		call dein#save_state()
	endif
	if dein#check_install()
		call dein#install()
	endif
	"==================================================
	"DEIN END
	"==================================================
	"}}}
else "if no_plugins_flag = 1
	set background=dark
	colorscheme industry
endif " no_plugins_flag end


filetype on
filetype plugin indent on
syntax enable

" helptags $HOME/.vim/doc

if g:ostype == "win"
	set background=dark
	colorscheme industry
else
	highlight! VertSplit term=reverse ctermfg=237 ctermbg=237
	set background=dark
	colorscheme onedark
endif

