
let s:save_cpo = &cpo
set cpo&vim

if exists('g:loaded_vim_plug_list')
  finish
endif
let g:loaded_vim_plug_list = 1

" Color schemes
Plug 'rakr/vim-one'
" Plug 'NLKNguyen/papercolor-theme'
" Plug 'cocopon/iceberg.vim'
" Plug 'tomasr/molokai'
" Plug 'jdkanani/vim-material-theme'
" Plug 'joshdick/onedark.vim'
" Plug 'ajh17/spacegray.vim'
" Plug 'lifepillar/vim-solarized8'
" Plug 'morhetz/gruvbox'
"
" Must be loaded first
" Plug 'itchyny/vim-cursorword'
" Completers
" If has nvim
if has('nvim')
  Plug 'Shougo/deoplete.nvim'
    " deoplete completers
    Plug 'Rip-Rip/clang_complete',{'for':['c', 'cpp', 'h', 'hpp'] }
    Plug 'carlitux/deoplete-ternjs',{'for':['javascript'] }
    Plug 'davidhalter/jedi-vim',{'for':['python'] }
    Plug 'zchee/deoplete-go',{'for':['go']  }
    Plug 'zchee/deoplete-jedi',{'for':['python'] }
else
  Plug 'Valloric/YouCompleteMe'
  " Plug 'roxma/nvim-yarp'
  " Plug 'roxma/vim-hug-neovim-rpc'
endif
" Normal plugins
if has('python3') || has('python')
  Plug 'FelikZ/ctrlp-py-matcher'
endif
Plug 'Konfekt/FastFold'
Plug 'LeafCage/foldCC.vim'

if v:version > 800
  Plug 'Shougo/denite.nvim'
    Plug 'Shougo/neomru.vim'
  " Plug 'Shougo/unite-outline'
endif

Plug 'SirVer/ultisnips'
Plug 'Valloric/MatchTagAlways'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'alvan/vim-closetag'
Plug 'aperezdc/vim-template'
Plug 'chr4/nginx.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'digitaltoad/vim-pug'
Plug 'easymotion/vim-easymotion'
Plug 'elzr/vim-json'
Plug 'ervandew/supertab'
Plug 'hdima/python-syntax'
Plug 'honza/vim-snippets'
Plug 'junegunn/gv.vim'
Plug 'junegunn/vim-easy-align'
" [[plugins]]
" repo = 'justinmk/vim-dirvish'
Plug 'kana/vim-submode'
Plug 'luochen1990/rainbow'
" [[plugins]]
" repo = 'nixprime/cpsm'
" merged = 0
Plug 'mattn/ctrlp-register'

Plug 'thinca/vim-quickrun'
  Plug 'osyo-manga/shabadou.vim'

Plug 'osyo-manga/vim-anzu'
Plug 'raimondi/delimitmate'
Plug 'scrooloose/nerdcommenter'

Plug 'scrooloose/nerdtree'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
  Plug 'jistr/vim-nerdtree-tabs'

Plug 'tmux-plugins/vim-tmux'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'vim-jp/autofmt'
Plug 'vim-jp/vimdoc-ja'
Plug 'w0rp/ale'
" No mean lazy
Plug 'basyura/bitly.vim'
Plug 'basyura/twibill.vim'
Plug 'briancollins/vim-jst'
Plug 'octol/vim-cpp-enhanced-highlight',{'for':['c','cpp']}
Plug 'othree/html5.vim',{'for':['html']}
Plug 'pangloss/vim-javascript',{'for':['javascript']}
" Must be loaded last
Plug 'ishitaku5522/rosmake.vim'
Plug 'ishitaku5522/vimailer.vim'
Plug 'ishitaku5522/revimses',{'branch':'dev'}

"Normal lazy plugins
Plug 'AndrewRadev/linediff.vim',{'on':'Linediff'}
Plug 'Shougo/vimproc.vim'
Plug 'artur-shaik/vim-javacomplete2',{'for':'java'}
Plug 'bkad/CamelCaseMotion'
Plug 'cespare/vim-toml',{'for':'toml'}
Plug 'chiel92/vim-autoformat',{'on':'Autoformat'}
Plug 'csscomb/vim-csscomb',{'for':'css'}
Plug 'fatih/vim-go',{'for':['go'] }
Plug 'glidenote/memolist.vim',{'on':['MemoNew','MemoList']}

Plug 'tyru/open-browser.vim'
  "",{'on':['OpenBrowser', 'OpenBrowserSearch', 'OpenBrowserSmartSearch']}
  Plug 'haya14busa/vim-open-googletranslate',{'on':'OpenGoogleTranslate'}
  Plug 'basyura/TweetVim',{'on':['TweetVimHomeTimeline','TweetVimUserStream','TweetVimSay','TweetVimCommandSay']}

Plug 'iamcco/markdown-preview.vim',{'for':'markdown'}
Plug 'itchyny/calendar.vim',{'on':'Calendar'}
Plug 'kannokanno/previm',{'for':'markdown'}
Plug 'lervag/vimtex',{'for':'tex'}
Plug 'majutsushi/tagbar',{'on':['TagbarToggle','TagbarOpen']}
Plug 'mattn/emmet-vim',{'for':['html','xml']}
Plug 'mbbill/undotree',{'on':['UndotreeFocus','UndotreeHide','UndotreeShow','UndotreeToggle']}
Plug 'mopp/next-alter.vim',{'for':['c','cpp']}
Plug 'OrangeT/vim-csharp',{'for':['cs','csi','csx']}
Plug 'rdnetto/YCM-Generator',{'on':'YcmGenerateConfig','branch':'stable'}
Plug 'tyru/restart.vim',{'on':'Restart'}
Plug 'vim-jp/vital.vim',{'on':'Vitalize'}

let &cpo = s:save_cpo
unlet s:save_cpo
