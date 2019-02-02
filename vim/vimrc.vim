" vim:set foldmethod=marker:
" INITIALIZE {{{
set encoding=utf-8
language C

scriptencoding utf-8

let g:true = 1
let g:false = 0

let g:msgs_on_startup = []

try

  if !exists('$MYDOTFILES')
    let $MYDOTFILES = $HOME . '/dotfiles'
  endif

  let $MYVIMHOME=$MYDOTFILES . '/vim'

  if !exists('g:use_plugins')
    let g:use_plugins = g:true
  endif


  " Force to use python3
  if has("python3")
    py3 pass
  endif

  if has("pythonx")
    set pyxversion=3
  endif

  " }}}

  " OPTIONS {{{
  let g:mapleader = "\<space>"

  augroup VIMRC
    " Initialize augroup
    autocmd!
  augroup END

  if !has('gui_running')
    if match($TERM, '256color') > 0
      if v:version >= 800
        set termguicolors                                    " TrueColor on terminal
        if $TMUX !=# ""
          let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
          let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
        endif
      endif

      let &t_SI = '[5 q'
      let &t_EI = '[2 q'
    else
      if has('win32')
        set termguicolors
      else
        set t_Co=16                                        " 256 colors on terminal
      endif
    endif
  endif

  " Color term in :terminal
  if $TERM ==# 'screen-256color'
    let $TERM = 'xterm-256color'
  endif

  if !has('nvim')
    set ttymouse=xterm2
  endif

  if v:version >= 800
    " if !has('nvim')
    "   set cryptmethod=blowfish2
    " endif
    set breakindent                                        " version8以降搭載の便利オプション
    set display=truncate
    set emoji                                              " 絵文字を全角表示
  endif

  set diffopt+=algorithm:histogram,indent-heuristic        " Diff options
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
  set shortmess-=Tt
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
  " set complete=.,w,b,u,U,k,kspell,s,t,t
  set completeopt=menuone,noselect                         " 補完関係の設定,Ycmで自動設定される
  set pumheight=10                                         " 補完ウィンドウ最大高さ
  set iminsert=0                                           " IMEの管理
  set imsearch=0

  set sessionoptions&                                      " セッションファイルに保存する内容
  set sessionoptions-=options
  set sessionoptions-=folds
  set sessionoptions-=blank
  set sessionoptions+=slash

  set viminfo+='500
  set viminfo+=%10

  " Statusline settings {{{
  highlight link User1 Normal
  highlight link User2 Title
  highlight link User3 Directory
  highlight link User4 Special
  highlight link User5 Comment

  set statusline=%m%r%h%w%q
  set statusline+=\ %f\ %<%=
  set statusline+=%{Myvimrc_statusline_tagbar()}
  set statusline+=%2*
  set statusline+=\ %{Myvimrc_statusline_gina()}
  set statusline+=%4*
  set statusline+=%{Myvimrc_statusline_gitgutter()}
  set statusline+=%3*
  set statusline+=%{&ft==#''?'':'['.&ft.']\ '}
  if has('multi_byte')
    set statusline+=%1*%{&fileencoding!=#''?&fileencoding:&encoding}
  endif
  set statusline+=\(%{&fileformat})
  set statusline+=\ %5*%3p%%%5l:%-3v

  augroup vimrc_status_vars
    autocmd!
    autocmd CursorHold,CursorHoldI * call mymisc#set_statusline_vars()
  augroup END

  fun! Myvimrc_statusline_tagbar() abort
    if exists('w:mymisc_status_tagbar')
      return w:mymisc_status_tagbar
    else
      return ''
    endif
  endf

  fun! Myvimrc_statusline_fugitive() abort
    if exists('w:mymisc_status_fugitive')
      return w:mymisc_status_fugitive
    else
      return ''
    endif
  endf

  fun! Myvimrc_statusline_gina() abort
    if exists('w:mymisc_status_gina')
      return w:mymisc_status_gina
    else
      return ''
    endif
  endf

  fun! Myvimrc_statusline_gitgutter() abort
    if exists('w:mymisc_status_gitgutter')
      return w:mymisc_status_gitgutter
    else
      return ''
    endif
  endf
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


  if has('win32') && executable('git')
    " Use Git-bash's grep
    let s:grep_exe_path = fnamemodify(exepath('git'),':h:h:p').'\usr\bin\grep.exe'
    exe 'set grepprg=\"'.escape(s:grep_exe_path,' ').'\"\ -rnIH\ --exclude-dir=''.*''\ $*'
  elseif has('unix')
    set grepprg=grep\ -rnIH\ --exclude-dir='.*'\ $*
  endif

  " " agがあればgrepの代わりにagを使う
  " if g:mymisc_rg_is_available
  "   set grepprg=rg\ --vimgrep\ --follow\ $*\ .
  " elseif g:mymisc_pt_is_available
  "   set grepprg=pt\ --nogroup\ --nocolor\ --column\ --follow\ $*\ .
  " elseif g:mymisc_ag_is_available
  "   set grepprg=ag\ --nogroup\ --nocolor\ --column\ --follow\ $*\ .
  " endif

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

  " change swap file directory
  if !isdirectory($HOME . '/tmp')
    call mkdir($HOME . '/tmp','p')
  endif

  set dir-=.
  set dir^=$HOME/tmp//
  " }}} OPTIONS END

  " MAPPING {{{
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

  nnoremap <C-Tab> gt
  nnoremap <C-S-Tab> gT

  " Clear highlighting on escape in normal mode
  nnoremap <ESC> :noh<CR><ESC>
  nnoremap <ESC>^[ <ESC>^[

  nnoremap Y v$hy

  nnoremap <C-g> 2<C-g>
  nnoremap <C-]> g<C-]>

  vnoremap <c-a> <c-a>gv
  vnoremap <c-x> <c-x>gv

  " ビジュアルモードでも*検索が使えるようにする
  augroup vimrc_searchindex
    " Avoid error on startup caused by <unique> in vim-searchindex
    autocmd!
    autocmd VimEnter * vnoremap * "9y:<C-u>let @/ = '\<'.@9.'\>\C'<CR>/<CR>
    autocmd VimEnter * vnoremap g* "9y:<C-u>let @/ = @9.'\C'<CR>/<CR>
    autocmd VimEnter * vnoremap # "9y:<C-u>let @/ = '\<'.@9.'\>\C'<CR>?<CR>
    autocmd VimEnter * vnoremap g# "9y:<C-u>let @/ = @9.'\C'<CR>?<CR>
  augroup END

  " !マークはInsert ModeとCommand-line Modeへのマッピング
  " emacs like keymap in insert/command mode

  noremap! <C-a> <Home>
  noremap! <C-e> <End>
  inoremap <C-k> <Right><ESC>Da

  if has('gui_running')
    noremap! <M-n> <Down>
    noremap! <M-p> <Up>
    noremap! <M-f> <S-Right>
    noremap! <M-b> <S-Left>
    noremap! <M-BS> <C-w>
  elseif has('nvim')
    noremap! <M-n> <Down>
    noremap! <M-p> <Up>
    noremap! <M-f> <S-Right>
    noremap! <M-b> <S-Left>
    noremap! <M-C-H> <C-w>
    noremap! <M-BS> <C-w>
  else
    if has('win32')
      noremap! î  <Down>
      noremap! ð <Up>
      noremap! æ <S-Right>
      noremap! â  <S-Left>
      noremap!  <C-w>
    else
      function! Myvimrc_fast_esc_unmap(timer) abort
        iunmap <ESC>n
        iunmap <ESC>p
        iunmap <ESC>f
        iunmap <ESC>b
        iunmap <ESC>
        let &timeoutlen=s:old_tlen
        inoremap <ESC> <C-r>=<C-u><SID>fast_esc()<CR>
      endfunction

      function! s:fast_esc() abort
        let s:old_tlen = &timeoutlen
        set timeoutlen=50
        inoremap <ESC>n <Down>
        inoremap <ESC>p <Up>
        inoremap <ESC>f <S-Right>
        inoremap <ESC>b <S-Left>
        inoremap <ESC> <C-w>
        iunmap <ESC>
        call feedkeys("\<ESC>", 'i')
        call timer_start(100, 'Myvimrc_fast_esc_unmap', {'repeat':1})
        return ""
      endfunction

      inoremap <ESC> <C-r>=<C-u><SID>fast_esc()<CR>

      cnoremap <ESC>n <Down>
      cnoremap <ESC>p <Up>
      cnoremap <ESC>f <S-Right>
      cnoremap <ESC>b <S-Left>
      cnoremap <ESC> <C-w>
    endif
  endif

  if has('nvim')
    tnoremap <C-w> <C-\><C-n>G<C-w>
    tnoremap <C-w>. <C-w>
    tnoremap <expr> <C-w>" '<C-\><C-N>"'.nr2char(getchar()).'pi'
  endif

  noremap! <C-f> <Right>
  noremap! <C-b> <Left>

  noremap! <C-g><C-g> <ESC>

  cnoremap <C-o> <C-a>
  cnoremap <C-p> <up>
  cnoremap <C-n> <down>

  nnoremap <Leader>u  :<C-u>/ oldfiles<Home>browse filter /

  function! s:lexplore(arg) abort
    let tail = expand('%:t')
    let full = substitute(expand('%:p'),'\','/','g')

    exe "Lexplore ".a:arg
    normal 99h

    let netrw_top = substitute(w:netrw_treetop,'\','/','g')
    let tree_nodes = split(substitute(full, netrw_top, '', 'g'),'/')

    for node in tree_nodes
      call search('\(^\|\s\)\zs'.node.'\(/\|\)$')
    endfor

    if !exists("w:mynetrw_wide")
      let w:mynetrw_wide = 0
    endif
  endfunction

  function! s:lex_apply_toggle() abort
    if w:mynetrw_wide
      normal! |
    else
      exe "normal! ".abs(g:netrw_winsize)."|"
    endif
  endfunction

  function! s:lex_toggle_width() abort
    let w:mynetrw_wide = !w:mynetrw_wide
    call s:lex_apply_toggle()
  endfunction

  nnoremap <Leader>e :<C-u>call <SID>lexplore('%:h')<CR>
  nnoremap <Leader>E :<C-u>call <SID>lexplore('.')<CR>
  let g:netrw_banner = 0
  let g:netrw_altfile = 1
  let g:netrw_liststyle = 3
  let g:netrw_sizestyle = 'H'
  let g:netrw_usetab = 1
  let g:netrw_hide = 1
  let g:netrw_winsize = -35
  let g:netrw_list_hide= '\(^\|\s\s\)\zs\.\S\+'
  " let g:netrw_winsize = 20
  autocmd VIMRC FileType netrw setl bufhidden=delete
  autocmd VIMRC FileType netrw nnoremap <buffer> q :<C-u>bw<CR>
  autocmd VIMRC FileType netrw nnoremap <buffer> qq :<C-u>bw<CR>
  autocmd VIMRC FileType netrw nnoremap <buffer> A :<C-u>call <SID>lex_toggle_width()<CR>
  " }}} MAPPING END

  " COMMANDS {{{
  " Sudoで強制保存
  if has('unix')
    if has('nvim')
      command! Wsudo :w suda://%
    else
      command! Wsudo execute("w !sudo tee % > /dev/null")
    endif
  endif

  " :CdCurrent で現在のファイルのディレクトリに移動できる(Kaoriyaに入ってて便利なので実装)
  command! CdCurrent cd\ %:h
  let g:mymisc_projectdir_reference_files = [
        \ '.hg/',
        \ '.git/',
        \ '.bzr/',
        \ '.svn/',
        \ 'tags',
        \ 'tags-'
        \ ]
  command! CdProject execute "cd " . mymisc#find_project_dir(g:mymisc_projectdir_reference_files)

  command! CpPath call mymisc#copypath()
  command! CpFileName call mymisc#copyfname()
  command! CpDirPath call mymisc#copydirpath()
  command! Ctags call mymisc#ctags_project(g:mymisc_projectdir_reference_files)
  command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
  command! Transparent set notermguicolors | hi Normal ctermbg=none | hi SpecialKey ctermbg=none | hi NonText ctermbg=none | hi LineNr ctermbg=none | hi EndOfBuffer ctermbg=none

  command! FollowSymlink call s:follow_symlink()
  function! s:follow_symlink()
    let l:fname = resolve(expand('%:p'))
    let l:pos = getpos('.')
    let l:bufname = bufname('%')
    enew
    exec 'bw '. l:bufname
    exec "e " . fname
    call setpos('.', pos)
  endfunction

  function! s:get_termrun_cmd(cmd, height) abort
    if has('nvim')
      let l:terminal_cmd = ':bel '.a:height.'split term://'
    else
      let l:terminal_cmd = ':bel terminal ++rows='.a:height.' '
    endif
    let l:ret = l:terminal_cmd . a:cmd
    return l:ret
  endfunction

  function! s:my_git_push() abort
    let l:target_dir = mymisc#find_project_dir(g:mymisc_projectdir_reference_files)
    let l:cmd = s:get_termrun_cmd('git push',20)
    call mymisc#command_at_destdir(l:target_dir, [l:cmd])
  endfunction

  function! s:my_git_pull() abort
    let l:target_dir = mymisc#find_project_dir(g:mymisc_projectdir_reference_files)
    let l:cmd = s:get_termrun_cmd('git pull',20)
    call mymisc#command_at_destdir(l:target_dir, [l:cmd])
  endfunction

  nnoremap <Leader>gp :call <SID>my_git_push()<CR>
  nnoremap <Leader>gl :call <SID>my_git_pull()<CR>
  nnoremap <Leader>te :execute <SID>get_termrun_cmd(&shell, 20)<CR>

  if !has('nvim')
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
            \ 'curwin': g:false,
            \ 'cwd': $USERPROFILE,
            \ 'env': l:env,
            \ })
    endfunction
  endif

  function! s:encrypt_openssl() abort
    if has('win32') && executable('git')
      let command_openssl = fnamemodify(exepath('git'),':h:h:p').'\usr\bin\openssl.exe'
    elseif has('unix')
      let command_openssl = 'openssl'
    endif
    let pass = inputsecret("Password: ")
    let pass_confirm = inputsecret("Verify password: ")

    let fname_base = expand("%") .".crypt"
    let fname = fname_base
    let counter = 0

    while filereadable(fname)
        let counter += 1
        let fname = fname_base . string(counter)
    endwhile

    if pass ==# pass_confirm
      " exe ":!\"".command_openssl."\" aes-256-cbc -pbkdf2 -e -in % -out ".fname." -pass pass:".pass
      exe ":!\"".command_openssl."\" aes-256-cbc -e -in % -out ".fname." -pass pass:".pass
    else
      echomsg "\nPasswords are different!"
    endif
  endfunction

  function! s:decrypt_openssl() abort
    if has('win32') && executable('git')
      let command_openssl = fnamemodify(exepath('git'),':h:h:p').'\usr\bin\openssl.exe'
    elseif has('unix')
      let command_openssl = 'openssl'
    endif
    let pass = inputsecret("Password: ")

    let fname_base = expand("%:r")
    let fname = fname_base
    let counter = 0

    while filereadable(fname)
        let counter += 1
        let fname = fname_base . string(counter)
    endwhile

    " exe ":!\"".command_openssl."\" aes-256-cbc -pbkdf2 -d -in % -out ".fname." -pass pass:".pass
    exe ":!\"".command_openssl."\" aes-256-cbc -d -in % -out ".fname." -pass pass:".pass
    exe ":edit ".expand(fname)
  endfunction

  command! Encrypt call s:encrypt_openssl()
  command! Decrypt call s:decrypt_openssl()

  function! s:open_file_explorer(path) abort
    if a:path ==# ''
      let path = '.'
    else
      let path = a:path
    endif

    if has('win32')
      call system("explorer.exe " . expand(path))
    else
      call system("xdg-open " . expand(path))
    endif
  endfunction

  command! -nargs=? -complete=dir OpenExplorer call s:open_file_explorer('<args>')
  cabbrev OE OpenExplorer
  " }}} COMMANDS END

  " AUTOCMDS {{{
  augroup VIMRC
    " Markdown
    let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'cpp', 'c', 'vim']

    " HTML,XML,CSS,JavaScript
    autocmd Filetype html,xml,vue setl expandtab softtabstop=2 shiftwidth=2 foldmethod=indent
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

    " Latex
    let g:tex_conceal = ""

    " C++
    autocmd FileType c,cpp setl foldmethod=syntax expandtab softtabstop=2 shiftwidth=2

    " C#
    autocmd FileType cs setl noexpandtab

    " Vim
    let g:vimsyn_folding = 'aflmpPrt'
    autocmd FileType vim setl expandtab softtabstop=2 shiftwidth=2 tabstop=2
    autocmd BufRead *.vim setl foldmethod=syntax

    " QuickFix
    " Auto open
    autocmd QuickFixCmdPost * cwindow
    autocmd FileType qf nnoremap <silent><buffer> q :bw<CR>
    " Preview with p
    autocmd FileType qf noremap <silent><buffer> p  <CR>zz<C-w>p

    " Help
    autocmd FileType help nnoremap <silent><buffer>q :bw<CR>
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
    if !has('nvim') && v:version >= 810
      autocmd TerminalOpen * setl listchars= nonumber
    endif
  augroup END
  "}}} AUTOCMDS END

  " BUILT-IN PLUGINS {{{
  if !has('nvim')
    packadd! editexisting
    packadd! matchit
  endif

  packadd! termdebug
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
  call g:plugin_mgr.load()

  " }}} PLUGIN MANAGER SETUP END
  "
  if g:plugin_mgr.enabled == g:true

    " WHEN PLUGINS ARE ENABLED {{{

    " Local settings
    if filereadable($HOME . '/localrcs/vim-local.vim')
      source $HOME/localrcs/vim-local.vim
    endif

    " Manual setup plugins
    " fzf
    set runtimepath+=$HOME/.fzf/
    if !exists('$FZF_DEFAULT_OPTS')
      let $FZF_DEFAULT_OPTS='--color fg:-1,bg:-1,hl:1,fg+:-1,bg+:-1,hl+:1,info:3,prompt:2,spinner:5,pointer:4,marker:5'
    endif
    nnoremap <silent><expr><Leader><C-f><C-f> mymisc#command_at_destdir(mymisc#find_project_dir(['.git','tags']),['FZF'])
    nnoremap <silent> <Leader><C-f>c :FZF .<CR>

    " vimproc
    let g:vimproc#download_windows_dll = 1

    " Initialize plugin manager
    call g:plugin_mgr.init()

    try
      " Load settings of plugins
      source $MYVIMHOME/scripts/lazy_hooks.vim
      source $MYVIMHOME/scripts/custom.vim

      " Local after settings
      if filereadable($HOME . '/localrcs/vim-localafter.vim')
        source $HOME/localrcs/vim-localafter.vim
      endif
    catch
      call add(g:msgs_on_startup, 'Error in custom.vim!')
      call add(g:msgs_on_startup, 'Caught "' . v:exception . '" in ' . v:throwpoint)
    endtry

    " Colorschemes
    try
      set background=dark
      if has('gui_running') || exists('&t_Co') && &t_Co >= 256
        colorscheme one
      else
        colorscheme default
      endif
    catch
      colorscheme default
    endtry

    " highlight! Terminal ctermbg=black guibg=black
    " }}} WHEN PLUGINS ARE ENABLED END

  else

    " WHEN PLUGINS ARE DISABLED {{{
    filetype plugin indent on
    syntax enable

    colorscheme evening
    " }}} WHEN PLUGINS ARE DISABLED END

  endif

  " Let default pwd to $HOME on Windows
  if getcwd() ==# $VIMRUNTIME
    cd $HOME
  endif

catch
  call add(g:msgs_on_startup, 'Error in vimrc!')
  call add(g:msgs_on_startup, 'Caught "' . v:exception . '" in ' . v:throwpoint)
finally
  augroup VIMRC
    for s:msg in g:msgs_on_startup
      execute "autocmd VimEnter * echomsg '".s:msg."'"
    endfor
  augroup END
endtry
