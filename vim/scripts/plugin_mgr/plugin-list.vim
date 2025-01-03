" vim: fdm=marker:
let s:save_cpo = &cpo
set cpo&vim

if g:myvimrc_has_python3
  let s:has_python3 = g:true
else
  let s:has_python3 = g:false
endif

let g:terminal_ansi_colors = [
      \ '#282c34', '#e06c75', '#98c379', '#d19a66',
      \ '#61afef', '#c678dd', '#56b6c2', '#abb2bf',
      \ '#5c6370', '#e06c75', '#98c379', '#d19a66',
      \ '#61afef', '#c678dd', '#56b6c2', '#ffffff'
      \ ]

" Plug 'roxma/nvim-yarp'
" Plug 'roxma/vim-hug-neovim-rpc'
" Plug 'Shougo/defx.nvim'

" === Color schemes === {{{
" Plug 'rakr/vim-one'
" Plug 'morhetz/gruvbox'
" Plug 'joshdick/onedark.vim'
" Plug 'arcticicestudio/nord-vim'
" Plug 'NLKNguyen/papercolor-theme'
" Plug 'ajh17/spacegray.vim'
Plug 'cocopon/iceberg.vim'
" Plug 'jdkanani/vim-material-theme'
" Plug 'jonathanfilip/vim-lucius'
" Plug 'joshdick/onedark.vim'
" Plug 'lifepillar/vim-solarized8'
" Plug 'morhetz/gruvbox'
" Plug 'reedes/vim-colors-pencil'
" Plug 'tomasr/molokai'
" Plug 'altercation/vim-colors-solarized'
" }}}

" === Snippets, templates === {{{
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
if s:has_python3
  Plug 'SirVer/ultisnips'
endif
Plug 'honza/vim-snippets'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

Plug 'mattn/sonictemplate-vim'
" Plug 'aperezdc/vim-template'
" }}}

" === Completion === {{{
" --- deoplete ---
" Plug 'Shougo/deoplete.nvim'
" Plug 'Shougo/deoplete-lsp'
" call lsp#server#add('python', ['python', '-m', 'pyls'])
" Plug 'Shougo/context_filetype.vim'
" Plug 'Shougo/neomru.vim'

" --- YCM ---
" Plug 'Valloric/YouCompleteMe', {'do':'./install.py --clang-completer'}
" Plug 'rdnetto/YCM-Generator', {'on':'YcmGenerateConfig', 'branch':'stable'}
" Plug 'ervandew/supertab'

" --- TabNine ---
" Plug 'zxqfl/tabnine-vim'
" if has('win32')
"   Plug 'tbodt/deoplete-tabnine', { 'do': 'powershell.exe .\install.ps1' }
" else
"   Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }
" endif

" --- asyncomplete ---
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
if s:has_python3
  Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
endif
" Disabled because when I insert '//' on Windows, vim freezes.
" Plug 'prabirshrestha/asyncomplete-file.vim'
Plug 'shun095/asyncomplete-buffer.vim', {'branch': 'wip/japanese_completion'}
Plug 'shun095/asyncomplete-neosnippet.vim', {'branch': 'fix-behavior-on-zero-match'}
" Plug 'prabirshrestha/asyncomplete-necovim.vim'
" Plug 'shun095/asyncomplete-omni.vim'
" Plug 'shun095/asyncomplete-tsuquyomi.vim'

" --- ddc ---
" Plug 'Shougo/ddc.vim'
" Plug 'Shougo/ddc-ui-native'

" Plug 'LumaKernel/ddc-source-file'
" Plug 'shun095/ddc-source-vim-lsp', {'branch': 'fix/fix-completion-offset'}
" Plug 'Shougo/ddc-source-around'
" Plug 'matsui54/ddc-ultisnips'
" " Plug 'tani/ddc-fuzzy'
" Plug 'Shougo/ddc-matcher_head'
" Plug 'Shougo/ddc-sorter_rank'
" Plug 'uga-rosa/ddc-source-vsnip'

" --- vim-lsp ---
Plug 'prabirshrestha/vim-lsp'
" Plug 'shun095/vim-lsp', {'branch': 'javaApplyWorkspace'}
Plug 'mattn/vim-lsp-settings'
if s:has_python3
  Plug 'thomasfaingnaert/vim-lsp-snippets'
  Plug 'thomasfaingnaert/vim-lsp-ultisnips'
endif
if !has('nvim')
    Plug 'rhysd/vim-healthcheck'
endif

" --- coc.nvim ---
" Plug 'neoclide/coc.nvim', {'branch': 'release'}

" }}}

" === Debug Adapter Protocl === {{{
Plug 'puremourning/vimspector'
" }}}

" === Filer === {{{
" Plug 'scrooloose/nerdtree'
" Plug 'jistr/vim-nerdtree-tabs'
" Plug 'shun095/nerdtree-git-plugin'
" Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Plug 'ryanoasis/vim-devicons'
" Plug 'justinmk/vim-dirvish'

Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-hijack.vim'
Plug 'lambdalisue/fern-git-status.vim'
Plug 'lambdalisue/fern-ssh'
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'lambdalisue/vim-fern-comparator-lexical'
Plug 'yuki-yano/fern-preview.vim'

" Plug 'francoiscabrol/ranger.vim'

" Plug 'kristijanhusak/defx-git'
" }}}

" === Language specific completions === {{{
Plug 'OmniSharp/omnisharp-vim', {'for': ['cs']}
" Plug 'Quramy/tsuquyomi', {'for': ['javascript', 'typescript']}
Plug 'vim-scripts/dbext.vim', {'for': ['sql']}
Plug 'tpope/vim-dadbod', {'for': ['sql']}
Plug 'othree/csscomplete.vim', {'for': ['css']}
" for vimscript
" Plug 'Shougo/neco-vim'
" }}}


" === General purpose completions, linters === {{{
Plug 'scrooloose/nerdcommenter'
" Plug 'w0rp/ale'
" Color preview
" Plug 'gorodinskiy/vim-coloresque'
" }}}

" === Auto pair brackets === {{{
" Plug 'jiangmiao/auto-pairs'
" Plug 'Raimondi/delimitMate'
" Plug 'cohama/lexima.vim'
" Plug 'higashi000/dps-kakkonan'
" }}}

" === Language/environment specific plugins === {{{
Plug 'shun095/rosmake.vim', {'on': ['Catkinmake', 'Rosmake']}
Plug 'mopp/next-alter.vim', {'for': ['c', 'cpp', 'vim']}
Plug 'OrangeT/vim-csharp', {'for': ['cs', 'csi', 'csx']}
Plug 'chrisbra/csv.vim', {'for': ['csv']}
" Plug 'fatih/vim-go', {'for': ['go']}
Plug 'alvan/vim-closetag', {'for': ['html', 'xml', 'xhtml', 'phtml']}
Plug 'mattn/emmet-vim', {'for': ['html', 'xml']}
Plug 'Valloric/MatchTagAlways', {'for': ['html', 'xml']}
Plug 'iamcco/markdown-preview.nvim', {'do': 'cd app & yarn install', 'for': ['markdown']}
Plug 'dhruvasagar/vim-table-mode', {'for': ['markdown']}
Plug 'mzlogin/vim-markdown-toc', {'for': ['markdown']}
Plug 'kannokanno/previm', {'for': ['markdown']}
Plug 'jceb/vim-orgmode', {'for': ['org']}
Plug 'weirongxu/plantuml-previewer.vim', {'for': ['plantuml'], 'on': ['PlantumlOpen', 'PlantumlSave', 'PlantumlStop']}
Plug 'lambdalisue/vim-pyenv', {'for': ['python']}
"Plug 'lervag/vimtex', {'for': ['tex']}
" }}}

" === Syntax highlights === {{{
" Plug 'vim-scripts/bash-support.vim', {'for': ['bash']}
Plug 'octol/vim-cpp-enhanced-highlight', {'for': ['c', 'cpp']}
Plug 'pboettch/vim-cmake-syntax', {'for': ['cmake']}
Plug 'briancollins/vim-jst', {'for': ['ejs', 'jst']}
Plug 'othree/html5.vim', {'for': ['html']}
" Plug 'pangloss/vim-javascript', {'for': ['javascript']}
Plug 'elzr/vim-json', {'for': ['json']}
Plug 'groenewege/vim-less', {'for': ['less']}
Plug 'chr4/nginx.vim', {'for': ['nginx']}
Plug 'aklt/plantuml-syntax', {'for': ['plantuml']}
Plug 'pprovost/vim-ps1', {'for': ['ps1']}
Plug 'digitaltoad/vim-pug', {'for': ['pug', 'jade']}
" Plug 'hdima/python-syntax', {'for': ['python']}
Plug 'cakebaker/scss-syntax.vim', {'for': ['scss']}
Plug 'wavded/vim-stylus', {'for': ['stylus']}
Plug 'tmux-plugins/vim-tmux', {'for': ['tmux']}
Plug 'cespare/vim-toml', {'for': ['toml']}
Plug 'leafgarland/typescript-vim', {'for': ['typescript']}
Plug 'vim-jp/syntax-vim-ex', {'for': ['vim']}
Plug 'posva/vim-vue', {'for': ['vue']}
" }}}

" === General purpose viewers/indicators {{{
Plug 'ctrlpvim/ctrlp.vim'
"/ ,{'on':['CtrlP','CtrlPTag','CtrlPLine','CtrlPBuffer','CtrlPCurWD','CtrlP','CtrlPLine','CtrlPBufTag','CtrlPRegister','CtrlPOldFiles','CtrlPMark','CtrlP','CtrlPTag','CtrlPLine','CtrlPBuffer','CtrlPCurWD','CtrlP','CtrlPLine','CtrlPBufTag','CtrlPRegister','CtrlPOldFiles','CtrlPMark']}
Plug 'mattn/ctrlp-register'
Plug 'mattn/ctrlp-mark'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf' }

if exists('*matchfuzzy')
  Plug 'mattn/ctrlp-matchfuzzy'
else
  Plug 'FelikZ/ctrlp-py-matcher'
endif
" }}}

" Plug 'Shougo/ddu.vim'
" Plug 'Shougo/ddu-ui-ff'
" Plug 'Shougo/ddu-ui-filer'
" Plug 'Shougo/ddu-source-file'
" " Plug 'Shougo/ddu-source-file_rec'
" " Plug 'shun/ddu-source-rg'
" " Plug 'shun/ddu-source-buffer'
" " Plug 'Shougo/ddu-source-line'
" " Plug 'Shougo/ddu-source-register'
" Plug 'yuki-yano/ddu-filter-fzf'
" Plug 'Shougo/ddu-kind-file'
" " Plug 'Shougo/ddu-kind-word'
" " Plug 'Shougo/ddu-column-filename'
" " Plug 'ryota2357/ddu-column-icon_filename'
" Plug 'xecua/ddu-filter-sorter_treefirst'
" Plug 'tamago3keran/ddu-column-devicon_filename'
" Plug 'kamecha/ddu-column-custom'
" A
" Plug 'Shougo/ddu-commands.vim'


" Plug 'Shougo/denite.nvim'

" 矩形選択での^R"ペーストで複数行一括で挿入できなくなるためDisable
" Plug 'junegunn/vim-peekaboo'

" if has('win32')
"   Plug 'shun095/cpsm'
" else
"   Plug 'nixprime/cpsm', {'do': './install.sh'}
" endif
" Plug 'FelikZ/ctrlp-py-matcher'

Plug 'mbbill/undotree', {'on': ['UndotreeFocus', 'UndotreeHide', 'UndotreeShow', 'UndotreeToggle']}
Plug 'majutsushi/tagbar', {'on': ['TagbarToggle', 'TagbarOpen']}
Plug 'AndrewRadev/linediff.vim', {'on': ['Linediff']}
Plug 'Konfekt/FastFold'
Plug 'LeafCage/foldCC.vim'
Plug 'vim-airline/vim-airline'
Plug 'luochen1990/rainbow', {'on': ['RainbowToggle', 'RainbowToggleOff', 'RainbowToggleOn']}
" Plug 'junegunn/rainbow_parentheses.vim'
" Plug 'kien/rainbow_parentheses.vim'
Plug 'google/vim-searchindex'
Plug 'Yggdroot/indentLine'
" Plug 'nathanaelkane/vim-indent-guides'

" Git plugins
" Plug 'lambdalisue/gina.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'junegunn/gv.vim'
Plug 'airblade/vim-gitgutter'
" Plug 'iberianpig/tig-explorer.vim'

" General purpose motions
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
Plug 'deris/vim-shot-f'
Plug 'junegunn/vim-easy-align'
" Plug 'kana/vim-submode'
Plug 'bkad/CamelCaseMotion'
Plug 'deton/jasegment.vim'

" Applications
Plug 'glidenote/memolist.vim' ", {'on': ['MemoNew', 'MemoList']}
Plug 'itchyny/calendar.vim', {'on':'Calendar'}
Plug 'freitass/todo.txt-vim'

" Tools
if has('vimscript-3')
  Plug 'kyoh86/vim-editerm'
endif
" Non lazy load for QuickRun with pandoc
Plug 'thinca/vim-quickrun'
" Plug 'lambdalisue/suda.vim'
Plug 'editorconfig/editorconfig-vim'

Plug 'tyru/open-browser.vim'
Plug 'haya14busa/vim-open-googletranslate', {'on':'OpenGoogleTranslate'}
Plug 'tyru/capture.vim', {'on':'Capture'}

if has('nvim') && has('win32')
  " Auto change IME on windows for nvim
  Plug 'pepo-le/win-ime-con.nvim'
  let g:win_ime_con_mode = 0
endif

" Libraries
Plug 'vim-denops/denops.vim'
Plug 'vim-denops/denops-helloworld.vim'

Plug 'vim-jp/autofmt'
Plug 'vim-jp/vimdoc-ja'
" Plug 'haya14busa/vim-migemo'
Plug 'junegunn/vader.vim'
Plug 'thinca/vim-themis'

" To update Vital, run :Vitalize $MYDOTFILES/vim
Plug 'vim-jp/vital.vim'
Plug 'lambdalisue/vital-Whisky'

Plug 'dstein64/vim-startuptime'
Plug 'vim-skk/skkeleton'

Plug 'shun095/revimses'

let &cpo = s:save_cpo
unlet s:save_cpo
