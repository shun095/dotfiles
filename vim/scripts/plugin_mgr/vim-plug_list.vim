
let s:save_cpo = &cpo
set cpo&vim

" Force to use python3
call has('python3')

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
" Completers
" " deoplete completers
" Plug 'carlitux/deoplete-ternjs',{'for':['javascript']}
" Plug 'zchee/deoplete-go',{'for':['go']}

if v:version >= 800
  Plug 'Shougo/neomru.vim'
  "
  if has('nvim')
    Plug 'Shougo/denite.nvim',{'do':':UpdateRemotePlugins'}
    Plug 'Shougo/deoplete.nvim',{'do':':UpdateRemotePlugins'}
    " Plug 'Shougo/defx.nvim',{'do':':UpdateRemotePlugins'}
  else
    Plug 'Shougo/denite.nvim'
    Plug 'Shougo/deoplete.nvim'
    " Plug 'Shougo/defx.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif

  Plug 'OmniSharp/omnisharp-vim',{'for':['cs']}
  Plug 'Rip-Rip/clang_complete',{'for':['c','cpp']} " for goto definition (completed by LC)
  Plug 'davidhalter/jedi-vim',{'for':['python']} " for goto definition (completed by LC)
  " Plug 'zchee/deoplete-jedi',{'for':['python']} " for completion

  Plug 'othree/csscomplete.vim'
  Plug 'artur-shaik/vim-javacomplete2',{'for':'java'}

  if has('win32')
    Plug 'autozimu/LanguageClient-neovim',{'branch':'next','do':'powershell .\install.ps1'}
  else
    Plug 'autozimu/LanguageClient-neovim',{'branch':'next','do':'bash install.sh'}
  endif

  Plug 'Shougo/neosnippet.vim'
  Plug 'Shougo/neosnippet-snippets'
  Plug 'Shougo/context_filetype.vim'
else
  " Plug 'Valloric/YouCompleteMe'
  " Plug 'rdnetto/YCM-Generator',{'on':'YcmGenerateConfig','branch':'stable'}
endif

Plug 'lervag/vimtex',{'for':'tex'}
Plug 'iamcco/markdown-preview.vim',{'for':'markdown'}
Plug 'kannokanno/previm',{'for':'markdown'}
Plug 'OrangeT/vim-csharp',{'for':['cs','csi','csx']}

" Normal plugins
Plug 'Konfekt/FastFold'
Plug 'LeafCage/foldCC.vim'

" Plug 'SirVer/ultisnips'
" Plug 'ervandew/supertab'
Plug 'jiangmiao/auto-pairs'
" Plug 'raimondi/delimitmate'

" syntax files
Plug 'cakebaker/scss-syntax.vim'
Plug 'digitaltoad/vim-pug'
Plug 'groenewege/vim-less'
Plug 'kchmck/vim-coffee-script'
Plug 'leafgarland/typescript-vim'
Plug 'slm-lang/vim-slm'
Plug 'wavded/vim-stylus'
Plug 'pboettch/vim-cmake-syntax',{'for':['cmake']}
Plug 'chr4/nginx.vim',{'for':['nginx']}
Plug 'elzr/vim-json',{'for':['json']}
Plug 'octol/vim-cpp-enhanced-highlight',{'for':['c','cpp']}
Plug 'othree/html5.vim',{'for':['html']}
Plug 'pangloss/vim-javascript',{'for':['javascript']}
Plug 'posva/vim-vue',{'for':['vue']}
Plug 'tmux-plugins/vim-tmux',{'for':['tmux']}
Plug 'cespare/vim-toml',{'for':'toml'}
Plug 'briancollins/vim-jst'

Plug 'Valloric/MatchTagAlways'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'alvan/vim-closetag'
Plug 'aperezdc/vim-template'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mattn/ctrlp-register'
Plug 'FelikZ/ctrlp-py-matcher'
if has('win32')
  Plug 'ishitaku5522/cpsm'
else
  Plug 'nixprime/cpsm',{'do':'bash install.sh'}
endif

Plug 'easymotion/vim-easymotion'
Plug 'hdima/python-syntax'
Plug 'honza/vim-snippets'
Plug 'junegunn/gv.vim'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/rainbow_parentheses.vim'
" [[plugins]]
" repo = 'justinmk/vim-dirvish'
Plug 'kana/vim-submode'
" Plug 'luochen1990/rainbow'
" [[plugins]]
" repo = 'nixprime/cpsm'
" merged = 0

Plug 'thinca/vim-quickrun'
  Plug 'osyo-manga/shabadou.vim'

Plug 'osyo-manga/vim-anzu'
Plug 'scrooloose/nerdcommenter'

Plug 'scrooloose/nerdtree'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
  Plug 'jistr/vim-nerdtree-tabs'
" Plug 'justinmk/vim-dirvish'

Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'vim-jp/autofmt'
Plug 'vim-jp/vimdoc-ja'
Plug 'w0rp/ale'
" No mean lazy
" Plug 'basyura/bitly.vim'
" Plug 'basyura/twibill.vim'
" Must be loaded last
Plug 'ishitaku5522/rosmake.vim'
Plug 'ishitaku5522/vimailer.vim'
Plug 'ishitaku5522/revimses',{'branch':'dev'}

"Normal lazy plugins
Plug 'AndrewRadev/linediff.vim',{'on':'Linediff'}
Plug 'Shougo/vimproc.vim'
Plug 'bkad/CamelCaseMotion'
Plug 'chiel92/vim-autoformat',{'on':'Autoformat'}
Plug 'fatih/vim-go',{'for':['go']}
Plug 'glidenote/memolist.vim',{'on':['MemoNew','MemoList']}

Plug 'tyru/open-browser.vim'
  "",{'on':['OpenBrowser', 'OpenBrowserSearch', 'OpenBrowserSmartSearch']}
  Plug 'haya14busa/vim-open-googletranslate',{'on':'OpenGoogleTranslate'}
  " Plug 'basyura/TweetVim',{'on':['TweetVimHomeTimeline','TweetVimUserStream','TweetVimSay','TweetVimCommandSay']}

Plug 'itchyny/calendar.vim',{'on':'Calendar'}
Plug 'majutsushi/tagbar',{'on':['TagbarToggle','TagbarOpen']}
Plug 'mattn/emmet-vim',{'for':['html','xml']}
Plug 'mbbill/undotree',{'on':['UndotreeFocus','UndotreeHide','UndotreeShow','UndotreeToggle']}
Plug 'mopp/next-alter.vim',{'for':['c','cpp']}
Plug 'vim-jp/vital.vim',{'on':'Vitalize'}

let &cpo = s:save_cpo
unlet s:save_cpo
