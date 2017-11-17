
let s:save_cpo = &cpo
set cpo&vim

if exists('g:loaded_vim_plug_list')
  finish
endif
let g:loaded_vim_plug_list = 1

Plug 'scrooloose/nerdtree'
Plug 'Konfekt/FastFold'
Plug 'LeafCage/foldCC.vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'ervandew/supertab'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-dispatch'
Plug 'junegunn/gv.vim'
if has('python3')
  Plug 'Shougo/denite.nvim'
        \ | Plug 'Shougo/neomru.vim'
        \ | Plug 'Shougo/unite-outline'
endif
Plug 'junegunn/fzf.vim'
Plug 'ishitaku5522/revimses', { 'branch': 'dev' }
Plug 'junegunn/vim-easy-align'
Plug 'Yggdroot/indentLine'
Plug 'osyo-manga/vim-anzu'
Plug 'tmux-plugins/vim-tmux'
Plug 'tpope/vim-surround'
Plug 'vim-jp/vimdoc-ja'
Plug 'vim-jp/vital.vim'
Plug 'vim-jp/autofmt'
Plug 'cocopon/iceberg.vim'
Plug 'thinca/vim-quickrun'
      \ | Plug 'osyo-manga/shabadou.vim'
      \ | Plug 'osyo-manga/vim-watchdogs', { 'on' : ['WatchdogsRun'] }
Plug 'aperezdc/vim-template'

highlight link CursorWord0 Title
      \ | Plug 'itchyny/vim-cursorword'
call timer_start(0,{-> execute('highlight! link CursorWord0 MoreMsg')})

Plug 'chiel92/vim-autoformat'
Plug 'scrooloose/nerdcommenter'
Plug 'kana/vim-submode'
if has('nvim')
  Plug 'Shougo/deoplete.nvim'
        \ | Plug 'carlitux/deoplete-ternjs'
        \ | Plug 'zchee/deoplete-jedi', { 'for': ['python'] }
        \ | Plug 'https://github.com/Rip-Rip/clang_complete'
else
  Plug 'Valloric/YouCompleteMe'
endif
Plug 'raimondi/delimitmate'

" lazy
Plug 'bkad/CamelCaseMotion'
Plug 'iamcco/markdown-preview.vim', { 'for':  'markdown' }
Plug 'kannokanno/previm',           { 'for':  'markdown' }
Plug 'plasticboy/vim-markdown',     { 'for':  'markdown' }
Plug 'tyru/open-browser.vim'
      \ | Plug 'basyura/twibill.vim'
      \ | Plug 'basyura/bitly.vim'
      \ | Plug 'Shougo/vimproc.vim'
      \ | Plug 'ishitaku5522/TweetVim',               { 'on' : ['TweetVimHomeTimeline', 'TweetVimUserStream', 'TweetVimSay', 'TweetVimCommandSay'] }
      \ | Plug 'haya14busa/vim-open-googletranslate', { 'on' : 'OpenGoogleTranslate' }

Plug 'cespare/vim-toml',                 { 'for':  'toml' }
Plug 'csscomb/vim-csscomb',              { 'for':  'css' }
Plug 'gregsexton/MatchTag',              { 'for':  ['html','xml'] }
Plug 'othree/html5.vim',                 { 'for':  ['html'] }
Plug 'mattn/emmet-vim',                  { 'for':  ['html','xml'] }
Plug 'pangloss/vim-javascript',          { 'for':  'javascript' }
Plug 'glidenote/memolist.vim',           { 'on' : ['MemoNew', 'MemoList'] }
Plug 'lervag/vimtex',                    { 'for':  ['tex'] }
Plug 'rdnetto/YCM-Generator',            { 'on' : 'YcmGenerateConfig', 'branch': 'stable' }
Plug 'itchyny/calendar.vim',             { 'on' : 'Calendar' }
Plug 'majutsushi/tagbar',                { 'on' : ['TagbarToggle', 'TagbarOpen'] }
Plug 'artur-shaik/vim-javacomplete2',    { 'for':  'java' }
Plug 'AndrewRadev/linediff.vim',         { 'on' : 'Linediff' }
Plug 'mbbill/undotree',                  { 'on' : ['UndotreeFocus', 'UndotreeHide', 'UndotreeShow', 'UndotreeToggle'] }
Plug 'octol/vim-cpp-enhanced-highlight', { 'for':  ['c','cpp'] }
Plug 'mopp/next-alter.vim',              { 'for':  ['c','cpp'] }
Plug 'tyru/restart.vim',                 { 'on' : 'Restart' }
Plug 'chiel92/vim-autoformat',           { 'on' : 'Autoformat' }

let &cpo = s:save_cpo
unlet s:save_cpo
