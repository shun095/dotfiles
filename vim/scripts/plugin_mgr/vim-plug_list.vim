
let s:save_cpo = &cpo
set cpo&vim

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
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
  if has('nvim')
    Plug 'Shougo/denite.nvim',{'do':':UpdateRemotePlugins'}
    Plug 'Shougo/deoplete.nvim',{'do':':UpdateRemotePlugins'}
    " Plug 'Shougo/defx.nvim',{'do':':UpdateRemotePlugins'}
  else
    Plug 'Shougo/denite.nvim'
    Plug 'Shougo/deoplete.nvim'
    " Plug 'Shougo/defx.nvim'
  endif
  Plug 'Shougo/neomru.vim'

  Plug 'OmniSharp/omnisharp-vim',{'for':['cs']}
  Plug 'Rip-Rip/clang_complete',{'for':['c','cpp']} " for goto definition (completed by LC)
  Plug 'davidhalter/jedi-vim',{'for':['python']} " for goto definition (completed by LC)
  " Plug 'zchee/deoplete-jedi',{'for':['python']} " for completion

  Plug 'othree/csscomplete.vim'
  Plug 'artur-shaik/vim-javacomplete2',{'for':'java'}

  if has('win32')
    Plug 'autozimu/LanguageClient-neovim', {
          \ 'branch': 'next',
          \ }
  else
    Plug 'autozimu/LanguageClient-neovim', {
          \ 'branch': 'next',
          \ 'do': 'bash install.sh',
          \ }
  endif

  Plug 'Shougo/neosnippet.vim'
  Plug 'Shougo/neosnippet-snippets'
  Plug 'Shougo/context_filetype.vim'

  " Plug 'Valloric/YouCompleteMe'
  " Plug 'rdnetto/YCM-Generator',{'on':'YcmGenerateConfig','branch':'stable'}
  " Plug 'ervandew/supertab'
  " Plug 'SirVer/ultisnips'
endif

Plug 'lervag/vimtex',{'for':'tex'}
Plug 'iamcco/markdown-preview.vim',{'for':'markdown'}
Plug 'kannokanno/previm',{'for':'markdown'}
Plug 'OrangeT/vim-csharp',{'for':['cs','csi','csx']}
Plug 'fatih/vim-go',{'for':['go']}
Plug 'mattn/emmet-vim',{'for':['html','xml']}

Plug 'ishitaku5522/rosmake.vim'
Plug 'mopp/next-alter.vim',{'for':['c','cpp','vim']}

Plug 'chiel92/vim-autoformat',{'on':'Autoformat'}

" Normal plugins
Plug 'Konfekt/FastFold'
Plug 'LeafCage/foldCC.vim'

Plug 'jiangmiao/auto-pairs'

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
" Plug 'Yggdroot/indentLine'
Plug 'nathanaelkane/vim-indent-guides'
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
Plug 'kana/vim-submode'

" Plug 'thinca/vim-quickrun'
"   Plug 'osyo-manga/shabadou.vim'

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
" Plug 'ishitaku5522/vimailer.vim'

"Normal lazy plugins
Plug 'AndrewRadev/linediff.vim',{'on':'Linediff'}
Plug 'bkad/CamelCaseMotion'
Plug 'mbbill/undotree',{'on':['UndotreeFocus','UndotreeHide','UndotreeShow','UndotreeToggle']}


Plug 'majutsushi/tagbar',{'on':['TagbarToggle','TagbarOpen']}

Plug 'glidenote/memolist.vim',{'on':['MemoNew','MemoList']}
Plug 'itchyny/calendar.vim',{'on':'Calendar'}
Plug 'tyru/open-browser.vim'
Plug 'haya14busa/vim-open-googletranslate',{'on':'OpenGoogleTranslate'}

Plug 'Shougo/vimproc.vim'
Plug 'vim-jp/vital.vim',{'on':'Vitalize'}

Plug 'ishitaku5522/revimses',{'branch':'dev'}

let &cpo = s:save_cpo
unlet s:save_cpo
