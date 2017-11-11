" vim:set foldmethod=marker:
" Initialize {{{
set encoding=utf-8
" set langmenu=ja_JP.utf-8
" set helplang=ja
language C

scriptencoding utf-8
if &compatible
  set nocompatible
endif

let g:true = 1
let g:false = 0

if filereadable($HOME . '/.vim/not_confirms.vim')
  source $HOME/.vim/not_confirms.vim
endif

" set guioptions+=M

if !exists('$MYDOTFILES')
  let $MYDOTFILES = $HOME . '/dotfiles'
endif

let $MYVIMHOME=$MYDOTFILES . '/vim'

if !exists('g:use_plugins')
  let g:use_plugins = g:true
endif
" }}}

" ============================== "
" No Plugin Settings             "
" ============================== "
" Set options {{{
let g:mapleader = "\<space>"

augroup VIMRC
  " このスクリプトで使うautocmdを初期化
  autocmd!
augroup END

" OSの判定
if has('win32')
  set t_Co=16         " cmd.exeならターミナルで16色を使う
  let g:solarized_termcolors = 16

elseif has('unix')
  set t_Co=256        " ターミナルで256色を使う
  let g:solarized_termcolors = 256

  if v:version >= 800 || has('nvim')
    set termguicolors " ターミナルでTrueColorを使う
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif

  " 背景をクリア
  set t_ut=

  if !has('nvim')
    set ttymouse=xterm2 " 通常vim用
    if v:version > 800
      set cryptmethod=blowfish2
    endif
  endif

  if $TERM !=# 'linux'
    if executable('gnome-terminal')


      if has('job') && v:version >= 800
        call job_start('gnome-terminal --version',{'callback':'myvimrc#gnometerm_detection'})

      else
        let s:gnome_term_ver = split(split(system('gnome-terminal --version'))[2], '\.')
        augroup VIMRC
          autocmd VimEnter * call myvimrc#set_tmux_code(s:gnome_term_ver)
        augroup END
      endif

    endif
  endif
endif

" ビープ音を鳴らなくする
set visualbell
set t_vb=

" set diffopt=filler,iwhite                   " diffのときの挙動
set nocursorline                  " カーソル行のハイライト
set nocursorcolumn
set backspace=indent,eol,start    " バックスペース挙動のおまじない
set clipboard=unnamed,unnamedplus " コピーした文字列がclipboardに入る(逆も）
set ignorecase                    " 検索時大文字小文字無視
set smartcase                     " 大文字で始まる場合は無視しない
set foldmethod=marker             " syntaxに応じて折りたたまれる
set nofoldenable
set tabstop=4                     " タブキーの挙動設定。タブをスペース4つ分とする
set shiftwidth=4                  " インデントでスペース４つ分下げる
set softtabstop=4                 " バックスペース等でスペースを消す幅
set expandtab                     " タブをスペースに変換
set autoindent
set list                          " 不可視文字を可視化
" タブ,行末スペース、改行等の可視化,また,その可視化時のマーク
set listchars=tab:>\ ,trail:-,eol:$,extends:>,precedes:<
set wildmenu                      " コマンドの補完設定
set wildmode=longest:full,full    " コマンドの補完スタイル
set laststatus=2                  " 下のステータスバーの表示
set display=lastline              " 一行が長い場合でも@にせずちゃんと表示
set showcmd                       " 入力中のコマンドを右下に表示
set cmdheight=1                   " コマンドラインの高さ
set showtabline=2                 " タブバーを常に表示
set number                        " 行番号表示
set norelativenumber
set hlsearch                      " 文字列検索時にハイライトする
set incsearch                     " 文字入力中に検索を開始
set ruler                         " 右下の現在行の表示
set hidden
set noequalalways                 " splitしたときにウィンドウが同じ大きさになるよう調節する
set tags+=./tags;,./tags-ja;      " タグファイルを上層に向かって探す
set autoread                      " 他のソフトで、編集中ファイルが変更されたとき自動Reload
set noautochdir                   " 今開いてるファイルにカレントディレクトリを移動するか
set scrolloff=5                   " カーソルが端まで行く前にスクロールし始める行数
set ambiwidth=double              " 全角記号（「→」など）の文字幅を半角２つ分にする
set mouse=a                       " マウスを有効化
set mousehide                     " 入力中にポインタを消すかどうか
set mousemodel=popup
set lazyredraw                    " スクロールが間に合わない時などに描画を省略する
set sessionoptions&               " セッションファイルに保存する内容
set sessionoptions-=options
set sessionoptions-=folds
set sessionoptions-=blank
set sessionoptions+=slash
" set sessionoptions+=winpos
" set sessionoptions+=resize
" set splitbelow
" set splitright
set updatetime=1000
set timeoutlen=1000
set ttimeoutlen=100
set fileencodings=utf-8,sjis,iso-2022-jp,cp932,euc-jp " 文字コード自動判別優先順位の設定
set fileformats=unix,dos,mac       " 改行コード自動判別優先順位の設定
set complete=.,w,b,u,k,s,t,i,d,t
set completeopt=menuone            " 補完関係の設定
set omnifunc=syntaxcomplete#Complete
set iminsert=0                     " IMEの管理
set imsearch=0
set pumheight=10

if v:version >= 800 || has('nvim') " バージョン検出
  set breakindent                  " version8以降搭載の便利オプション
  set display=truncate
  set emoji                        " 絵文字を全角表示
  set completeopt+=noselect
endif

" Statusline settings {{{
highlight link User1 Normal
highlight link User2 Title
highlight link User3 Directory
highlight link User4 Special
highlight link User5 Comment

set statusline=%m%r%h%w%q
set statusline+=%<\ %f\ %=
set statusline+=%{myvimrc#statusline_tagbar()}
set statusline+=\ %2*
set statusline+=%{myvimrc#statusline_fugitive()}
set statusline+=%4*
set statusline+=%{myvimrc#statusline_gitgutter()}
set statusline+=%3*
set statusline+=\ %y
set statusline+=%1*\ %{has('multi_byte')&&\&fileencoding!=''?&fileencoding:&encoding}
set statusline+=\(%{&fileformat})
set statusline+=\ %5*%3p%%\ %4l:%-3c\ %*

" }}}

if executable('files')
  let g:myvimrc_files_isAvalable = g:true
else
  let g:myvimrc_files_isAvalable = g:false
endif

if executable('rg')
  let g:myvimrc_rg_isAvalable = g:true
else
  let g:myvimrc_rg_isAvalable = g:false
endif

if executable('pt')
  let g:myvimrc_pt_isAvalable = g:true
else
  let g:myvimrc_pt_isAvalable = g:false
endif

if executable('ag')
  let g:myvimrc_ag_isAvalable = g:true
else
  let g:myvimrc_ag_isAvalable = g:false
endif

" agがあればgrepの代わりにagを使う
if g:myvimrc_rg_isAvalable
  set grepprg=rg\ --vimgrep\ --follow
elseif g:myvimrc_pt_isAvalable
  set grepprg=pt\ --nogroup\ --nocolor\ --column\ --follow
elseif g:myvimrc_ag_isAvalable
  set grepprg=ag\ --nogroup\ --nocolor\ --column\ --follow
elseif has('unix')
  set grepprg=grep\ -rinIH\ --exclude-dir='.*'\ $*
endif

" set undofileでアンドゥデータをファイルを閉じても残しておく
" 該当フォルダがなければ作成
if !isdirectory($HOME . '/.vim/undofiles')
  call mkdir($HOME . '/.vim/undofiles','p')
endif

set undodir=$HOME/.vim/undofiles
set undofile

" set backupでスワップファイルを保存する
" 該当フォルダがなければ作成
if !isdirectory($HOME . '/.vim/backupfiles')
  call mkdir($HOME . '/.vim/backupfiles','p')
endif

set backupdir=$HOME/.vim/backupfiles
set backup
" }}}

" Mapping {{{
" 折り返しがあっても真下に移動できるようになる
" nnoremap j gj
" nnoremap k gk
" nnoremap <Down> gj
" nnoremap <Up> gk

" vnoremap j gj
" vnoremap k gk
" vnoremap <Down> gj
" vnoremap <Up> gk

" noremap <C-j> <ESC>
" noremap! <C-j> <ESC>
noremap! <C-g><C-g> <ESC>
nnoremap <C-Tab> gt
nnoremap <C-S-TAB> gT

vnoremap <c-a> <c-a>gv
vnoremap <c-x> <c-x>gv

" !マークは挿入モードとコマンドラインモードへのマッピング
" emacs like in insert/command mode
noremap! <C-f> <Right>
noremap! <C-b> <Left>
noremap! <M-b> <C-left>
noremap! <M-f> <C-right>
noremap! <M-BS> <C-w>
noremap! <C-a> <Home>
noremap! <C-e> <End>
noremap! <C-k> <End><C-u>

cnoremap <C-@> <C-a>
cnoremap <C-p> <up>
cnoremap <C-n> <down>

" エスケープ２回でハイライトキャンセル
nnoremap <silent> <ESC><ESC> :noh<CR>
nnoremap <C-g> 2<C-g>
" ビジュアルモードでも*検索が使えるようにする
vnoremap * "zy:let @/ = '\<'.@z.'\>' <CR>n
vnoremap g* "zy:let @/ = @z <CR>n
nnoremap <Leader>. <ESC>:<C-u>edit $MYVIMHOME/vimrc.vim<CR>
nnoremap <C-]> g<C-]>


" }}}

" Commands {{{
" Sudoで強制保存
if has('unix')
  command! Wsudo execute("w !sudo tee % > /dev/null")
endif

" :CdCurrent で現在のファイルのディレクトリに移動できる(Kaoriyaに入ってて便利なので実装)
command! CdCurrent cd\ %:h
command! CopyPath call myvimrc#copypath()
command! CopyFileName call myvimrc#copyfname()
command! CopyDirPath call myvimrc#copydirpath()
command! Ctags call myvimrc#ctags_project()
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
command! -nargs=1 Weblio OpenBrowser http://ejje.weblio.jp/content/<args>
command! Transparent set notermguicolors | hi Normal ctermbg=none | hi SpecialKey ctermbg=none | hi NonText ctermbg=none | hi LineNr ctermbg=none | hi EndOfBuffer ctermbg=none
" }}}

" Autocmds {{{
augroup VIMRC
  " タグを</で自動で閉じる。completeoptに依存している
  autocmd Filetype xml,html,eruby inoremap <buffer> </ </<C-x><C-o><C-n><Esc>F<i

  " タグ系のファイルならインデントを浅くする
  autocmd Filetype html,xml setl expandtab softtabstop=2 shiftwidth=2
  autocmd Filetype html,xml setl foldmethod=indent
  autocmd Filetype css setl foldmethod=syntax

  " python関係の設定
  let g:python_highlight_all = 1
  " autocmd FileType python setl autoindent nosmartindent
  autocmd FileType python setl foldmethod=indent
  " autocmd FileType python setl cinwords=if,elif,else,for,while,try,except,finally,def,class
  autocmd FileType python inoremap <buffer> # X#
  autocmd FileType python nnoremap <buffer> >> i<C-t><ESC>^

  " cpp関係の設定
  autocmd FileType c,cpp setl foldmethod=syntax
  autocmd FileType c,cpp setl expandtab softtabstop=2 shiftwidth=2
  " パス名置換によるヘッダファイル、ソースファイル切り替えハック
  " autocmd FileType cpp nnoremap <buffer> <F4> :e %:p:s/.h$/.X123X/:s/.cpp$/.h/:s/.X123X$/.cpp/<CR>

  autocmd FileType cs setl noexpandtab

  autocmd FileType vim setl expandtab softtabstop=2 shiftwidth=2
  autocmd BufEnter *.vim execute 'setl iskeyword+=:'

  let g:vimsyn_folding = 'aflmpPrt'
  autocmd BufRead *.vim setl foldmethod=syntax

  " QuickFixを自動で開く
  autocmd QuickFixCmdPost * cwindow
  autocmd FileType qf nnoremap <silent><buffer> q :quit<CR>
  " pでプレビューができるようにする
  autocmd FileType qf noremap <silent><buffer> p  <CR>zz<C-w>p

  " ヘルプをqで閉じれるようにする
  autocmd FileType help nnoremap <silent><buffer>q :quit<CR>
  autocmd FileType help let &l:iskeyword = '!-~,^*,^|,^",' . &iskeyword
  autocmd FileType mail call s:add_signature()
  fun! s:add_signature()
    let l:file = $HOME . '/localrcs/vim-local-signature.vim'
    if filereadable(l:file)
      let l:signature = []
      for line in readfile(l:file)
        call add(l:signature,line)
      endfor
      if !exists('b:mailsignature')
        let b:mailsignature = 1
        silent call append(0,l:signature)
        normal! gg
      endif
    else
      echomsg 'There is no signature file'
    endif
  endf

  " misc
  if has('unix')
    " linux用（fcitxでしか使えない）
    autocmd InsertLeave * call myvimrc#ImInActivate()
  endif
  autocmd VimEnter * call myvimrc#git_auto_updating()

  " クリップボードが無名レジスタと違ったら
  " (他のソフトでコピーしてきたということなので)
  " 他のレジスタに保存しておく
  autocmd FocusGained,CursorHold,CursorHoldI
        \ * if @* != @" | let @0 = @* | endif

  " diff時に必ずwrapする
  autocmd FilterWritePre * if &diff | setlocal wrap< | endif
augroup END
"}}}

" Build in plugins {{{
set runtimepath+=$VIMRUNTIME/pack/dist/opt/editexisting
set runtimepath+=$VIMRUNTIME/pack/dist/opt/matchit
" }}}

" General Netrw settings {{{
" let g:netrw_winsize = 30 " 起動時用の初期化。起動中には使われない
" let g:netrw_browse_split = 4
let g:netrw_banner = 1
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
let g:netrw_liststyle = 0
let g:netrw_alto = 1
let g:netrw_altv = 1
" カレントディレクトリを変える
let g:netrw_keepdir = 0
highlight! link netrwMarkFile Search

augroup CustomNetrw
  autocmd!
  " for toggle
  " autocmd FileType netrw nnoremap <buffer><Leader>e :call <SID>NiceLexplore(0)<CR>
  " autocmd FileType netrw nnoremap <silent><buffer>q :quit<CR>
  autocmd FileType netrw nmap <silent><buffer>. gh
  autocmd FileType netrw nmap <silent><buffer>h -
  autocmd FileType netrw nmap <silent><buffer>l <CR>
  autocmd FileType netrw nmap <silent><buffer>q <C-o>
  " autocmd FileType netrw unmap <silent><buffer>qf
  " autocmd FileType netrw unmap <silent><buffer>qF
  " autocmd FileType netrw unmap <silent><buffer>qL
  " autocmd FileType netrw unmap <silent><buffer>qb
  " autocmd FileType netrw nnoremap <silent><buffer>qq :quit<CR>
augroup END
" }}}

" Self constructed plugins {{{
let s:myplugins = $MYDOTFILES . '/vim'
exe 'set runtimepath+=' . escape(s:myplugins, ' \')
let s:my_testplugin = $HOME . '/localrcs/testplugin'
exe 'set runtimepath+=' . escape(s:my_testplugin, ' \')
set runtimepath+=$HOME/.fzf/
nnoremap <silent><expr><Leader><C-f><C-f> myvimrc#command_at_destdir(myvimrc#find_project_dir(['.git','tags']),['FZF'])
nnoremap <silent> <Leader><C-f>c :FZF .<CR>
"}}}

source $MYDOTFILES/vim/scripts/plugin_mgr/dein.vim
" source $MYDOTFILES/vim/scripts/plugin_mgr/vim-plug.vim

let g:plugin_mgr.enabled = g:use_plugins

" Install plugin manager if it's not available
call g:plugin_mgr.deploy()

" ============================== "
" Plugin Settings START          "
" ============================== "
if g:plugin_mgr.enabled == g:true
  " Load local settings"{{{
  if filereadable($HOME . '/localrcs/vim-local.vim')
    source $HOME/localrcs/vim-local.vim
  endif
  "}}}

  " Plugin pre settings {{{
  let g:vimproc#download_windows_dll = 1
  " }}}

  " initialize plugin manager
  call g:plugin_mgr.init()

  " load settings of plugins
  source $MYVIMHOME/scripts/custom.vim
  source $MYVIMHOME/scripts/lazy_hooks.vim

  if filereadable($HOME . '/localrcs/vim-localafter.vim')
    source $HOME/localrcs/vim-localafter.vim'
  endif

  set runtimepath+=$MYDOTFILES/vim/after/
  " }}}

  " Color settings {{{

  " ターミナルでの色設定
  if has('win32') && !has('gui_running') && (!has('nvim'))
    colorscheme elflord
  else
    try
      " set background=light
      " let g:airline_theme="molokai"
      " colorscheme molokai
      " colorscheme summerfruit256

      set background=dark
      " colorscheme default
      colorscheme iceberg
      let g:airline_theme = 'iceberg'

      highlight Terminal guibg=black
      "----------JELLYBEANS----------
      " colorscheme jellybeans
      "----------JELLYBEANS----------

      "----------ONEDARK----------
      " colorscheme onedark
      " let g:airline_theme='onedark'
      " highlight! Folded     guibg=#282C34 guifg=#abb2bf
      " highlight! FoldColumn guibg=#0e1013
      " highlight! Normal     guifg=#ABB2BF guibg=#0E1013
      " highlight! Vertsplit  guifg=#282C34 guibg=#282C34
      " highlight! link htmlH1 Function
      "----------ONEDARK----------
      " for YCM's warning area
      " highlight! SpellCap cterm=underline gui=underline
      " highlight! Terminal ctermbg=black guibg=black

      " highlight! IncSearch term=none cterm=none gui=none ctermbg=114 guibg=#98C379
      "
      " highlight! Folded     ctermbg=235   ctermfg=none guibg=#282C34 guifg=#abb2bf
      " highlight! FoldColumn ctermbg=233   guibg=#0e1013
      " highlight! Normal ctermbg=233 guifg=#ABB2BF guibg=#0E1013
      " highlight! Vertsplit  term=reverse  ctermfg=235  ctermbg=235   guifg=#282C34 guibg=#282C34

      " highlight! MatchParen gui=none cterm=none term=none

      " transparent
      " highlight! Folded cterm=underline ctermbg=none
      " highlight! FoldColumn ctermbg=none
      " highlight! Normal ctermbg=none
      " highlight! Vertsplit term=reverse ctermfg=145 ctermbg=none guifg=#282C34 guibg=#282C34

      " highlight! StatusLine ctermbg=235 guibg=#282C34
      " highlight! StatusLineNC ctermbg=235 guibg=#282C34

      if has('gui_running') && (!has('nvim'))
        let g:indent_guides_auto_colors = 1
      else
        let g:indent_guides_auto_colors = 0
        " solarized(light)
        if exists('g:colors_name')
          if g:colors_name ==# 'molokai'
            autocmd VIMRC VimEnter,Colorscheme * :hi IndentGuidesOdd guifg=#303233 guibg=#262829
            autocmd VIMRC VimEnter,Colorscheme * :hi IndentGuidesEven guifg=#262829 guibg=#303233
          elseif g:colors_name ==# 'onedark'
            autocmd VIMRC VimEnter,Colorscheme * :hi IndentGuidesOdd ctermfg=59 ctermbg=234 guifg=#252629 guibg=#1A1B1E
            autocmd VIMRC VimEnter,Colorscheme * :hi IndentGuidesEven ctermfg=59 ctermbg=235 guifg=#1A1B1E guibg=#252629
          elseif g:colors_name ==# 'solarized'
            autocmd VIMRC VimEnter,Colorscheme * :hi IndentGuidesEven guifg=#0C3540 guibg=#183F49
            autocmd VIMRC VimEnter,Colorscheme * :hi IndentGuidesOdd guifg=#183F49 guibg=#0C3540
            autocmd VIMRC VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=230
            autocmd VIMRC VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=223
          elseif g:colors_name ==# 'iceberg'
            autocmd VIMRC VimEnter,Colorscheme * :hi IndentGuidesEven guifg=#21232C guibg=#2C2E36
            autocmd VIMRC VimEnter,Colorscheme * :hi IndentGuidesOdd guifg=#2C2E36 guibg=#21232C
          elseif g:colors_name ==# 'spacegray'
            autocmd VIMRC VimEnter,Colorscheme * :hi IndentGuidesEven guifg=#1C1E1F guibg=#27292A
            autocmd VIMRC VimEnter,Colorscheme * :hi IndentGuidesOdd guifg=#27292A guibg=#1C1E1F


            " summerfruit
            " autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=255
            " autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=254
            " one(light)
            " autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=254 guifg=#E1E1E1 guibg=#EDEDED
            " autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=253 guifg=#EDEDED guibg=#E1E1E1
            " onedark
            " autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermfg=59 ctermbg=234 guifg=#252629 guibg=#1A1B1E
            " autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermfg=59 ctermbg=235 guifg=#1A1B1E guibg=#252629
            " transparent
            " autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=none guifg=#252629 guibg=#1A1B1E
            " autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=none guifg=#1A1B1E guibg=#252629
          endif
        endif
      endif
    catch
      colorscheme default
      set background=light
    endtry
  endif

  " }}}

  " Netrw Mapping {{{
  " バッファファイルのディレクトリで開く
  nnoremap <Leader>n :call myvimrc#NiceLexplore(1)<CR>
  " カレントディレクトリで開く
  nnoremap <Leader>N :call myvimrc#NiceLexplore(0)<CR>
  " }}}
else
  filetype plugin indent on
  syntax enable
  " Without plugins settings {{{
  colorscheme default
  set background=light

  " Netrw settings {{{
  " バッファファイルのディレクトリで開く
  nnoremap <Leader>e :call myvimrc#NiceLexplore(1)<CR>
  " カレントディレクトリで開く
  nnoremap <Leader>E :call myvimrc#NiceLexplore(0)<CR>
  " }}}

  " }}}
endif
if getcwd() ==# $VIM
  cd $HOME
endif
