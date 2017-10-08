
let s:save_cpo = &cpo
set cpo&vim

if exists('g:loaded_vim_plug_list')
  finish
endif
let g:loaded_vim_plug_list = 1

Plug 'scrooloose/nerdtree'
if has('python3')
  Plug 'Shougo/denite.nvim'
  Plug 'Shougo/neomru.vim'
  Plug 'Shougo/unite-outline'
endif

Plug 'Shougo/vimproc.vim', {'do': 'make'}

if has('nvim')
  Plug 'Shougo/deoplete.nvim'
  Plug 'Rip-Rip/clang_complete'
  Plug 'zchee/deoplete-jedi'
  Plug 'carlitux/deoplete-ternjs'
  Plug 'zchee/deoplete-jedi'
endif

Plug 'Konfekt/FastFold'
Plug 'LeafCage/foldCC.vim'
Plug 'SirVer/ultisnips'
Plug 'ervandew/supertab'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

Plug 'ctrlpvim/ctrlp.vim'
Plug 'mattn/ctrlp-register'

Plug 'honza/vim-snippets'
Plug 'ishitaku5522/revimses', {'branch': 'dev'}
Plug 'junegunn/vim-easy-align'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'osyo-manga/vim-anzu'
Plug 'tmux-plugins/vim-tmux'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdcommenter'
Plug 'tyru/open-browser.vim', {'on': [ 'OpenBrowser', 'OpenBrowserSearch', 'OpenBrowserSmartSearch' ]}
Plug 'tyru/restart.vim', {'on': 'Restart'}

Plug 'NLKNguyen/papercolor-theme'
Plug 'vim-jp/vimdoc-ja'
Plug 'vim-jp/vital.vim'
Plug 'vim-jp/autofmt'
Plug 'altercation/vim-colors-solarized'
Plug 'nanotech/jellybeans.vim'
Plug 'ajh17/Spacegray.vim'
Plug 'cocopon/iceberg.vim'
Plug 'tomasr/molokai'
Plug 'joshdick/onedark.vim'

Plug 'thinca/vim-quickrun'
Plug 'osyo-manga/shabadou.vim'

Plug 'aperezdc/vim-template'
Plug 'itchyny/vim-cursorword'
Plug 'nixprime/cpsm'
Plug 'chiel92/vim-autoformat'


" lazy plugins

Plug 'bkad/CamelCaseMotion'

Plug 'cohama/lexima.vim'

Plug 'iamcco/markdown-preview.vim', {'for': 'markdown'}
Plug 'kannokanno/previm', {'for': 'markdown'}
Plug 'plasticboy/vim-markdown', {'for': 'markdown'}

Plug 'basyura/twibill.vim'
Plug 'basyura/bitly.vim'
Plug 'ishitaku5522/TweetVim', {'on': ['TweetVimHomeTimeline', 'TweetVimUserStream', 'TweetVimSay', 'TweetVimCommandSay']}

Plug 'cespare/vim-toml', { 'for': 'toml' }
Plug 'csscomb/vim-csscomb', { 'for': 'css' }
Plug 'gregsexton/MatchTag', {'for': ['html','xml']}
Plug 'othree/html5.vim', {'for': 'html'}
Plug 'mattn/emmet-vim', {'for': 'html'}
Plug 'pangloss/vim-javascript', {'for': 'javascript'}
Plug 'glidenote/memolist.vim', {'on':['MemoNew', 'MemoList']}

Plug 'kana/vim-submode'

Plug 'lervag/vimtex',{'for': ['tex']}
Plug 'osyo-manga/vim-precious'
Plug 'Shougo/context_filetype.vim'
Plug 'rdnetto/YCM-Generator',{'branch' : 'stable' ,'on': 'YcmGenerateConfig'}

if !has('nvim')
  Plug 'Valloric/YouCompleteMe'
endif
Plug 'tell-k/vim-autopep8',{'for': 'python'}
Plug 'itchyny/calendar.vim', {'on': 'Calendar'}
Plug 'majutsushi/tagbar'
Plug 'artur-shaik/vim-javacomplete2', {'for': 'java'}
Plug 'AndrewRadev/linediff.vim', {'on': 'Linediff'}

Plug 'osyo-manga/vim-watchdogs'

Plug 'haya14busa/vim-open-googletranslate', {'on': 'OpenGoogleTranslate'}
Plug 'mbbill/undotree', {'on': ['UndotreeFocus', 'UndotreeHide', 'UndotreeShow', 'UndotreeToggle']}
Plug 'octol/vim-cpp-enhanced-highlight', {'for': ['c','cpp']}
Plug 'mopp/next-alter.vim', {'for': ['c','cpp']}

call plug#end()

augroup _myplug
  autocmd!
  autocmd VimEnter * call PlugPostHook()
augroup END

fun PlugPostHook()
  for func in keys(g:plugin_mgr.func_dict)
    call g:plugin_mgr.posthook(func)
  endfor
endf

let &cpo = s:save_cpo
unlet s:save_cpo
