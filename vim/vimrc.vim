" vim: set foldmethod=marker:
scriptencoding utf-8

if &compatible
    set nocompatible
endif

let s:true = 1
let s:false = 0

let $MYVIMHOME=expand("$HOME") . "/dotfiles/vim"
if !exists("g:use_plugins")
    let g:use_plugins = s:true
endif

" ======================================================================= "
"                         No Plugin Version START                         "
" ======================================================================= "
" Set options {{{
" OSの判定
if has('win32')
    if v:version >= 800
        set rop=type:directx
    endif
    set t_Co=16                    " ターミナルで8色を使う
elseif has('unix')
    set t_Co=256                   " ターミナルで256色を使う
endif

if v:version >= 800                " バージョン検出
    set breakindent                " version8以降搭載の便利オプション
endif

syntax on                          " 色分けされる
set diffopt=filler,iwhite,vertical " diffのときの挙動
set nocursorline                   " カーソル行のハイライト
set nocursorcolumn
set backspace=indent,eol,start     " バックスペース挙動のおまじない
set clipboard=unnamed,unnamedplus  " コピーした文字列がclipboardに入る(逆も）
set ignorecase                     " 大文字小文字無視
set smartcase                      " 大文字で始まる場合は無視しない
set foldmethod=marker              " syntaxに応じて折りたたまれる

set tabstop=4                      " タブの挙動設定。挙動が難しいのでヘルプ参照
set shiftwidth=4
set expandtab
set smartindent
set softtabstop=4

set list                           " タブ,行末スペース、改行等の可視化,また,その可視化時のマーク
set listchars=tab:>-,trail:-,eol:$,\extends:>,precedes:<,nbsp:%

set wildmenu                       " コマンドの補完設定
set wildmode=longest:full,full

set laststatus=2     " 下のステータスバーの表示
set showcmd          " 入力中のコマンドを右下に表示
set cmdheight=2      " コマンドラインの高さ
set showtabline=2    " タブバーを常に表示
set number           " 行番号表示
set norelativenumber
set hlsearch         " 文字列検索時にハイライトする
set incsearch        " 文字入力中に検索を開始
set ruler            " 右下の現在行の表示
set noequalalways      " splitしたときにウィンドウが同じ大きさになるよう調節する
set tags+=./tags;,./tags-ja;     " タグファイルを上層に向かって探す
set autoread         " 他のソフトで、編集中ファイルが変更されたとき自動Reload
set noautochdir      " 今開いてるファイルにカレントディレクトリを移動するか
set scrolloff=5     " カーソルが端まで行く前にスクロールし始める行数
set ambiwidth=double " 全角記号（「→」など）の文字幅を半角２つ分にする
set mouse=a    " マウスを有効化
set nomousehide    " 入力中にポインタを消すかどうか
set nolazyredraw
set background=dark
set sessionoptions=folds,help,tabpages
set updatetime=4000

if executable("ag")
    set grepprg=ag\ --nocolor\ --column\ --nogroup\ $*
else
    set grepprg=grep\ -rn\ $*
endif

" 文字コード自動判別優先順位の設定
set fileencodings=utf-8,sjis,iso-2022-jp,cp932,euc-jp

" 改行コード自動判別優先順位の設定
set fileformats=unix,dos,mac

" Vim側のエンコーディングの設定
set encoding=utf-8
source $VIMRUNTIME/delmenu.vim
set langmenu=ja_jp.utf-8
" set langmenu=en_us.utf-8
source $VIMRUNTIME/menu.vim

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

" IMEの管理
" inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
set iminsert=0
set imsearch=0

" 補完関係の設定
set completeopt=menuone,noselect,preview
set omnifunc=syntaxcomplete#Complete
" set guioptions+=M

" }}}

" Mapping {{{
" 改行があっても真下に移動できるようになる
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" エスケープ２回でハイライトキャンセル
nnoremap <silent> <ESC><ESC> :noh<CR>
vnoremap * "zy:let @/ = @z <CR>n
nnoremap * *N
" nnoremap <expr> <Leader>/ <SID>count_serch_number(":%s/<Cursor>/&/gn")
"}}}

" Commands {{{
" Sudoで強制保存
if has("unix")
    command! Wsudo execute("w !sudo tee % > /dev/null")
endif

" :CdCurrent で現在のファイルのディレクトリに移動できる
" (Kaoriyaに入ってて便利なので実装)
command! CdCurrent cd\ %:h
"}}}

" Functions {{{

function! s:move_cursor_pos_mapping(str, ...)
    let left = get(a:, 1, "<Left>")
    let lefts = join(map(split(matchstr(a:str, '.*<Cursor>\zs.*\ze'), '.\zs'), 'left'), "")
    return substitute(a:str, '<Cursor>', '', '') . lefts
endfunction

" function! s:count_serch_number(str)
"     return s:move_cursor_pos_mapping(a:str, "\<Left>")
" endfunction

function! s:ImInActivate() abort
    call system('fcitx-remote -c')
endfunction

function! s:confirm_do_dein_install() abort
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
"}}}

" Autocmds {{{
augroup VIMRC
    autocmd!
    " タグを</で自動で閉じる
    autocmd Filetype xml,html,eruby
                \ inoremap <buffer> </ </<C-x><C-o><C-n><Esc>F<i

    " タグ系のファイルならインデントを浅くする
    autocmd Filetype html,xml setl expandtab softtabstop=2 shiftwidth=2
    autocmd Filetype html,xml setl foldmethod=indent
    autocmd Filetype css setl foldmethod=syntax

    " python関係の設定
    autocmd FileType python setl autoindent
    autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,
                \try,except,finally,def,class

    " QuickFixを自動で開く
    autocmd QuickFixCmdPost * cwindow
    autocmd FileType qf nnoremap <silent><buffer> q :quit<CR>
    autocmd FileType qf noremap <silent><buffer> p  <CR>*Nzz<C-w>p

    " ヘルプをqで閉じれるようにする
    autocmd FileType help nnoremap <silent><buffer>q :quit<CR>
    " autocmd FileType help echom "test"
    " autocmd FileType help execute "let &tags.=',' 
    " \ . expand('$VIMRUNTIME') . '/doc/tags'"
    " autocmd VimEnter * call s:set_statusline()

    if has("unix")
        " linux用（fcitxでしか使えない）
        autocmd InsertLeave * call s:ImInActivate()
    endif
augroup END
"}}}

" Self constructed plugins {{{
let s:myplugins = expand("$HOME") . "/dotfiles/vim"
execute 'set runtimepath+=' . escape(s:myplugins, ' ')
"}}}

" Included Plugins {{{
if v:version >= 800
    " packadd matchit
    " packadd editexisting
endif
" }}}

" ======================================================================= "
"                       Use Plugins Settings START                        "
" ======================================================================= "
" {{{
" ======================================================================= "
"                             Dein Installing                             "
" ======================================================================= "
" {{{
" 各プラグインをインストールするディレクトリ
let s:plugin_dir = expand('$HOME') . '/.vim/dein/'
" dein.vimをインストールするディレクトリをランタイムパスへ追加
let s:dein_dir = s:plugin_dir . 'repos/github.com/Shougo/dein.vim'
" dein.vimがまだ入ってなければインストールするか確認
if !isdirectory(s:dein_dir)
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
if g:use_plugins == s:true
    " ======================================================================= "
    "                           Plugin Pre Settings                           "
    " ======================================================================= "
    " Plugin pre settings {{{
    " vimprocが呼ばれる前に設定
    let g:vimproc#download_windows_dll = 1
    if filereadable(expand("$HOME")."/dotfiles/vim-local.vim")
        execute "source " . expand("$HOME") . "/dotfiles/vim-local.vim"
    endif
    " }}}
    " ======================================================================= "
    "                  =====================================                  "
    "                                Vim-plug                                 "
    "                  =====================================                  "
    " ======================================================================= "
    " {{{
    " VIM-PLUG 試験利用
    " 起動時に該当ファイルがなければ自動でvim-plugをインストール
    set runtimepath+=~/.vim/
    if !filereadable(expand("$HOME") . "/.vim/autoload/plug.vim") 
        if executable("curl")
            echo "vim-plug will be installed."
            execute printf("!curl -fLo %s/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim", expand("$HOME"))
        else
            echoerr "curlをインストールするか手動でvim-plugをインストールしてください。"
        endif
    endif

    if filereadable(expand("$HOME") . "/.vim/autoload/plug.vim")
        call plug#begin('~/.vim/plugged')

        " COLORSCHEMES
        Plug 'joshdick/onedark.vim'
        Plug 'sickill/vim-monokai'
        Plug 'altercation/vim-colors-solarized'
        Plug 'w0ng/vim-hybrid'
        Plug 'vim-scripts/pyte'
        Plug 'vim-scripts/summerfruit256.vim'
        Plug 'ciaranm/inkpot'
        Plug 'cdmedia/itg_flat_vim'
        Plug 'tomasr/molokai'
        Plug 'itchyny/landscape.vim'
        Plug 'rakr/vim-one'
        " COLORSCHEMESE END
        Plug 'Shougo/vimfiler.vim'
        Plug 'Shougo/unite.vim' 
        call plug#end()
    endif
    " {{{
    " ======================================================================= "
    "                                  Unite                                  "
    " ======================================================================= "
    " 入力モードで開始する
    if isdirectory(expand("~/.vim/plugged/unite.vim")) "{{{
        let g:unite_force_overwrite_statusline = 0
        let g:unite_enable_start_insert = 0
        nnoremap <silent> <Leader>ub :<C-u>Unite buffer<CR>
        nnoremap <silent> <Leader>uf :<C-u>UniteWithBufferDir -buffer-name=files -start-insert file_rec/async<CR>
        nnoremap <silent> <Leader>ur :<C-u>Unite -buffer-name=register register<CR>
        nnoremap <silent> <Leader>um :<C-u>Unite file_mru<CR>
        nnoremap <silent> <Leader>uu :<C-u>Unite buffer file_mru<CR>
        " Unite All
        nnoremap <silent> <Leader>ua :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
        " UniteOutLine
        nnoremap <silent> <Leader>uo :<C-u>Unite -vertical -no-quit -winwidth=40 outline -direction=botright<CR>
        " ウィンドウを分割して開く
        au FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
        au FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
        " ウィンドウを縦に分割して開く
        au FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
        au FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
        " タブで開く
        au FileType unite nnoremap <silent> <buffer> <expr> <C-t> unite#do_action('tabopen')
        au FileType unite inoremap <silent> <buffer> <expr> <C-t> unite#do_action('tabopen')
        " ESCキーを2回押すと終了する
        au FileType unite nmap <silent> <buffer> <ESC><ESC> q
        au FileType unite imap <silent> <buffer> <ESC><ESC> <ESC>q

        "nice unite and ag
        " let g:unite_source_history_yank_enable = 1
        " try
        let g:unite_source_rec_async_command =
                    \ ['ag', '--follow', '--nocolor', '--nogroup',
                    \  '--hidden', '-g', '']
        let g:unite_source_rec_max_cache_files = 5000
        call unite#filters#matcher_default#use(['matcher_fuzzy'])
        " catch
        " endtry
        " search a file in the filetree
        " nnoremap <space><space> :<C-u>Unite -start-insert file_rec/async<cr>
        " reset not it is <C-l> normally
        " nnoremap <space>r <Plug>(unite_restart)
    endif " }}}
    "
    " ======================================================================= "
    "                                VimFiler                                 "
    " ======================================================================= "

    if isdirectory(expand("~/.vim/plugged/vimfile.vim")) " {{{
        let g:vimfiler_force_overwrite_statusline = 0
        let g:vimfiler_enable_auto_cd = 1
        let g:vimfiler_as_default_explorer = 1
        nnoremap <silent> <Leader>e :VimFilerBufferDir -toggle -find -force-quit -split  -status -winwidth=35 -simple -split-action=below<CR>
        nnoremap <silent> <Leader>E :VimFilerCurrentDir -split -toggle -force-quit -status -winwidth=35 -simple -split-action=below<CR>

        " なんの影響だかは不明だがVimfilerは後ろの方においておかないとSyntaxColorが効かなくなる
    endif " }}}

    " VIM-PLUGここまで
    " ======================================================================= "
    "                  =====================================                  "
    "                              Vim-plug END                               "
    "                  =====================================                  "
    " ======================================================================= "
    " }}}

    " ======================================================================= "
    "                  =====================================                  "
    "                                  DEIN                                   "
    "                  =====================================                  "
    " ======================================================================= "
    " Dein main settings {{{
    " escapeでスペースつきのホームフォルダ名に対応
    execute 'set runtimepath+=' . escape(s:dein_dir, ' ')

    let g:plugins_toml = '$MYVIMHOME/dein.toml'
    let g:plugins_lazy_toml = '$MYVIMHOME/dein_lazy.toml'

    filetype off
    filetype plugin indent off
    if dein#load_state(s:plugin_dir,g:plugins_toml,g:plugins_lazy_toml)
        call dein#begin(s:plugin_dir)
        call dein#add('Shougo/dein.vim')

        call dein#load_toml(g:plugins_toml,{'lazy' : 0})
        call dein#load_toml(g:plugins_lazy_toml,{'lazy' : 1})

        call dein#end()
        call dein#save_state()
    endif

    if dein#check_install()
        augroup VIMRC
            autocmd VimEnter * call s:confirm_do_dein_install()
        augroup END
    endif
    filetype plugin indent on
    syntax enable
    " }}}
    " Dein end
    " ======================================================================= "
    "                  =====================================                  "
    "                                Dein END                                 "
    "                  =====================================                  "
    " ======================================================================= "

    " Plugin post settings {{{
    " ターミナルでの色設定
    if has("win32") && !has("gui_running")
        colorscheme default
        cd $HOME
    else
        set background=dark
        colorscheme onedark
        " colorscheme onedark
        " highlight! FoldColumn ctermbg=233 guibg=#0e1013
        highlight! Folded ctermbg=235 ctermfg=none guibg=#282C34 guifg=#abb2bf
        highlight! Normal ctermbg=233 guifg=#abb2bf guibg=#0e1013
        highlight! Vertsplit term=reverse ctermfg=235 ctermbg=235
                    \guifg=#282C34 guibg=#282C34
        " highlight! StatusLine ctermbg=235 guibg=#282C34
        " highlight! StatusLineNC ctermbg=235 guibg=#282C34
        highlight! IncSearch ctermbg=114 guibg=#98C379
    endif
    " }}}
else "if use_plugins == s:false
    " Without plugins settings {{{
    " statusline settings
    set statusline=%F%m%r%h%w%q%=
    set statusline+=[%{&fileformat}]
    set statusline+=[%{has('multi_byte')&&\&fileencoding!=''?&fileencoding:&encoding}]
    set statusline+=%y
    set statusline+=%4p%%%5l:%-3c
    colorscheme torte
    set background=dark
    function! s:NiceLexplore(open_on_bufferdir)
        " 常に幅35で開く
        let g:netrw_winsize = float2nr(round(30.0 / winwidth(0) * 100))
        if a:open_on_bufferdir == 1
            Lexplore %:p:h
        else
            Lexplore
        endif
    endfunction

    " let g:netrw_winsize = 30 " 起動時用の初期化。起動中には使われない
    let g:netrw_browse_split = 4
    let g:netrw_banner = 1
    let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
    let g:netrw_liststyle = 0
    let g:netrw_alto = 1
    let g:netrw_altv = 1
    " カレントディレクトリを変える
    let g:netrw_keepdir = 0

    " バッファファイルのディレクトリで開く
    nnoremap <Leader>e :call <SID>NiceLexplore(1)<CR>
    " カレントディレクトリで開く
    nnoremap <Leader>E :call <SID>NiceLexplore(0)<CR>

    augroup MyNetrw
        autocmd!
        " for toggle
        autocmd FileType netrw nnoremap <buffer><Leader>e :call <SID>NiceLexplore(0)<CR>
        autocmd FileType netrw nnoremap <silent><buffer>q :quit<CR>
        autocmd FileType netrw nmap <silent><buffer>. gh
        autocmd FileType netrw nmap <silent><buffer>h -
        autocmd FileType netrw nmap <silent><buffer>l <CR>
        autocmd FileType netrw unmap <silent><buffer>qf
        autocmd FileType netrw unmap <silent><buffer>qF
        autocmd FileType netrw unmap <silent><buffer>qL
        autocmd FileType netrw unmap <silent><buffer>qb
        " autocmd FileType netrw nnoremap <silent><buffer>qq :quit<CR>
    augroup END
    " function! s:NiceLexplore(on_bufferdir)
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
endif " use_plugins end

" ==========Use Plugins Settings END==========
