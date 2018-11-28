
let s:save_cpo = &cpo
set cpo&vim

py3 pass

" Color schemes
Plug 'rakr/vim-one'
" Plug 'NLKNguyen/papercolor-theme'
" Plug 'ajh17/spacegray.vim'
" Plug 'cocopon/iceberg.vim'
" Plug 'jdkanani/vim-material-theme'
" Plug 'jonathanfilip/vim-lucius'
" Plug 'joshdick/onedark.vim'
" Plug 'lifepillar/vim-solarized8'
" Plug 'morhetz/gruvbox'
" Plug 'reedes/vim-colors-pencil'
" Plug 'tomasr/molokai'
"
" File explorers
" Plug 'scrooloose/nerdtree'
" Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" Plug 'jistr/vim-nerdtree-tabs'
" Plug 'justinmk/vim-dirvish'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mattn/ctrlp-register'
Plug 'FelikZ/ctrlp-py-matcher'
if has('win32')
  Plug 'ishitaku5522/cpsm'
else
  Plug 'nixprime/cpsm',{'do':'bash install.sh'}
endif

" Shougo wares
if v:version >= 800
  if has('nvim')
    " Plug 'Shougo/denite.nvim',{'do':':UpdateRemotePlugins'}
    " Plug 'Shougo/deoplete.nvim',{'do':':UpdateRemotePlugins'}
    " Plug 'Shougo/defx.nvim',{'do':':UpdateRemotePlugins'}
    Plug 'lambdalisue/suda.vim'
  else
    " Plug 'roxma/nvim-yarp'
    " Plug 'roxma/vim-hug-neovim-rpc'
    " Plug 'Shougo/denite.nvim'
    " Plug 'Shougo/deoplete.nvim'
    " Plug 'Shougo/defx.nvim'
  endif
endif

" Plug 'Shougo/neomru.vim'
" Plug 'Shougo/context_filetype.vim'
Plug 'Shougo/vimproc.vim'

" Language specific completions
Plug 'OmniSharp/omnisharp-vim',{'for':['cs']}
Plug 'Rip-Rip/clang_complete',{'for':['c','cpp']} " for goto definition (completed by LC)
Plug 'davidhalter/jedi-vim',{'for':['python']} " for goto definition (completed by LC)
" Plug 'zchee/deoplete-jedi',{'for':['python']} " for completion
" Plug 'carlitux/deoplete-ternjs',{'for':['javascript']}
" Plug 'zchee/deoplete-go',{'for':['go']}
Plug 'othree/csscomplete.vim'
Plug 'artur-shaik/vim-javacomplete2',{'for':'java'}
" if has('win32')
"   fun! DownloadLanguageClient(info)
"     if a:info.status == 'installed' || a:info.status == 'updated' || a:info.force
"       let l:confirm_install = confirm(
"             \ 'LanguageClient updated. Install now?',
"             \ "&yes\n&no",2)
"       if l:confirm_install == 1
"         let l:cmd = ':exe ":!start powershell Start-Sleep -s 3; .\\install.ps1" | qa!'
"         call mymisc#command_at_destdir(
"               \ g:plugin_mgr.plugin_dir."/LanguageClient-neovim",
"               \ [l:cmd])
"       endif
"     endif
"   endf
"   Plug 'autozimu/LanguageClient-neovim', {
"         \ 'branch': 'next',
"         \ 'do': function('DownloadLanguageClient'),
"         \ }
" else
"   Plug 'autozimu/LanguageClient-neovim', {
"         \ 'branch': 'next',
"         \ 'do': 'bash install.sh',
"         \ }
" endif
Plug 'Valloric/YouCompleteMe'
Plug 'rdnetto/YCM-Generator',{'on':'YcmGenerateConfig','branch':'stable'}
Plug 'ervandew/supertab'

Plug 'scrooloose/nerdtree'

" Snippets, templates
" Plug 'Shougo/neosnippet.vim'
" Plug 'Shougo/neosnippet-snippets'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'aperezdc/vim-template'

" General purpose completions,linters
Plug 'jiangmiao/auto-pairs'
" Plug 'cohama/lexima.vim'
Plug 'alvan/vim-closetag'
Plug 'scrooloose/nerdcommenter'
Plug 'w0rp/ale'
" Plug 'chiel92/vim-autoformat',{'on':'Autoformat'}

" Language/environment specific plugins
Plug 'lervag/vimtex',{'for':'tex'}
Plug 'iamcco/markdown-preview.vim',{'for':'markdown'}
Plug 'kannokanno/previm',{'for':'markdown'}
Plug 'jceb/vim-orgmode',{'for':'org'}
Plug 'OrangeT/vim-csharp',{'for':['cs','csi','csx']}
Plug 'fatih/vim-go',{'for':['go']}
Plug 'mattn/emmet-vim',{'for':['html','xml']}
Plug 'mopp/next-alter.vim',{'for':['c','cpp','vim']}
Plug 'ishitaku5522/rosmake.vim'

" Syntax highlights
Plug 'othree/html5.vim',{'for':['html']}
Plug 'digitaltoad/vim-pug'
Plug 'briancollins/vim-jst' " Ejs
Plug 'groenewege/vim-less'
Plug 'cakebaker/scss-syntax.vim'
Plug 'leafgarland/typescript-vim'
Plug 'pangloss/vim-javascript',{'for':['javascript']}
Plug 'posva/vim-vue',{'for':['vue']}
Plug 'wavded/vim-stylus'
Plug 'elzr/vim-json',{'for':['json']}
Plug 'cespare/vim-toml',{'for':'toml'}
Plug 'tmux-plugins/vim-tmux',{'for':['tmux']}
Plug 'chr4/nginx.vim',{'for':['nginx']}
Plug 'pboettch/vim-cmake-syntax',{'for':['cmake']}
Plug 'octol/vim-cpp-enhanced-highlight',{'for':['c','cpp']}
" Plug 'hdima/python-syntax'

" General purpose viewers/indicators
Plug 'mbbill/undotree',{'on':['UndotreeFocus','UndotreeHide','UndotreeShow','UndotreeToggle']}
Plug 'majutsushi/tagbar',{'on':['TagbarToggle','TagbarOpen']}
Plug 'AndrewRadev/linediff.vim',{'on':'Linediff'}
Plug 'Konfekt/FastFold'
Plug 'LeafCage/foldCC.vim'
Plug 'Valloric/MatchTagAlways'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'osyo-manga/vim-anzu'
Plug 'Yggdroot/indentLine'
" Plug 'nathanaelkane/vim-indent-guides'

" Git plugins
" Plug 'tpope/vim-fugitive'
" Plug 'tpope/vim-rhubarb'
Plug 'lambdalisue/gina.vim'
" Plug 'jreybert/vimagit'
" Plug 'junegunn/gv.vim'
Plug 'airblade/vim-gitgutter'
" Plug 'tpope/vim-dispatch'

" General purpose motions
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
Plug 'deris/vim-shot-f'
Plug 'junegunn/vim-easy-align'
Plug 'kana/vim-submode'
Plug 'bkad/CamelCaseMotion'

" Applications
Plug 'glidenote/memolist.vim',{'on':['MemoNew','MemoList']}
Plug 'itchyny/calendar.vim',{'on':'Calendar'}
Plug 'tyru/open-browser.vim'
Plug 'haya14busa/vim-open-googletranslate',{'on':'OpenGoogleTranslate'}

" Libraries
Plug 'vim-jp/vital.vim',{'on':'Vitalize'}
Plug 'vim-jp/autofmt'
Plug 'vim-jp/vimdoc-ja'

Plug 'ishitaku5522/revimses',{'branch':'dev'}

let &cpo = s:save_cpo
unlet s:save_cpo
