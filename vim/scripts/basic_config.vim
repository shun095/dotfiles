" vim:set foldmethod=marker:

  " INITIALIZE {{{
  se encoding=utf-8
  se spelllang=en_us

  if !exists('g:use_plugins')
    let g:use_plugins = v:true
  en
  if !exists('g:is_test')
    let g:is_test = v:false
  en

  let $MYVIMHOME = $MYDOTFILES . '/vim'
  if has('win32')
    let $MYVIMRUNTIME = $HOME . '/vimfiles'
  else
    let $MYVIMRUNTIME = $HOME . '/.vim'
    if has('win32unix')
      call mkdir($HOME . '/vimfiles', 'p')
      if getftype(expand('~/.vim')) == ""
        let msg = system('powershell New-Item -ItemType SymbolicLink -Path "~/.vim" -Target "~/vimfiles"')
        if v:shell_error != 0
          throw 'You need to administrator to install.: ' . string(msg)
        endif
      endif
    endif
  endif

  if has('nvim') && !has('win32')
    " neovimはneovimのpyenvを作ってそれを使う想定。
    let g:python3_host_prog = system('(type pyenv &>/dev/null && echo -n "$(pyenv root)/versions/neovim/bin/python") || echo -n $(which python3)')
  endif

  " Force to use python3
  if has("python3")
    let g:myvimrc_has_python3 = v:true
    if has("python2")
      " python2よりもpython3を優先して読み込むhack
      py3 pass
    en
  else
    let g:myvimrc_has_python3 = v:false
  en

  if has("pythonx")
    se pyxversion=3
  en

  " }}}

  " OPTIONS {{{
  let g:mapleader = "\<space>"

  aug VIMRC
    " Initialize augroup
    au!
  aug END

  fun! s:toggle_color_mode() abort
    if get(s:,'color_mode','B') !=# 'A'
      " Pattern A:
      let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
      " gnome-term + raw           : work
      " tmux + raw                 : doesn't work
      " gnome-term + docker + raw  : work
      " gnome-term + docker + tmux : work
      let s:color_mode_a = 'A'
    else
      " Pattern B:
      let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
      let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
      " gnome-term + raw           : work
      " tmux + raw                 : work
      " gnome-term + docker + raw  : work
      " gnome-term + docker + tmux : doesn't work
      let s:color_mode_a = 'B'
    en

    se termguicolors " TrueColor on terminal
  endf

  com! ColorModeToggle cal <SID>toggle_color_mode()

  if !has('gui_running')
    if match($TERM, '256color') > 0
      if $COLORTERM !=# 'truecolor'
        se t_Co=16  " Limited colors on terminal
      else
        if v:version >= 800
          cal s:toggle_color_mode()
        en
        let &t_SI = '[5 q'
        let &t_EI = '[2 q'
        let &t_fe = "\<Esc>[?1004h"
        let &t_fd = "\<Esc>[?1004l"
        execute "set <FocusGained>=\<Esc>[I"
        execute "set <FocusLost>=\<Esc>[O"
      en
    else
      if has('win32')
        se termguicolors
      else
        if $TERM ==# 'linux' || $COLORTERM !=# 'truecolor'
          se t_Co=16  " Limited colors on terminal
        else
          se t_Co=256 " Limited colors on terminal
        en
      en
    en
  en

  " Color term in :terminal
  if $TERM ==# 'screen-256color'
    let $TERM = 'xterm-256color'
  en

  if !has('nvim')
    se ttymouse=xterm2
  en

  if v:version >= 800
    se breakindent                                                            " version8以降搭載の便利オプション
    se display=truncate                                                       " 一行が長い場合でも@にせずちゃんと表示
    se emoji                                                                  " 絵文字を全角表示
    se completeopt=menuone,noselect,noinsert                                  " 補完関係の設定,Ycmで自動設定される
  en

  if has('patch-8.1.1880')
    se completeopt+=popup
  en
  if has('patch-9.1.1009')
    se diffopt+=algorithm:histogram,indent-heuristic                          " Diff options
  en
  if has('nvim')
    se diffopt+=linematch:60
  endif
  if has('patch-8.0.1491')
    se pumwidth=0                                                             " 補完ウィンドウの最小幅
  en
  se pumheight=20                                                             " 補完ウィンドウ最大高さ
  se title

  se visualbell t_vb=                                                         " Disable beep sounds
  se cursorline                                                               " Highlight of cursor line/column
  se nocursorcolumn
  se backspace=indent,eol,start                                               " Make backspace's behavior good
  se clipboard=unnamed,unnamedplus                                            " Enable clipboard
  se ignorecase                                                               " Ignore case when search
  se smartcase                                                                " When search word starts with uppercase, it doesn't ignore case
  se foldmethod=marker                                                        " Set methods for folding
  se nofoldenable                                                             " Set fold disable as default
  se tabstop=4                                                                " Make width of TAB character as rhs
  se shiftwidth=4                                                             " Set number of spaces used by indenting (eg. >>, << or auto-indent)
  se softtabstop=4                                                            " Set number of spaces inserted by <tab> button or deleted by <bs>
  se expandtab                                                                " Expand tabs to spaces
  se autoindent                                                               " Enable auto indenting
  se list                                                                     " Show invisible characters
  se listchars=tab:→\ ,space:･,eol:↵,extends:>,precedes:<                     " How invisible characters will be shown
  se nofixendofline
  se synmaxcol=500
  se wildmenu                                                                 " Enable completion for s
  se wildmode=longest:full,full                                               " Behavior config for wildmenu
  if has('patch-8.2.4325')
    se wildoptions=pum                                                        " cmdline-completionの時にポップアップを表示
  endif
  if has('nvim')
    se laststatus=3
  else
    se laststatus=2                                                             " Enable status line
  endif
  se display=lastline                                                         " 一行が長い場合でも@にせずちゃんと表示
  se showcmd                                                                  " 入力中のコマンドを右下に表示
  se cmdheight=2                                                              " コマンドラインの高さ
  " se messagesopt=wait:1000,history:500
  se showtabline=2                                                            " タブバーを常に表示
  se shortmess-=Tt
  se nostartofline                                                            " オンの場合Gなどのときに行頭に移動する
  se sidescroll=1                                                             " 横スクロール刻み幅
  se sidescrolloff=1                                                          " 横スクロール刻み幅
  if has('patch-9.0.0640')
    se smoothscroll                                                           " スムーススクロール(wrapの時にスキップしない)
  endif
  se number                                                                   " 行番号表示
  se relativenumber
  se signcolumn=yes                                                           " Gutter行を常に表示
  se hlsearch                                                                 " 文字列検索時にハイライトする
  se incsearch                                                                " 文字入力中に検索を開始
  se ruler                                                                    " Show line number of right bottom
  se hidden                                                                   " You can hide buffer to background without saving
  se noequalalways                                                            " splitしたときにウィンドウが同じ大きさになるよう調節する
  se tags+=./tags;,./tags-ja;                                                 " タグファイルを上層に向かって探す
  se autoread                                                                 " 他のソフトで、編集中ファイルが変更されたとき自動Reload
  se noautochdir                                                              " 今開いてるファイルにカレントディレクトリを移動するか
  se ambiwidth=single                                                         " 全角記号（「→」など）の文字幅 :terminalのためにsingleに設定
  se mouse=a                                                                  " マウスを有効化
  se mousehide                                                                " 入力中にポインタを消すかどうか
  se mousemodel=                                                              " Behavior of right-click
  se nolazyredraw                                                               " スクロールが間に合わない時などに描画を省略する
  se updatetime=1000                                                          " Wait time until swap file will be written
  se timeout
  se ttimeout
  se timeoutlen=1000                                                          " マッピングの時間切れまでの時間
  se ttimeoutlen=100                                                          " キーコードの時間切れまでの時間
  se fileencodings=ucs-bom,utf-8,sjis,iso-2022-jp,cp932,euc-jp,default,latin1 " 文字コード自動判別優先順位の設定
  se fileformats=unix,dos,mac                                                 " 改行コード自動判別優先順位の設定
  " se complete=.,w,b,u,U,k,kspell,s,t,t
  se iminsert=0                                                               " IMEの管理
  se imsearch=0

  se sessionoptions&                                                          " セッションファイルに保存する内容
  se sessionoptions-=options
  se sessionoptions-=folds
  se sessionoptions-=blank
  se sessionoptions+=slash

  se viminfo='500,<50,s10,h


  " se undofileでアンドゥデータをファイルを閉じても残しておく
  " 該当フォルダがなければ作成
  if has('nvim')
    if !isdirectory($MYVIMRUNTIME . '/nvim_undofiles')
      cal mkdir($MYVIMRUNTIME . '/nvim_undofiles', 'p')
    en
    se undodir=$MYVIMRUNTIME/nvim_undofiles
  else
    if !isdirectory($MYVIMRUNTIME . '/undofiles')
      cal mkdir($MYVIMRUNTIME . '/undofiles', 'p')
    en
    se undodir=$MYVIMRUNTIME/undofiles
  endif
  se undofile

  " se backupでバックアップファイルを保存する
  " 該当フォルダがなければ作成
  if !isdirectory($MYVIMRUNTIME . '/backupfiles')
    cal mkdir($MYVIMRUNTIME . '/backupfiles', 'p')
  en

  se backupdir=$MYVIMRUNTIME/backupfiles
  se backup


  " change swap file directory
  if !isdirectory($HOME . '/tmp')
    cal mkdir($HOME . '/tmp','p')
  en

  se dir-=.
  se dir^=$HOME/tmp//

  " Statusline settings {{{
  let &statusline=''
  let &statusline.='%1*%m%r%h%w%q'
  let &statusline.=' %f '
  let &statusline.='%<'
  let &statusline.='%0*'
  let &statusline.="\uE0B8 "
  let &statusline.='%='
  let &statusline.='%{Myvimrc_statusline_tagbar()}'
  let &statusline.="\uE0BA"
  let &statusline.='%2*'
  let &statusline.=' %{Myvimrc_statusline_git()}'
  let &statusline.='%4*'
  let &statusline.='%{Myvimrc_statusline_gitgutter()}'
  let &statusline.='%3*'
  " スペースの制御のため%yは使わない
  let &statusline.='%{&ft==#""?"":"[".&ft."] "}'
  if has('multi_byte')
    let &statusline.='%1*'
    let &statusline.='%{&fenc==#""?&enc:&fenc}'
  en
  let &statusline.='(%{&fileformat})'
  let &statusline.=' '
  let &statusline.='%5*'
  let &statusline.='%3p%%%5l:%-3v'

  aug vimrc_status_vars
    au!
    " 移植するか要検討
    au CursorHold,CursorHoldI * cal mymisc#set_statusline_vars()
  aug END

  fun! Myvimrc_statusline_tagbar() abort
    retu get(w:,'mymisc_status_tagbar','')
  endf

  fun! Myvimrc_statusline_git() abort
    retu get(w:,'mymisc_status_git','')
  endf

  fun! Myvimrc_statusline_gitgutter() abort
    retu get(w:,'mymisc_status_gitgutter','')
  endf
  " }}}

  let g:mymisc_files_is_available = v:false " (executable('files') ? v:true : v:false)
  let g:mymisc_rg_is_available = (executable('rg') ? v:true : v:false)
  let g:mymisc_pt_is_available = v:false " (executable('pt') ? v:true : v:false)
  let g:mymisc_ag_is_available = v:false " (executable('ag') ? v:true : v:false)
  let g:mymisc_fcitx_is_available = (executable('fcitx-remote') ? v:true : v:false)

  let s:exclude_dirs = '{.bzr,CVS,.git,.hg,.svn}'
  let s:excludes = '{tags,}'

  if has('win32') && executable('git')
    " Use Git-bash's grep
    let s:grep_exe_path = fnamemodify(exepath('git'),':h:h:p').'\usr\bin\grep.exe'
    exe 'se grepprg=' . escape('"' . s:grep_exe_path . '" -rnIH --exclude-dir='.s:exclude_dirs.' --exclude='.s:excludes.' $*', ' \"')
  elseif has('mac')
    if executable('ggrep')
      exe 'se grepprg=' . escape('ggrep -rnIH --exclude-dir='.s:exclude_dirs.' --exclude='.s:excludes.' $*', ' \"')
    else
      exe 'se grepprg=' . escape('grep -rnIH --exclude-dir='.s:exclude_dirs.' --exclude='.s:excludes.' $*', ' \"')
    en
  elseif has('unix')
    exe 'se grepprg=' . escape('grep -rnIH --exclude-dir='.s:exclude_dirs.' --exclude='.s:excludes.' $*', ' \"')
  en

  " " agがあればgrepの代わりにagを使う
  " if g:mymisc_rg_is_available
  "   se grepprg=rg\ --vimgrep\ --follow\ $*\ .
  " elseif g:mymisc_pt_is_available
  "   se grepprg=pt\ --nogroup\ --nocolor\ --column\ --follow\ $*\ .
  " elseif g:mymisc_ag_is_available
  "   se grepprg=ag\ --nogroup\ --nocolor\ --column\ --follow\ $*\ .
  " en
  " }}} OPTIONS END

  " MAPPING {{{
  " Move cursor in display lines method
  " nn j gj
  " nn k gk
  " nn gj j
  " nn gk k
  " nn <Down> gj
  " nn <Up> gk

  " vn j gj
  " vn k gk
  " vn gj j
  " vn gk k
  " vn <Down> gj
  " vn <Up> gk

  nmap <C-w>+ <C-w>+<SID>ws
  nmap <C-w>- <C-w>-<SID>ws
  nmap <C-w>> <C-w>><SID>ws
  nmap <C-w>< <C-w><<SID>ws
  nnoremap <script> <SID>ws+ <C-w>5+<SID>ws
  nnoremap <script> <SID>ws- <C-w>5-<SID>ws
  nnoremap <script> <SID>ws> <C-w>5><SID>ws
  nnoremap <script> <SID>ws< <C-w>5<<SID>ws
  nmap <SID>ws <Nop>

  nn <C-Tab> gt
  nn <C-S-Tab> gT

  " " Clear highlighting on escape in normal mode
  " " disable because it conflicts telescope normal <ESC> mapping
  " nn <ESC><ESC> :noh<CR><ESC>
  " nn <ESC>^[ <ESC>^[

  " nn Y v$hy

  " nn <C-g> 2<C-g>
  " nn <C-]> g<C-]>

  vn <c-a> <c-a>gv
  vn <c-x> <c-x>gv

  " ビジュアルモードでも*検索が使えるようにする
  aug vimrc_searchindex
    " Avoid error on startup caused by <unique> in vim-searchindex
    au!
    au VimEnter * vn * "9y:<C-u>let @/ = '\<'.@9.'\>\C'<CR>/<CR>
    au VimEnter * vn g* "9y:<C-u>let @/ = @9.'\C'<CR>/<CR>
    au VimEnter * vn # "9y:<C-u>let @/ = '\<'.@9.'\>\C'<CR>?<CR>
    au VimEnter * vn g# "9y:<C-u>let @/ = @9.'\C'<CR>?<CR>
  aug END

  " とりあえずvery magic
  " nn / /\v

  " !マークはInsert Modeと-line Modeへのマッピング
  " emacs like keymap in insert/ mode

  no! <C-a> <Home>
  no! <C-e> <End>
  ino <C-k> <Right><ESC>Da
  ino <C-l> <Delete>
  cno <C-@> <C-a>

  if has('mouse')
    nmap <X1Mouse> <C-o>
    nmap <X2Mouse> <C-i>
  en

  if has('gui_running')
    no! <M-n> <Down>
    no! <M-p> <Up>
    no! <M-f> <S-Right>
    no! <M-b> <S-Left>
    no! <M-BS> <C-w>
  elseif has('nvim')
    no! <M-n> <Down>
    no! <M-p> <Up>
    no! <M-f> <S-Right>
    no! <M-b> <S-Left>
    no! <M-C-H> <C-w>
    no! <M-BS> <C-w>
  else
    if has('win32')
      no! î  <Down>
      no! ð <Up>
      no! æ <S-Right>
      no! â  <S-Left>
      no!  <C-w>
    else
      " fun! Myvimrc_fast_esc_unmap(timer) abort
      "   cu <ESC>n
      "   cu <ESC>p
      "   cu <ESC>f
      "   cu <ESC>b
      "   cu <ESC>

      "   iu <ESC>n
      "   iu <ESC>p
      "   iu <ESC>f
      "   iu <ESC>b
      "   iu <ESC>

      "   let &timeoutlen=s:old_tlen
      "   ino <silent> <ESC> <C-r>=<C-u><SID>fast_esc()<CR>
      " endf

      " fun! s:fast_esc() abort
      "   " ESCが押されたらtimeoutlenを短くして
      "   " ESCが認識されるのを早くする。
      "   " 無事認識後元の状態に戻すことでfast_esc()のバインドの反応も早くする
      "   iu <ESC>
      "   let s:old_tlen = &timeoutlen
      "   se timeoutlen=10

      "   cno <ESC>n <Down>
      "   cno <ESC>p <Up>
      "   cno <ESC>f <S-Right>
      "   cno <ESC>b <S-Left>
      "   cno <ESC> <C-w>

      "   ino <ESC>n <Down>
      "   ino <ESC>p <Up>
      "   ino <ESC>f <S-Right>
      "   ino <ESC>b <S-Left>
      "   ino <ESC> <C-w>

      "   cal feedkeys("\<ESC>", 'i')
      "   cal timer_start(20, 'Myvimrc_fast_esc_unmap', {'repeat':1})
      "   retu ''
      " endf

      " ino <silent> <ESC> <C-r>=<C-u><SID>fast_esc()<CR>

      " cno <ESC>n <Down>
      " cno <ESC>p <Up>
      " cno <ESC>f <S-Right>
      " cno <ESC>b <S-Left>
      " cno <ESC> <C-w>

      " ino <ESC>n <Down>
      " ino <ESC>p <Up>
      " ino <ESC>f <S-Right>
      " ino <ESC>b <S-Left>
      " ino <ESC> <C-w>
    en
  en

  ino <M-Up>    <esc><c-w>k
  ino <M-Down>  <esc><c-w>j
  ino <M-Right> <esc><c-w>l
  ino <M-Left>  <esc><c-w>h
  ino <M-k> <esc><c-w>k
  ino <M-j> <esc><c-w>j
  ino <M-l> <esc><c-w>l
  ino <M-h> <esc><c-w>h
  nno <M-Up>    <c-w>k
  nno <M-Down>  <c-w>j
  nno <M-Right> <c-w>l
  nno <M-Left>  <c-w>h
  nno <M-k> <c-w>k
  nno <M-j> <c-w>j
  nno <M-l> <c-w>l
  nno <M-h> <c-w>h

  if has('nvim')
    " tno <C-w>      <C-\><C-n>G<C-w>
    " tno <C-w>.     <C-w>
    " tno <C-w><C-w> <C-w>
    " tno <expr> <C-w>" '<C-\><C-N>"'.nr2char(getchar()).'pi'
    tno <M-Up>           <c-\><c-n><c-w>k
    tno <M-Down>         <c-\><c-n><c-w>j
    tno <M-Right>        <c-\><c-n><c-w>l
    tno <M-Left>         <c-\><c-n><c-w>h
    tno <M-k>            <c-\><c-n><c-w>k
    tno <M-j>            <c-\><c-n><c-w>j
    tno <M-l>            <c-\><c-n><c-w>l
    tno <M-h>            <c-\><c-n><c-w>h
    tno <ESC>            <c-\><c-n><Plug>(esc)
    nno <Plug>(esc)<ESC> i<ESC>
  else
    if has('terminal')
      " tno <C-w><C-w> <C-w>.
      tno <C-w><Space>te <C-w>:T<CR>
      tno <C-w><Space><Space> <C-w>:cal <SID>set_winheight_small()<CR>
    en
  en
  nn <C-w><Space><Space> :cal <SID>set_winheight_small()<CR>

  no! <C-f> <Right>
  no! <C-b> <Left>

  " no! <C-g><C-g> <ESC>

  cno <C-o> <C-a>
  cno <C-p> <up>
  cno <C-n> <down>

  nn <Leader>u  :<C-u>/ oldfiles<Home>browse filter /

  " delete without yanking
  nn <leader>d "_d
  vn <leader>d "_d
  " replace currently selected text with default register
  " without yanking it
  vn <leader>p "_dp
  vn <leader>P "_dP

  " vno <leader>ty y:call system("tmux load-buffer -", @0)<cr>
  " vno <leader>ny y:call system("nc localhost 8377", @0)<cr>

  " nno <leader>tyy yy:call system("tmux load-buffer -", @0)<cr>
  " nno <leader>nyy yy:call system("nc localhost 8377", @0)<cr>
  " nno <leader>tp :let @0 = system("tmux save-buffer -")<cr>"0p

  nno ,c viw:s/\%V\(_\\|-\)\(.\)/\u\2/g<CR>
  nno ,_ viw:s/\%V\([A-Z]\)/_\l\1/g<CR>
  nno ,- viw:s/\%V\([A-Z]\)/-\l\1/g<CR>
  xno ,c :s/\%V\(_\\|-\)\(.\)/\u\2/g<CR>
  xno ,_ :s/\%V\([A-Z]\)/_\l\1/g<CR>
  xno ,- :s/\%V\([A-Z]\)/-\l\1/g<CR>

  " fun! s:lexplore(arg) abort
  "   let tail = expand('%:t')
  "   let full = substitute(expand('%:p'),'\','/','g')

  "   exe "Lexplore ".a:arg
  "   normal 99h

  "   try
  "     let netrw_top = substitute(w:netrw_treetop,'\','/','g')
  "     let tree_nodes = split(substitute(full, netrw_top, '', 'g'),'/')

  "     for node in tree_nodes
  "       cal search('\(^\|\s\)\zs'.node.'\(/\|\)$')
  "     endfo
  "   catch
  "     " pass
  "   endt

  "   if !exists("w:mynetrw_wide")
  "     let w:mynetrw_wide = 0
  "   en
  " endf

  " fun! s:lex_apply_toggle() abort
  "   if w:mynetrw_wide
  "     normal! |
  "   else
  "     exe "normal! ".abs(g:netrw_winsize)."|"
  "   en
  " endf

  " fun! s:lex_toggle_width() abort
  "   let w:mynetrw_wide = !w:mynetrw_wide
  "   cal s:lex_apply_toggle()
  " endf

  " nn <Leader>E :<C-u>cal <SID>lexplore('%:h')<CR>
  " nn <Leader>e :<C-u>cal <SID>lexplore('')<CR>
  " nn <Leader><C-e> :<C-u>cal <SID>lexplore('.')<CR>
  " let g:netrw_banner = 1
  " let g:netrw_altfile = 1
  " let g:netrw_liststyle = 3
  " let g:netrw_sizestyle = 'H'
  " let g:netrw_usetab = 1
  " let g:netrw_hide = 1
  " let g:netrw_winsize = -35
  " let g:netrw_list_hide= '\(^\|\s\s\)\zs\.\S\+'
  " " let g:netrw_winsize = 20
  " au VIMRC FileType netrw setl bufhidden=delete
  " au VIMRC FileType netrw nn <buffer> q :<C-u>bw<CR>
  " au VIMRC FileType netrw nn <buffer> qq :<C-u>bw<CR>
  " au VIMRC FileType netrw nn <buffer> A :<C-u>cal <SID>lex_toggle_width()<CR>
  " }}} MAPPING END

  " COMMAND {{{
  " Sudoで強制保存
  if has('unix')
    if has('nvim')
      com! Wsudo :w suda://%
    else
      com! Wsudo execute("w !sudo tee % > /dev/null")
    en
  en

  " :CdCurrent で現在のファイルのディレクトリに移動できる(Kaoriyaに入ってて便利なので実装)
  com! CdCurrent tcd\ %:h
  let g:mymisc_projectdir_reference_files = [
        \ '.hg/',
        \ '.git/',
        \ '.bzr/',
        \ '.svn/',
        \ 'tags',
        \ 'tags-'
        \ ]
  com! CdProject exe "tcd " . mymisc#find_project_dir(g:mymisc_projectdir_reference_files)
  com! CdHistory cal mymisc#cd_history()
  com! Ghq cal mymisc#fzf('ghq list -p', 'cd')
  com! Fhq cal mymisc#fzf('ghq list -p', 'cd')
  if executable('tig')
    if has('nvim')
      com! Tig cal mymisc#command_at_destdir(
            \ mymisc#find_project_dir(g:mymisc_projectdir_reference_files),
            \ [":bel 100split | :terminal tig"])
    el
      com! Tig cal mymisc#command_at_destdir(
            \ mymisc#find_project_dir(g:mymisc_projectdir_reference_files),
            \ [":bel split | :terminal ++curwin ++close tig"])
    en
  en
  com! Todo exe 'drop ' . get(g:,'memolist_path',$HOME . '/memo') . '/todo.txt'

  com! CpPath cal mymisc#copypath()
  com! CpFileName cal mymisc#copyfname()
  com! CpDirPath cal mymisc#copydirpath()
  com! Ctags cal mymisc#ctags_project(g:mymisc_projectdir_reference_files)
  com! DiffOrig vert new | se bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
  " com! Transparent set notermguicolors | hi Normal ctermbg=none | hi SpecialKey ctermbg=none | hi NonText ctermbg=none | hi LineNr ctermbg=none | hi EndOfBuffer ctermbg=none
  fun! s:transparent() abort

    hi Normal ctermbg=NONE guibg=NONE
    hi NonText ctermbg=NONE guibg=NONE
    " hi EndOfBuffer ctermbg=NONE guibg=NONE
    hi Folded ctermbg=NONE guibg=NONE
    hi LineNr ctermbg=NONE guibg=NONE
    hi CursorLineNr ctermbg=NONE guibg=NONE
    hi SpecialKey ctermbg=NONE guibg=NONE
    hi Error ctermbg=NONE guibg=NONE
    hi ErrorMsg ctermbg=NONE guibg=NONE
    hi Todo ctermbg=NONE guibg=NONE
    " hi ALEErrorSign ctermbg=NONE guibg=NONE
    " hi ALEWarningSign ctermbg=NONE guibg=NONE
    " hi GitGutterAdd ctermbg=NONE guibg=NONE
    " hi GitGutterChange ctermbg=NONE guibg=NONE
    " hi GitGutterChangeDelete ctermbg=NONE guibg=NONE
    " hi GitGutterDelete ctermbg=NONE guibg=NONE
    hi SignColumn ctermbg=NONE guibg=NONE
    hi CursorLine cterm=underline gui=underline ctermbg=NONE guibg=NONE
    hi StatusLine cterm=underline gui=underline ctermbg=NONE guibg=NONE
    hi StatusLineNC cterm=NONE gui=NONE ctermbg=NONE guibg=NONE
    " hi StatusLineTerm cterm=NONE gui=NONE ctermbg=NONE guibg=NONE
    hi TabLineFill ctermbg=NONE guibg=NONE
  endf
  " com! Transparent hi Normal ctermbg=none guibg=NONE
  com! Transparent cal s:transparent()
  com! -nargs=1 -bang TabWidth exe 'se sw='.<args>.' sts='.<args>.' '.(<bang>0 ? 'no' : '').'et'

  com! CreateNewPlan cal s:create_new_plan()

  fun! s:create_new_plan() abort
    let l:plandir = $HOME . '/plans/'
    exe '!cp -i '.l:plandir.'/_plan_template.txt '.l:plandir.'/plan'.strftime("%Y%m%d").'.txt'
    exe 'e '.l:plandir.'/plan'.strftime("%Y%m%d").'.txt'
  endf

  com! FollowSymlink cal s:follow_symlink()
  fun! s:follow_symlink()
    let l:fname = resolve(expand('%:p'))
    let l:pos = getpos('.')
    let l:bufname = bufname('%')
    enew
    exec 'bw '. l:bufname
    exec "e " . fname
    cal setpos('.', pos)
  endf

  fun! s:get_termrun_cmd(cmd) abort
    if has('nvim')
      let l:terminal_cmd = ':bel 15split term://'
    else
      " let l:terminal_cmd = ':bel terminal '
      let l:terminal_cmd = ':terminal '
    en
    let l:ret = l:terminal_cmd . a:cmd
    retu l:ret
  endf

  fun! s:open_terminal_file() abort
    let l:target_dir = expand('%:p:h')
    let l:cmd = s:get_termrun_cmd(match(&shell, 'zsh') > 0 ? &shell . ' --login' : &shell)
    cal mymisc#command_at_destdir(l:target_dir, [l:cmd])
    if has('nvim')
      call feedkeys('i')
    endif
  endf

  fun! s:open_terminal_current() abort
    exe s:get_termrun_cmd(match(&shell, 'zsh') > 0 ? &shell . ' --login' : &shell)
    if has('nvim')
      call feedkeys('i')
    endif
  endf

  let g:myvimrc_term_winheight=15
  fun! s:set_winheight_small() abort
    exe 'normal! ' . g:myvimrc_term_winheight . '_'
  endf

  fun! s:my_git_cmd(git_cmd) abort
    let l:target_dir = mymisc#find_project_dir(g:mymisc_projectdir_reference_files)
    let l:cmd = s:get_termrun_cmd('git ' . a:git_cmd)
    cal mymisc#command_at_destdir(l:target_dir, [l:cmd])
    cal s:set_winheight_small()
  endf

  fun! s:my_git_push() abort
    cal s:my_git_cmd('push')
  endf

  fun! s:my_git_push_setupstream() abort
    cal s:my_git_cmd('push -u origin HEAD')
  endf

  fun! s:my_git_pull() abort
    cal s:my_git_cmd('pull')
  endf

  nn <Leader>gp :<C-u>cal <SID>my_git_push()<CR>
  nn <Leader>gP :<C-u>cal <SID>my_git_push_setupstream()<CR>
  nn <Leader>te :<C-u>T<CR>
  nn <Leader>tc :<C-u>Tc<CR>
  com! T cal s:open_terminal_file()
  com! Tc cal s:open_terminal_current()

  if !has('nvim') && has('win32')
    let g:myvimrc_msys_dir =
          \ get(g:, 'myvimrc_msys_dir', 'C:/msys64')
    com! MSYSTerm cal mymisc#mintty_sh(
          \ "MSYS64",
          \ g:myvimrc_msys_dir . '/usr/bin/bash.exe',
          \ g:myvimrc_msys_dir . '/usr/bin/locale.exe')

    let g:myvimrc_gitbash_dir =
          \ get(g:, 'myvimrc_gitbash_dir', substitute(fnamemodify(exepath('git'),':h:h:p'), '\', '/', 'g'))
    com! Gbash cal mymisc#mintty_sh(
          \ "GitBash",
          \ g:myvimrc_gitbash_dir . '/bin/bash.exe',
          \ g:myvimrc_gitbash_dir . '/usr/bin/locale.exe')
  en


  if has('win32') && executable('git')
    let s:_openssl = fnamemodify(exepath('git'),':h:h:p').'\usr\bin\openssl.exe'
  elseif has('unix')
    let s:_openssl = 'openssl'
  en

  fun! s:encrypt_openssl(version) abort
    let pass = inputsecret('Password: ')
    if pass ==# ''
      echom 'Aborted.'
      retu
    en

    let pass_confirm = inputsecret('Verify password: ')
    if pass_confirm ==# ''
      echom 'Aborted.'
      retu
    en

    if pass !=# pass_confirm
      echom 'Passwords are different. Aborted.'
      retu
    en

    let fname_base = expand('%') . '.crypt'
    let fname = fname_base
    let counter = 0

    while filereadable(fname)
      let counter += 1
      let fname = fname_base . string(counter)
    endwhile

    if a:version >= 111
      cal systemlist('"' . s:_openssl . '" aes-256-cbc -pbkdf2 -e -in ' . expand('%') .  ' -out ' . fname . ' -pass pass:' . pass)
    else
      cal systemlist('"' . s:_openssl . '" aes-256-cbc -e -in ' . expand('%') .  ' -out ' . fname . ' -pass pass:' . pass)
    en
    exe 'split ' . fname
  endf

  fun! s:decrypt_openssl(version) abort
    let pass = inputsecret('Password: ')

    if a:version >= 111
      let decrypted = systemlist('"' . s:_openssl . '" aes-256-cbc -pbkdf2 -d -in ' . expand('%') . ' -pass pass:' . pass)
    else
      let decrypted = systemlist('"' . s:_openssl . '" aes-256-cbc -d -in ' . expand('%') . ' -pass pass:' . pass)
    en
    new
    cal append(0, decrypted)
    normal! G
    if getline('.') ==# ''
      normal! dd
    en
  endf

  com! EncryptOld cal s:encrypt_openssl(110)
  com! DecryptOld cal s:decrypt_openssl(110)
  com! Encrypt    cal s:encrypt_openssl(111)
  com! Decrypt    cal s:decrypt_openssl(111)

  fun! s:open_file_explorer(path) abort
    if a:path ==# ''
      let path = '.'
    else
      let path = a:path
    en

    if has('win32')
      cal system("explorer.exe " . expand(path))
    elseif has('mac')
      cal system('open ' . expand(path))
    else
      cal system("xdg-open " . expand(path))
    en
  endf

  com! -nargs=? -complete=dir OpenExplorer cal s:open_file_explorer('<args>')
  " }}} COMMAND END

  " AUTOCMD {{{
  aug VIMRC
    " HTML,XML,CSS,JavaScript
    au Filetype html,xml setl expandtab softtabstop=2 shiftwidth=2 foldmethod=indent
    au Filetype css setl foldmethod=syntax
    au FileType javascript,jade,pug setl foldmethod=syntax expandtab softtabstop=2 shiftwidth=2

    " Vue
    au FileType vue setl iskeyword+=$,-,:,/ expandtab softtabstop=2 shiftwidth=2 foldmethod=indent

    " Markdown
    let g:markdown_fenced_languages = [
          \   'bash=sh',
          \   'c',
          \   'cpp',
          \   'css',
          \   'go',
          \   'html',
          \   'java',
          \   'javascript',
          \   'python',
          \   'sh',
          \   'vim',
          \   'sql',
          \   'yaml',
          \   'json',
          \   'plantuml'
          \ ]

    " javaのsyntaxはmarkdownのsyntaxを参照しているので有効にすると再帰ループしてしまう
    let g:java_ignore_markdown = 1

    au FileType markdown setl expandtab softtabstop=4 shiftwidth=4 concealcursor=n
    let g:markdown_syntax_conceal = 1
    let g:vim_markdown_frontmatter = 1

    set concealcursor=n
    " \x16はCTRL-Vのこと
    if exists('#ModeChanged')
      au ModeChanged [^ivV\x16]*:[ivV\x16]* let g:prev_conceallevel=&conceallevel | setl conceallevel=0
      au ModeChanged [ivV\x16]*:[^ivV\x16]* let &conceallevel = g:prev_conceallevel 
    endif

    " Json
    let g:vim_json_syntax_conceal = 1
    let g:vim_json_syntax_concealcursor = "n"

    " Java
    au FileType java setl noexpandtab softtabstop=4 shiftwidth=4

    " Python
    let g:python_highlight_all = 1
    au FileType python setl foldmethod=indent
    " au FileType python setl autoindent nosmartindent
    " au FileType python setl cinwords=if,elif,else,for,while,try,except,finally,def,class
    au FileType python ino <buffer> # X#
    au FileType python nn <buffer> >> i<C-t><ESC>^

    " Latex
    let g:tex_conceal = ""

    " C++
    au FileType c,cpp setl foldmethod=syntax expandtab softtabstop=2 shiftwidth=2

    " C#
    au FileType cs setl noexpandtab

    " Shell
    au FileType sh setl noexpandtab softtabstop=4 shiftwidth=4

    " Vim
    let g:vimsyn_folding = 'aflmpPrt'
    au FileType vim setl expandtab softtabstop=2 shiftwidth=2
    au BufRead *.vim setl foldmethod=syntax

    " QuickFix
    " Auto open
    au QuickFixCmdPost * cwindow
    au FileType qf nn <silent><buffer> q :bw<CR>
    " Preview with p
    au FileType qf no <silent><buffer> p  <CR>zz<C-w>p

    " Help
    au FileType help nn <silent><buffer>q :bw<CR>
    au FileType help let &l:iskeyword = '!-~,^*,^|,^",' . &iskeyword

    au InsertLeave * cal mymisc#ime_deactivate()
    au FocusGained * cal mymisc#ime_deactivate()
    " au VimEnter * cal mymisc#git_auto_updating()
    " au VimEnter * cal s:transparent()

    au BufRead *.launch setl ft=xml

    " クリップボードが無名レジスタと違ったら
    " (他のソフトでコピーしてきたということなので)
    " 他のレジスタに保存しておく
    " 2019-09-29 大きなクリップボードをコピーしたとき重いのでやめる
    " au FocusGained,CursorHold,CursorHoldI * if @* !=# "" && @* !=# @" | let @0 = @* | en
    " au FocusGained,CursorHold,CursorHoldI * if @+ !=# "" && @+ !=# @" | let @0 = @+ | en

    " set wrap to global one in in diff mode
    au FilterWritePre * if &diff | setlocal wrap< | en

    if !has('nvim') && v:version >= 801
      au TerminalOpen * setl nonumber nolist
      au TerminalOpen * nn <buffer>q :bw<CR>
    else
      if exists('#TermOpen')
        autocmd TermOpen * startinsert
      endif
    en

    if has('nvim')
      au ColorScheme iceberg highlight! link WinSeparator VertSplit
    endif
    au ColorScheme iceberg hi link User1 Normal
    au ColorScheme iceberg hi link User2 Title
    au ColorScheme iceberg hi link User3 Directory
    au ColorScheme iceberg hi link User4 Special
    au ColorScheme iceberg hi link User5 Comment

  aug END
  "}}} AUTOCMD END

  " BUILT-IN PLUGINS {{{
  if v:version >= 800
    if !has('nvim')
      pa! editexisting
      pa! matchit
    en

    pa! termdebug
  en
  " }}} BUILT-IN PLUGINS END
