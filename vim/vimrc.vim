" vim:set foldmethod=marker:
scriptencoding utf-8

if &compatible
    set nocompatible
endif

if exists("g:loaded_myvimrc")
    finish
endif
let g:loaded_myvimrc = 1

let s:true = 1
let s:false = 0

" Vim側のメニューバーのエンコーディングの設定
" set guioptions+=M
set encoding=utf-8
" source $VIMRUNTIME/delmenu.vim
set langmenu=ja_JP.utf-8
" source $VIMRUNTIME/menu.vim

let mapleader = "\<space>"

let $MYVIMHOME=expand("$HOME") . "/dotfiles/vim"
if !exists("g:use_plugins")
    let g:use_plugins = s:true
endif

" ============================== "
"    No Plugin Version START     "
" ============================== "
" Set options {{{
" OSの判定
if has('win32')
    if v:version >= 800
        set rop=type:directx
    endif
    set t_Co=16                    " cmd.exeならターミナルで16色を使う
    let g:solarized_termcolors = 16
elseif has('unix')
    set t_Co=256                   " ターミナルで256色を使う
    let g:solarized_termcolors = 256
endif
set visualbell
set t_vb=

if v:version >= 800                " バージョン検出
    set breakindent                " version8以降搭載の便利オプション
endif

syntax on                          " 色分けされる
set diffopt=filler,iwhite,vertical " diffのときの挙動
set nocursorline                   " カーソル行のハイライト
set nocursorcolumn
set backspace=indent,eol,start     " バックスペース挙動のおまじない
" set clipboard=unnamed,unnamedplus  " コピーした文字列がclipboardに入る(逆も）
set clipboard=
set ignorecase                     " 大文字小文字無視
set smartcase                      " 大文字で始まる場合は無視しない
set foldmethod=marker              " syntaxに応じて折りたたまれる
set tabstop=4                      " タブキーの挙動設定。タブをスペース4つ分とする
set shiftwidth=4                   " インデントでスペース４つ分下げる
set noexpandtab                      " タブをスペースに変換
set smartindent                    " 自動インデントを有効にする
set autoindent
set softtabstop=4                  " バックスペース等でスペースを消す幅
set list                           " タブ,行末スペース、改行等の可視化,また,その可視化時のマーク
set listchars=tab:>-,trail:-,eol:$,extends:>,precedes:<,nbsp:%
set wildmenu                       " コマンドの補完設定
set wildmode=longest:full,full     " コマンドの補完スタイル
set laststatus=2                   " 下のステータスバーの表示
set showcmd                        " 入力中のコマンドを右下に表示
set cmdheight=3                    " コマンドラインの高さ
set showtabline=2                  " タブバーを常に表示
set number                         " 行番号表示
set norelativenumber
set hlsearch                       " 文字列検索時にハイライトする
set incsearch                      " 文字入力中に検索を開始
set ruler                          " 右下の現在行の表示
set noequalalways                  " splitしたときにウィンドウが同じ大きさになるよう調節する
set tags+=./tags;,./tags-ja;       " タグファイルを上層に向かって探す
set autoread                       " 他のソフトで、編集中ファイルが変更されたとき自動Reload
set noautochdir                    " 今開いてるファイルにカレントディレクトリを移動するか
set scrolloff=5                    " カーソルが端まで行く前にスクロールし始める行数
set ambiwidth=double               " 全角記号（「→」など）の文字幅を半角２つ分にする
set emoji                          " 絵文字を全角表示
set mouse=a                        " マウスを有効化
set nomousehide                    " 入力中にポインタを消すかどうか
set nolazyredraw
set sessionoptions=folds,help,tabpages
set updatetime=1000
set fileencodings=utf-8,sjis,iso-2022-jp,cp932,euc-jp " 文字コード自動判別優先順位の設定
set fileformats=unix,dos,mac " 改行コード自動判別優先順位の設定
set complete=.,w,b,u,k,s,t,i,d,t
set completeopt=menuone,noselect,preview " 補完関係の設定
set omnifunc=syntaxcomplete#Complete
set iminsert=0 " IMEの管理
set imsearch=0
" Statusline settings {{{
set statusline=%F%m%r%h%w%q%=
set statusline+=[%{&fileformat}]
set statusline+=[%{has('multi_byte')&&\&fileencoding!=''?&fileencoding:&encoding}]
set statusline+=%y
set statusline+=%4p%%%5l:%-3c
" }}}


" agがあればgrepの代わりにagを使う
if executable("ag")
    set grepprg=ag\ --nogroup\ --nocolor\ --column\ --smart-case\ $*
else
    set grepprg=grep\ -rn\ $*
endif

" set undofileでアンドゥデータをファイルを閉じても残しておく
" 該当フォルダがなければ作成
if isdirectory(expand("$HOME")."/.vim/undofiles") != 1
    call mkdir($HOME."/.vim/undofiles","p")
endif
set undodir=$HOME/.vim/undofiles
set undofile

"  set backupでスワップファイルを保存する
" 該当フォルダがなければ作成
if isdirectory(expand("$HOME")."/.vim/backupfiles") != 1
    call mkdir($HOME."/.vim/backupfiles","p")
endif
set backupdir=$HOME/.vim/backupfiles
set backup
set background=light
" }}}

" Mapping {{{
" 折り返しがあっても真下に移動できるようになる
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
nnoremap <Down> gj
nnoremap <Up> gk

" !マークは挿入モードとコマンドラインモードへのマッピング
noremap! <C-l> <Del>
" エスケープ２回でハイライトキャンセル
nnoremap <silent> <ESC><ESC> :noh<CR>
" ビジュアルモードでも*検索が使えるようにする
vnoremap * "zy:let @/ = @z <CR>n
nnoremap <Leader>. <ESC>:<C-u>edit ~/dotfiles/vim/vimrc.vim<CR>


" }}}

" Commands {{{
" Sudoで強制保存
if has("unix")
    command! Wsudo execute("w !sudo tee % > /dev/null")
endif

" :CdCurrent で現在のファイルのディレクトリに移動できる(Kaoriyaに入ってて便利なので実装)
command! CdCurrent cd\ %:h
" }}}


" Functions (Moved to autoload folder)

" Autocmds {{{
augroup VIMRC
    autocmd!
    " タグを</で自動で閉じる。completeoptに依存している
    autocmd Filetype xml,html,eruby
                \ inoremap <buffer> </ </<C-x><C-o><C-n><Esc>F<i

    " タグ系のファイルならインデントを浅くする
    autocmd Filetype html,xml setl expandtab softtabstop=2 shiftwidth=2
    autocmd Filetype html,xml setl foldmethod=indent
    autocmd Filetype css setl foldmethod=syntax

    " python関係の設定
    let g:python_highlight_all = 1
    autocmd FileType python setl autoindent
    autocmd FileType python setl foldmethod=indent smartindent cinwords=if,elif,else,for,while,
                \try,except,finally,def,class
    autocmd FileType python inoremap <buffer> # X#
    autocmd FileType python nnoremap <buffer> >> i<C-t><ESC>^

    " cpp関係の設定
    autocmd FileType c,cpp setl foldmethod=syntax

    let g:vimsyn_folding = 'aflmpPrt'
    autocmd BufRead *.vim setl foldmethod=syntax

    " QuickFixを自動で開く
    autocmd QuickFixCmdPost * cwindow
    autocmd FileType qf nnoremap <silent><buffer> q :quit<CR>
    " pでプレビューができるようにする
    autocmd FileType qf noremap <silent><buffer> p  <CR>zz<C-w>p

    " ヘルプをqで閉じれるようにする
    autocmd FileType help nnoremap <silent><buffer>q :quit<CR>

    if has("unix")
        " linux用（fcitxでしか使えない）
        autocmd InsertLeave * call myvimrc#ImInActivate()
    endif

    autocmd VimEnter * call myvimrc#git_auto_updating()
augroup END
"}}}

" Self constructed plugins {{{
let s:myplugins = expand("$HOME") . "/dotfiles/vim"
execute 'set runtimepath+=' . escape(s:myplugins, ' ')
"}}}

" Included Plugins {{{
if v:version >= 800
    packadd! matchit
    packadd! editexisting
endif
let g:loaded_getscriptPlugin = 1
let g:loaded_gzip = 1
let g:loaded_logiPat = 1
let g:loaded_tarPlugin = 1
let g:loaded_vimballPlugin = 1
let g:loaded_zipPlugin = 1
" }}}

" Confirm whether or not install dein if not exists {{{
" 各プラグインをインストールするディレクトリ
let s:plugin_dir = expand('$HOME') . '/.vim/dein/'
" dein.vimをインストールするディレクトリをランタイムパスへ追加
let s:dein_dir = s:plugin_dir . 'repos/github.com/Shougo/dein.vim'
" dein.vimがまだ入ってなければインストールするか確認
if !isdirectory(s:dein_dir) && g:use_plugins == s:true
    " deinがインストールされてない場合そのままではプラグインは使わない
    let g:use_plugins = s:false
    " deinを今インストールするか確認
    let s:install_dein_diag_mes = "Dein is not installed yet.Install now?"
    if confirm(s:install_dein_diag_mes,"&yes\n&no",2) == 1
        " deinをインストールする
        call mkdir(s:dein_dir, 'p')
        execute printf('!git clone %s %s',
                    \'https://github.com/Shougo/dein.vim',
                    \'"' . s:dein_dir . '"')
        " インストールが完了したらフラグを立てる
        let g:use_plugins = s:true
    endif
endif
"}}}
"
if g:use_plugins == s:true
    " Use Plugins Settings
    " Plugin pre settings {{{
    " vimprocが呼ばれる前に設定
    let g:vimproc#download_windows_dll = 1
    if filereadable(expand("$HOME")."/dotfiles/vim-local.vim")
        execute "source " . expand("$HOME") . "/dotfiles/vim-local.vim"
    endif
    " プラグインで使われるpythonのバージョンを決定
    if !exists("g:myvimrc_python_version")
        let g:myvimrc_python_version = ""
    endif
    " }}}

    " " Vim-Plug (test){{{
    " " VIM-PLUG 試験利用
    " " 起動時に該当ファイルがなければ自動でvim-plugをインストール
    " set runtimepath+=~/.vim/
    " if !filereadable(expand("$HOME") . "/.vim/autoload/plug.vim")
    "     if executable("curl")
    "         echo "vim-plug will be installed."
    "         execute printf("!curl -fLo %s/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim", expand("$HOME"))
    "     else
    "         echoerr "curlをインストールするか手動でvim-plugをインストールしてください。"
    "     endif
    " endif
    "
    " if filereadable(expand("$HOME") . "/.vim/autoload/plug.vim")
    "     call plug#begin('~/.vim/plugged')
    "     call plug#end()
    " endif

    " " Vim-plug END
    " " }}}

    " Dein main settings {{{
    " escapeでスペースつきのホームフォルダ名に対応
    " ...できていない
    execute 'set runtimepath+=' . escape(s:dein_dir, ' ')

    let g:plugins_toml = '$MYVIMHOME/dein.toml'
    let g:plugins_lazy_toml = '$MYVIMHOME/dein_lazy.toml'

    let g:dein#install_max_processes = 64
    let g:dein#install_process_timeout = 240
    if dein#load_state(s:plugin_dir,g:plugins_toml,g:plugins_lazy_toml)
        call dein#begin(s:plugin_dir)
        call dein#add('Shougo/dein.vim')

        call dein#load_toml(g:plugins_toml,{'lazy' : 0})
        call dein#load_toml(g:plugins_lazy_toml,{'lazy' : 1})

        call dein#end()
        call dein#save_state()
    endif

    filetype plugin indent on
    syntax enable

    if dein#check_install()
        augroup VIMRC
            " インストールされていないプラグインがあれば確認
            autocmd VimEnter * call myvimrc#confirm_do_dein_install()
        augroup END
    endif
    " Dein end
    " }}}

    " Plugin post settings {{{
    " ターミナルでの色設定
    if has("win32") && !has("gui_running")
        colorscheme elflord
        cd $HOME
    else
        " set background=light
        " let g:airline_theme="solarized"
        " colorscheme solarized

        " colorscheme summerfruit256

        set background=dark
        let g:airline_theme="onedark"
        colorscheme onedark
        highlight! IncSearch term=none cterm=none gui=none ctermbg=114 guibg=#98C379
        highlight! Folded ctermbg=235 ctermfg=none guibg=#282C34 guifg=#abb2bf
        highlight! FoldColumn ctermbg=233 guibg=#0e1013
        highlight! Normal ctermbg=233 guifg=#abb2bf guibg=#0e1013
        highlight! Vertsplit term=reverse ctermfg=235 ctermbg=235
                    \guifg=#282C34 guibg=#282C34
        highlight! MatchParen gui=none cterm=none term=none
        highlight! StatusLine ctermbg=235 guibg=#282C34
        highlight! StatusLineNC ctermbg=235 guibg=#282C34

        if has("gui_running")
            let g:indent_guides_auto_colors = 1
        else
            let g:indent_guides_auto_colors = 0
            " solarized(light)
            " autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=230
            " autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=223
            " summerfruit
            " autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=255
            " autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=254
            " one(light)
            " autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=254
            " autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=253
            " onedark
            autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=234
            autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=235
        endif
    endif
    " バッファファイルのディレクトリで開く
    nnoremap <Leader>n :call myvimrc#NiceLexplore(1)<CR>
    " カレントディレクトリで開く
    nnoremap <Leader>N :call myvimrc#NiceLexplore(0)<CR>
    " }}}
else
    " Without plugins settings
    colorscheme default
    set background=light

    " Netrw settings {{{
    "
    " バッファファイルのディレクトリで開く
    nnoremap <Leader>e :call myvimrc#NiceLexplore(1)<CR>
    " カレントディレクトリで開く
    nnoremap <Leader>E :call myvimrc#NiceLexplore(0)<CR>

    " Toggling
    " function! s:NiceLexplore(on_bufferdir) {{{
    "     if exists("t:expl_buf_num")
    "         let expl_win_num = bufwinnr(t:expl_buf_num)
    "         if expl_win_num != -1
    "             let cur_win_nr = winnr()
    "             exec expl_win_num . 'wincmd w'
    "             close
    "             exec cur_win_nr . 'wincmd w'
    "             unlet t:expl_buf_num
    "         else
    "             unlet t:expl_buf_num
    "         endif
    "     else
    "         exec '1wincmd w'
    "         let g:netrw_winsize = float2nr(round(35.0 / winwidth(0) * 100))
    "         if a:on_bufferdir == s:true
    "             Vexplore %:p:h
    "         else
    "             Vexplore .
    "         endif
    "         let t:expl_buf_num = bufnr("%")
    "     endif
    " endfunction
    " }}}
    " }}}
endif
" General Netrw settings {{{
" let g:netrw_winsize = 30 " 起動時用の初期化。起動中には使われない
" let g:netrw_browse_split = 4
let g:netrw_banner = 1
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
let g:netrw_liststyle = 0
let g:netrw_alto = 1
let g:netrw_altv = 1
let g:netrw_banner = 0
" カレントディレクトリを変える
let g:netrw_keepdir = 0

augroup MyNetrw
    autocmd!
    " for toggle
    " autocmd FileType netrw nnoremap <buffer><Leader>e :call <SID>NiceLexplore(0)<CR>
    " autocmd FileType netrw nnoremap <silent><buffer>q :quit<CR>
    autocmd FileType netrw nmap <silent><buffer>. gh
    autocmd FileType netrw nmap <silent><buffer>h -
    autocmd FileType netrw nmap <silent><buffer>l <CR>
    " autocmd FileType netrw unmap <silent><buffer>qf
    " autocmd FileType netrw unmap <silent><buffer>qF
    " autocmd FileType netrw unmap <silent><buffer>qL
    " autocmd FileType netrw unmap <silent><buffer>qb
    " autocmd FileType netrw nnoremap <silent><buffer>qq :quit<CR>
augroup END
" }}}
