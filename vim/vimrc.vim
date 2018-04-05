" vim:set foldmethod=marker:
" Initialize {{{
set encoding=utf-8
language C

scriptencoding utf-8

let g:true = 1
let g:false = 0

if filereadable($HOME . '/.vim/not_confirms.vim')
  source $HOME/.vim/not_confirms.vim
endif

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
  " Initialize augroup
  autocmd!
augroup END


" Detect OS
if has('win32')
  set t_Co=16         " 16 colors on cmd.exe

elseif has('unix')
  set t_Co=256        " 256 colors on terminal

  if v:version >= 800 || has('nvim')
    set termguicolors " TrueColor on terminal
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
    let &t_SI = '[5 q'
    let &t_EI = '[2 q'
    if executable('gnome-terminal')


      if has('job') && v:version >= 800
        call job_start('gnome-terminal --version',{'callback':'mymisc#gnometerm_detection'})

      else
        let s:gnome_term_ver = split(split(system('gnome-terminal --version'))[2], '\.')
        augroup VIMRC
          autocmd VimEnter * call mymisc#set_tmux_code(s:gnome_term_ver)
        augroup END
      endif

    endif
  endif
endif

" Disable beep sounds
set visualbell t_vb=

" set diffopt=filler,iwhite                   " Diff options
set cursorline                  " Highlight of cursor line/column
set nocursorcolumn
set backspace=indent,eol,start    " Make backspace's behavior good
set clipboard=unnamed,unnamedplus " Enable clipboard
set ignorecase                    " Ignore case when search
set smartcase                     " When search word starts with uppercase, it doesn't ignore case
set foldmethod=marker             " Set methods for folding
set nofoldenable                  " Set fold disable as default
set tabstop=4                     " Make width of TAB character as rhs
set shiftwidth=4                  " Set number of spaces used by indenting (eg. >> or <<)
set softtabstop=4                 " Set number of spaces deleted by backspace
set expandtab                     " Expand tabs to spaces
set autoindent                    " Enable auto indenting
set list                          " Show invisible characters
" How invisible characters will be shown
set listchars=tab:>\ ,trail:-,eol:$,extends:>,precedes:<
set wildmenu                      " Enable completion for commands
set wildmode=longest:full,full    " Behavior config for wildmenu
set laststatus=2                  " Enable status line
set display=lastline              " 一行が長い場合でも@にせずちゃんと表示
set showcmd                       " 入力中のコマンドを右下に表示
set cmdheight=2                   " コマンドラインの高さ
set showtabline=2                 " タブバーを常に表示
set number                        " 行番号表示
set relativenumber
set hlsearch                      " 文字列検索時にハイライトする
set incsearch                     " 文字入力中に検索を開始
set ruler                         " Show line number of right bottom
set hidden                        " You can hide buffer to background without saving
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
set sessionoptions-=buffers
set sessionoptions-=folds
set sessionoptions-=blank
set sessionoptions+=slash
" set sessionoptions+=winpos
" set sessionoptions+=resize
" set splitbelow
" set splitright
set updatetime=1000
set timeout
set ttimeout
set timeoutlen=1000
set ttimeoutlen=100
set fileencodings=utf-8,sjis,iso-2022-jp,cp932,euc-jp " 文字コード自動判別優先順位の設定
set fileformats=unix,dos,mac                          " 改行コード自動判別優先順位の設定
set complete=.,w,b,u,U,k,kspell,s,t,t
set completeopt=menuone,noselect                              " 補完関係の設定,Ycmで自動設定される
set omnifunc=syntaxcomplete#Complete
set iminsert=0                                        " IMEの管理
set imsearch=0

if v:version >= 800 || has('nvim')                    " バージョン検出
  set breakindent                                     " version8以降搭載の便利オプション
  set display=truncate
  set emoji                                           " 絵文字を全角表示
endif

" Statusline settings {{{
highlight link User1 Normal
highlight link User2 Title
highlight link User3 Directory
highlight link User4 Special
highlight link User5 Comment

set statusline=%m%r%h%w%q
set statusline+=%<\ %f\ %=
set statusline+=%{mymisc#statusline_tagbar()}
set statusline+=\ %2*
set statusline+=%{mymisc#statusline_fugitive()}
set statusline+=%4*
set statusline+=%{mymisc#statusline_gitgutter()}
set statusline+=%3*
set statusline+=\ %y
set statusline+=%1*\ %{has('multi_byte')&&\&fileencoding!=''?&fileencoding:&encoding}
set statusline+=\(%{&fileformat})
set statusline+=\ %5*%3p%%\ %4l:%-3v\ %*

" }}}

if executable('files')
  let g:mymisc_files_isAvalable = g:true
else
  let g:mymisc_files_isAvalable = g:false
endif

if executable('rg')
  let g:mymisc_rg_isAvalable = g:true
else
  let g:mymisc_rg_isAvalable = g:false
endif

if executable('pt')
  let g:mymisc_pt_isAvalable = g:true
else
  let g:mymisc_pt_isAvalable = g:false
endif

if executable('ag')
  let g:mymisc_ag_isAvalable = g:true
else
  let g:mymisc_ag_isAvalable = g:false
endif

" agがあればgrepの代わりにagを使う
if g:mymisc_rg_isAvalable
  set grepprg=rg\ --vimgrep\ --follow
elseif g:mymisc_pt_isAvalable
  set grepprg=pt\ --nogroup\ --nocolor\ --column\ --follow
elseif g:mymisc_ag_isAvalable
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
" Move cursor in display lines method
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
nnoremap <Down> gj
nnoremap <Up> gk

vnoremap j gj
vnoremap k gk
vnoremap gj j
vnoremap gk k
vnoremap <Down> gj
vnoremap <Up> gk

noremap! <C-g><C-g> <ESC>
nnoremap <C-Tab> gt
nnoremap <C-S-TAB> gT

vnoremap <c-a> <c-a>gv
vnoremap <c-x> <c-x>gv

" !マークは挿入モードとコマンドラインモードへのマッピング
" emacs like in insert/command mode
noremap! <C-f> <Right>
noremap! <C-b> <Left>
noremap! <C-a> <Home>
noremap! <C-e> <End>
" noremap! <C-k> <End><C-u>

cnoremap <C-@> <C-a>
cnoremap <C-p> <up>
cnoremap <C-n> <down>

" エスケープ２回でハイライトキャンセル
nnoremap <silent> <ESC><ESC> :noh<CR>
nnoremap <C-g> 2<C-g>
" ビジュアルモードでも*検索が使えるようにする
vnoremap * "zy:let @/ = '\<'.@z.'\>' <CR>n
vnoremap g* "zy:let @/ = @z <CR>n
nnoremap <C-]> g<C-]>


" }}}

" Commands {{{
" Sudoで強制保存
if has('unix')
  command! Wsudo execute("w !sudo tee % > /dev/null")
endif

" :CdCurrent で現在のファイルのディレクトリに移動できる(Kaoriyaに入ってて便利なので実装)
command! CdCurrent cd\ %:h
command! CopyPath call mymisc#copypath()
command! CopyFileName call mymisc#copyfname()
command! CopyDirPath call mymisc#copydirpath()
command! Ctags call mymisc#ctags_project()
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
command! -nargs=1 Weblio OpenBrowser http://ejje.weblio.jp/content/<args>
command! Transparent set notermguicolors | hi Normal ctermbg=none | hi SpecialKey ctermbg=none | hi NonText ctermbg=none | hi LineNr ctermbg=none | hi EndOfBuffer ctermbg=none
command! FollowSymlink call s:SwitchToActualFile()
function! s:SwitchToActualFile()
    let l:fname = resolve(expand('%:p'))
    let l:pos = getpos('.')
    let l:bufname = bufname('%')
    enew
    exec 'bw '. l:bufname
    exec "e " . fname
    call setpos('.', pos)
endfunction
command! Term terminal ++curwin
" }}}

" Autocmds {{{
augroup VIMRC
  " Markdown
  let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'cpp', 'c']

  " HTML,XML,CSS,JavaScript
  " タグを</で自動で閉じる。completeoptに依存している
  autocmd Filetype xml,html,eruby inoremap <buffer> </ </<C-x><C-o><C-n><Esc>F<i
  autocmd Filetype html,xml setl expandtab softtabstop=2 shiftwidth=2 foldmethod=indent
  autocmd Filetype css setl foldmethod=syntax
  autocmd FileType javascript,jade,pug setl foldmethod=syntax expandtab softtabstop=2 shiftwidth=2

  " Json
  let g:vim_json_syntax_conceal = 0

  " Python
  let g:python_highlight_all = 1
  autocmd FileType python setl foldmethod=indent
  " autocmd FileType python setl autoindent nosmartindent
  " autocmd FileType python setl cinwords=if,elif,else,for,while,try,except,finally,def,class
  autocmd FileType python inoremap <buffer> # X#
  autocmd FileType python nnoremap <buffer> >> i<C-t><ESC>^

  " C++
  autocmd FileType c,cpp setl foldmethod=syntax expandtab softtabstop=2 shiftwidth=2

  " C#
  autocmd FileType cs setl noexpandtab

  " vim
  let g:vimsyn_folding = 'aflmpPrt'
  autocmd FileType vim setl expandtab softtabstop=2 shiftwidth=2
  autocmd BufEnter *.vim execute 'setl iskeyword+=:'
  autocmd BufRead *.vim setl foldmethod=syntax

  " QuickFixを自動で開く
  autocmd QuickFixCmdPost * cwindow
  autocmd FileType qf nnoremap <silent><buffer> q :quit<CR>
  " pでプレビューができるようにする
  autocmd FileType qf noremap <silent><buffer> p  <CR>zz<C-w>p

  " ヘルプをqで閉じれるようにする
  autocmd FileType help nnoremap <silent><buffer>q :quit<CR>
  autocmd FileType help let &l:iskeyword = '!-~,^*,^|,^",' . &iskeyword

  " misc
  if has('unix')
    " linux用（fcitxでしか使えない）
    autocmd InsertLeave * call mymisc#ImInActivate()
  endif
  autocmd VimEnter * call mymisc#git_auto_updating()

  " クリップボードが無名レジスタと違ったら
  " (他のソフトでコピーしてきたということなので)
  " 他のレジスタに保存しておく
  autocmd FocusGained,CursorHold,CursorHoldI
        \ * if @* != @" | let @0 = @* | endif
  autocmd FocusGained,CursorHold,CursorHoldI
        \ * if @+ != @" | let @0 = @+ | endif

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
let s:my_testplugin = $HOME . '/localrcs/testplugin/vimailer.vim'
exe 'set runtimepath+=' . escape(s:my_testplugin, ' \')
set runtimepath+=$HOME/.fzf/
nnoremap <silent><expr><Leader><C-f><C-f> mymisc#command_at_destdir(mymisc#find_project_dir(['.git','tags']),['FZF'])
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
  source $MYVIMHOME/scripts/lazy_hooks.vim
  source $MYVIMHOME/scripts/custom.vim

  if filereadable($HOME . '/localrcs/vim-localafter.vim')
    source $HOME/localrcs/vim-localafter.vim
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

      " colorscheme default
      colorscheme molokai
      " let g:airline_theme = 'iceberg'

      highlight Terminal guibg=black
      " let g:vmail_flagged_color = 'term=bold ctermfg=109 guifg=#89b8c2'
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

    catch
      colorscheme default
      set background=light
    endtry
  endif

  " }}}

  " Netrw Mapping {{{
  " バッファファイルのディレクトリで開く
  nnoremap <Leader>n :call mymisc#NiceLexplore(1)<CR>
  " カレントディレクトリで開く
  nnoremap <Leader>N :call mymisc#NiceLexplore(0)<CR>
  " }}}
else
  filetype plugin indent on
  syntax enable
  " Without plugins settings {{{
  colorscheme default
  set background=light

  " Netrw settings {{{
  " バッファファイルのディレクトリで開く
  nnoremap <Leader>e :call mymisc#NiceLexplore(1)<CR>
  " カレントディレクトリで開く
  nnoremap <Leader>E :call mymisc#NiceLexplore(0)<CR>
  " }}}

  " }}}
endif
if getcwd() ==# $VIM
  cd $HOME
endif
