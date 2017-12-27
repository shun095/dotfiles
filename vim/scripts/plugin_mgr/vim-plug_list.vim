
let s:save_cpo = &cpo
set cpo&vim

if exists('g:loaded_vim_plug_list')
  finish
endif
let g:loaded_vim_plug_list = 1

Plug 'cocopon/iceberg.vim'
if has('python3')
  Plug 'Shougo/denite.nvim'
        \ | Plug 'Shougo/neomru.vim'
        \ | Plug 'Shougo/unite-outline'
endif
if has('nvim')
  Plug 'Shougo/deoplete.nvim',   {'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
  " Plug 'Valloric/YouCompleteMe'
endif
" deoplete completers
Plug 'carlitux/deoplete-ternjs', { 'for': ['javascript'] }
Plug 'davidhalter/jedi-vim',     { 'for': ['python'] }
Plug 'zchee/deoplete-jedi',      { 'for': ['python'] }
Plug 'zchee/deoplete-go',        { 'for': ['go']  }
Plug 'fatih/vim-go',             { 'for': ['go'] }
" Plug 'zchee/deoplete-clang',     { 'for': ['c', 'cpp'] }
Plug 'Rip-Rip/clang_complete',   { 'for': ['c', 'cpp'] }

Plug 'artur-shaik/vim-javacomplete2',    { 'for': 'java' }

Plug 'itchyny/vim-cursorword'
Plug 'tyru/open-browser.vim'
      \ | Plug 'basyura/twibill.vim'
      \ | Plug 'basyura/bitly.vim'
      \ | Plug 'Shougo/vimproc.vim'
      \ | Plug 'ishitaku5522/TweetVim',               { 'on' : ['TweetVimHomeTimeline', 'TweetVimUserStream', 'TweetVimSay', 'TweetVimCommandSay'] }
      \ | Plug 'haya14busa/vim-open-googletranslate', { 'on' : 'OpenGoogleTranslate' }
Plug 'thinca/vim-quickrun'
      \ | Plug 'osyo-manga/shabadou.vim'
Plug 'AndrewRadev/linediff.vim',         { 'on' : 'Linediff' }
Plug 'Konfekt/FastFold'
Plug 'LeafCage/foldCC.vim'
Plug 'SirVer/ultisnips'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'aperezdc/vim-template'
Plug 'bkad/CamelCaseMotion'
Plug 'cespare/vim-toml',                 { 'for': 'toml' }
Plug 'chiel92/vim-autoformat',           { 'on' : 'Autoformat' }
Plug 'csscomb/vim-csscomb',              { 'for': 'css' }
Plug 'ctrlpvim/ctrlp.vim'
" Plug 'nixprime/cpsm'
Plug 'FelikZ/ctrlp-py-matcher'
Plug 'ervandew/supertab'
Plug 'glidenote/memolist.vim',           { 'on' : ['MemoNew', 'MemoList'] }
Plug 'gregsexton/MatchTag',              { 'for': ['html','xml'] }
Plug 'honza/vim-snippets'
Plug 'iamcco/markdown-preview.vim',      { 'for':  'markdown' }
Plug 'itchyny/calendar.vim',             { 'on' : 'Calendar' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/gv.vim'
Plug 'junegunn/vim-easy-align'
Plug 'kana/vim-submode'
Plug 'kannokanno/previm',                { 'for': 'markdown' }
Plug 'lervag/vimtex',                    { 'for': 'tex' }
Plug 'majutsushi/tagbar',                { 'on' : ['TagbarToggle', 'TagbarOpen'] }
Plug 'mattn/emmet-vim',                  { 'for': ['html','xml'] }
Plug 'mbbill/undotree',                  { 'on' : ['UndotreeFocus', 'UndotreeHide', 'UndotreeShow', 'UndotreeToggle'] }
Plug 'mopp/next-alter.vim',              { 'for': ['c','cpp'] }
Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['c','cpp'] }
Plug 'osyo-manga/vim-anzu'
Plug 'othree/html5.vim',                 { 'for': 'html' }
Plug 'pangloss/vim-javascript',          { 'for': 'javascript' }
Plug 'plasticboy/vim-markdown',          { 'for': 'markdown' }
Plug 'raimondi/delimitmate'
Plug 'rdnetto/YCM-Generator',            { 'on' : 'YcmGenerateConfig', 'branch': 'stable' }
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'tmux-plugins/vim-tmux'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'tyru/restart.vim',                 { 'on' : 'Restart' }
Plug 'vim-jp/autofmt'
Plug 'vim-jp/vimdoc-ja'
Plug 'vim-jp/vital.vim'
Plug 'w0rp/ale'
Plug 'elzr/vim-json'
Plug 'ishitaku5522/revimses',            { 'branch': 'dev' }

let &cpo = s:save_cpo
unlet s:save_cpo
