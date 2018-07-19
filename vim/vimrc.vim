" vim:set foldmethod=marker:
" INITIALIZE {{{
set encoding=utf-8
language C

scriptencoding utf-8

let g:true = 1
let g:false = 0

if !exists('$MYDOTFILES')
  let $MYDOTFILES = $HOME . '/dotfiles'
endif

let $MYVIMHOME=$MYDOTFILES . '/vim'

if !exists('g:use_plugins')
  let g:use_plugins = g:true
endif
" }}}

" OPTIONS {{{
let g:mapleader = "\<space>"

augroup VIMRC
  " Initialize augroup
  autocmd! 
augroup END

if has('win32')                                          " Windows
  set t_Co=16                                            " 16 colors on cmd.exe

elseif has('unix')                                       " UNIX
  if v:version >= 800
    set termguicolors                                    " TrueColor on terminal
    if $TMUX !=# ""
      let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
      let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
    endif
  else
    set t_Co=256                                         " 256 colors on terminal
  endif

  if $TERM !=# 'linux'
    let &t_SI = '[5 q'
    let &t_EI = '[2 q'
  endif

  set ttymouse=xterm2
endif

if v:version >= 800
  set cryptmethod=blowfish2
  set breakindent                                        " version8以降搭載の便利オプション
  set display=truncate
  set emoji                                              " 絵文字を全角表示
endif

" set diffopt=filler,iwhite                              " Diff options
set visualbell t_vb=                                     " Disable beep sounds
set nocursorline                                         " Highlight of cursor line/column
set nocursorcolumn
set backspace=indent,eol,start                           " Make backspace's behavior good
set clipboard=unnamed,unnamedplus                        " Enable clipboard
set ignorecase                                           " Ignore case when search
set smartcase                                            " When search word starts with uppercase, it doesn't ignore case
set foldmethod=marker                                    " Set methods for folding
set nofoldenable                                         " Set fold disable as default
set tabstop=4                                            " Make width of TAB character as rhs
set shiftwidth=4                                         " Set number of spaces used by indenting (eg. >> or <<)
set softtabstop=4                                        " Set number of spaces deleted by backspace
set expandtab                                            " Expand tabs to spaces
set autoindent                                           " Enable auto indenting
set list                                                 " Show invisible characters
set listchars=tab:>\ ,trail:-,eol:$,extends:>,precedes:< " How invisible characters will be shown
set wildmenu                                             " Enable completion for commands
set wildmode=longest:full,full                           " Behavior config for wildmenu
set laststatus=2                                         " Enable status line
set display=lastline                                     " 一行が長い場合でも@にせずちゃんと表示
set showcmd                                              " 入力中のコマンドを右下に表示
set cmdheight=2                                          " コマンドラインの高さ
set showtabline=2                                        " タブバーを常に表示
set sidescroll=1                                         " 横スクロール刻み幅
set number                                               " 行番号表示
set norelativenumber
set hlsearch                                             " 文字列検索時にハイライトする
set incsearch                                            " 文字入力中に検索を開始
set ruler                                                " Show line number of right bottom
set hidden                                               " You can hide buffer to background without saving
set noequalalways                                        " splitしたときにウィンドウが同じ大きさになるよう調節する
set tags+=./tags;,./tags-ja;                             " タグファイルを上層に向かって探す
set autoread                                             " 他のソフトで、編集中ファイルが変更されたとき自動Reload
set noautochdir                                          " 今開いてるファイルにカレントディレクトリを移動するか
set ambiwidth=double                                     " 全角記号（「→」など）の文字幅を半角２つ分にする
set mouse=a                                              " マウスを有効化
set mousehide                                            " 入力中にポインタを消すかどうか
set mousemodel=popup                                     " Behavior of right-click
set lazyredraw                                           " スクロールが間に合わない時などに描画を省略する
set updatetime=1000                                      " Wait time until swap file will be written
set timeout
set ttimeout
set timeoutlen=1000                                      " マッピングの時間切れまでの時間
set ttimeoutlen=100                                      " キーコードの時間切れまでの時間
set fileencodings=utf-8,sjis,iso-2022-jp,cp932,euc-jp    " 文字コード自動判別優先順位の設定
set fileformats=unix,dos,mac                             " 改行コード自動判別優先順位の設定
set complete=.,w,b,u,U,k,kspell,s,t,t
set completeopt=menuone,noselect                         " 補完関係の設定,Ycmで自動設定される
set pumheight=10                                         " 補完ウィンドウ最大高さ
set omnifunc=syntaxcomplete#Complete
set iminsert=0                                           " IMEの管理
set imsearch=0

set sessionoptions&                                      " セッションファイルに保存する内容
set sessionoptions-=options
set sessionoptions-=buffers
set sessionoptions-=folds
set sessionoptions-=blank
set sessionoptions+=slash

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
  let g:mymisc_files_is_available = g:true
else
  let g:mymisc_files_is_available = g:false
endif

if executable('rg')
  let g:mymisc_rg_is_available = g:true
else
  let g:mymisc_rg_is_available = g:false
endif

if executable('pt')
  let g:mymisc_pt_is_available = g:true
else
  let g:mymisc_pt_is_available = g:false
endif

if executable('ag')
  let g:mymisc_ag_is_available = g:true
else
  let g:mymisc_ag_is_available = g:false
endif

if executable('fcitx-remote')
  let g:mymisc_fcitx_is_available = g:true
else
  let g:mymisc_fcitx_is_available = g:false
endif

" agがあればgrepの代わりにagを使う
if g:mymisc_rg_is_available
  set grepprg=rg\ --vimgrep\ --follow
elseif g:mymisc_pt_is_available
  set grepprg=pt\ --nogroup\ --nocolor\ --column\ --follow
elseif g:mymisc_ag_is_available
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

" set backupでバックアップファイルを保存する
" 該当フォルダがなければ作成
if !isdirectory($HOME . '/.vim/backupfiles')
  call mkdir($HOME . '/.vim/backupfiles','p')
endif

set backupdir=$HOME/.vim/backupfiles
set backup
" }}} OPTIONS END 

" MAPPING {{{
" Move cursor in display lines method
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
vnoremap j gj
vnoremap k gk
vnoremap gj j
vnoremap gk k

nnoremap <C-Tab> gt
nnoremap <C-S-TAB> gT

" Clear highlighting on escape in normal mode
nnoremap <ESC> :noh<CR><ESC>
nnoremap <ESC>^[ <ESC>^[

nnoremap Y v$hy

nnoremap <C-g> 2<C-g>
nnoremap <C-]> g<C-]>

vnoremap <c-a> <c-a>gv
vnoremap <c-x> <c-x>gv

nnoremap * *N
nnoremap g* g*N
" ビジュアルモードでも*検索が使えるようにする
vnoremap * "zy:let @/ = '\<'.@z.'\>' <CR>nN
vnoremap g* "zy:let @/ = @z <CR>nN

" !マークはInsert ModeとCommand-line Modeへのマッピング
" emacs like keymap in insert/command mode
noremap! <C-f> <Right>
noremap! <C-b> <Left>
noremap! <C-a> <Home>
noremap! <C-e> <End>
noremap! <C-g><C-g> <ESC>
inoremap <C-k> <ESC>ld$a

cnoremap <C-o> <C-a>
cnoremap <C-p> <up>
cnoremap <C-n> <down>
" }}} MAPPING END

" COMMANDS {{{
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

" Forked from https://qiita.com/shiena/items/1dcb20e99f43c9383783
command! MSYSTerm call s:MSYSTerm()
function! s:MSYSTerm()
  if !exists('g:myvimrc_msys_dir')
    let g:myvimrc_msys_dir = 'C:/msys64'
  endif

  let l:msys_locale_path = g:myvimrc_msys_dir . '/usr/bin/locale.exe'
  let l:msys_bash_path = g:myvimrc_msys_dir . '/usr/bin/bash.exe'
  " 日本語Windowsの場合`ja`が設定されるので、入力ロケールに合わせたUTF-8に設定しなおす
  let l:env = {
        \ 'LANG': systemlist('"' . l:msys_locale_path . '" -iU')[0],
        \ }

  " remote連携のための設定
  if has('clientserver')
    call extend(l:env, {
          \ 'GVIM': $VIMRUNTIME,
          \ 'VIM_SERVERNAME': v:servername,
          \ })
  endif

  " term_startでgit for windowsのbashを実行する
  call term_start([l:msys_bash_path, '-l'], {
        \ 'term_name': 'MSYS',
        \ 'term_finish': 'close',
        \ 'curwin': v:false,
        \ 'cwd': $USERPROFILE,
        \ 'env': l:env,
        \ })
endfunction
" }}} COMMANDS END

" AUTOCMDS {{{
augroup VIMRC
  " Markdown
  let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'cpp', 'c']

  " HTML,XML,CSS,JavaScript
  autocmd Filetype html,xml setl expandtab softtabstop=2 shiftwidth=2 foldmethod=indent
  autocmd Filetype css setl foldmethod=syntax
  autocmd FileType javascript,jade,pug setl foldmethod=syntax expandtab softtabstop=2 shiftwidth=2

  " Markdown
  autocmd FileType markdown setl expandtab softtabstop=2 shiftwidth=2

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

  " Vim
  let g:vimsyn_folding = 'aflmpPrt'
  autocmd FileType vim setl expandtab softtabstop=2 shiftwidth=2
  autocmd BufEnter *.vim execute 'setl iskeyword+=:'
  autocmd BufRead *.vim setl foldmethod=syntax

  " QuickFix
  " Auto open
  autocmd QuickFixCmdPost * cwindow
  autocmd FileType qf nnoremap <silent><buffer> q :quit<CR>
  " Preview with p
  autocmd FileType qf noremap <silent><buffer> p  <CR>zz<C-w>p

  " Help
  autocmd FileType help nnoremap <silent><buffer>q :quit<CR>
  autocmd FileType help let &l:iskeyword = '!-~,^*,^|,^",' . &iskeyword

  autocmd InsertLeave * call mymisc#ime_deactivate()
  autocmd VimEnter * call mymisc#git_auto_updating()

  " クリップボードが無名レジスタと違ったら
  " (他のソフトでコピーしてきたということなので)
  " 他のレジスタに保存しておく
  autocmd FocusGained,CursorHold,CursorHoldI * if @* !=# "" && @* !=# @" | let @0 = @* | endif
  autocmd FocusGained,CursorHold,CursorHoldI * if @+ !=# "" && @+ !=# @" | let @0 = @+ | endif

  " set wrap to global one in in diff mode
  autocmd FilterWritePre * if &diff | setlocal wrap< | endif
augroup END
"}}} AUTOCMDS END

" BUILT-IN PLUGINS {{{
set runtimepath+=$VIMRUNTIME/pack/dist/opt/editexisting
set runtimepath+=$VIMRUNTIME/pack/dist/opt/matchit
" }}} BUILT-IN PLUGINS END

" DOT DIRECTORY PLUGINS {{{
let s:myplugins = $MYDOTFILES . '/vim'
exe 'set runtimepath+=' . escape(s:myplugins, ' \')
"}}} DOT DIRECTORY PLUGINS END

" PLUGIN MANAGER SETUP {{{

" source $MYDOTFILES/vim/scripts/plugin_mgr/dein.vim
source $MYDOTFILES/vim/scripts/plugin_mgr/vim-plug.vim

let g:plugin_mgr.enabled = g:use_plugins

" Install plugin manager if it's not available
call g:plugin_mgr.deploy()

" }}} PLUGIN MANAGER SETUP END
"
if g:plugin_mgr.enabled == g:true

  " WHEN PLUGINS ARE ENABLED {{{

  " Local settings
  if filereadable($HOME . '/localrcs/vim-local.vim')
    source $HOME/localrcs/vim-local.vim
  endif

  " Manual setup plugins
  set runtimepath+=$HOME/.fzf/
  nnoremap <silent><expr><Leader><C-f><C-f> mymisc#command_at_destdir(mymisc#find_project_dir(['.git','tags']),['FZF'])
  nnoremap <silent> <Leader><C-f>c :FZF .<CR>
  let g:vimproc#download_windows_dll = 1

  " Initialize plugin manager
  call g:plugin_mgr.init()

  " Load settings of plugins
  source $MYVIMHOME/scripts/lazy_hooks.vim
  source $MYVIMHOME/scripts/custom.vim

  " Local after settings
  if filereadable($HOME . '/localrcs/vim-localafter.vim')
    source $HOME/localrcs/vim-localafter.vim
  endif

  " Colorschemes
  if has('win32') && !has('gui_running') " On windows terminal
    colorscheme default
    set background=dark
  else                                   " On any other environment
    try
      set background=dark
      colorscheme one
    catch
      colorscheme default
      set background=light
    endtry
  endif

  highlight! Terminal ctermbg=black guibg=black
  " }}} WHEN PLUGINS ARE ENABLED END

else

  " WHEN PLUGINS ARE DISABLED {{{
  filetype plugin indent on
  syntax enable

  colorscheme default
  set background=light
  " }}} WHEN PLUGINS ARE DISABLED END

endif

if getcwd() ==# $VIM
  cd $HOME
endif
