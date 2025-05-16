" vim: fdm=marker:
let s:save_cpo = &cpo
set cpo&vim

if g:myvimrc_has_python3
  let s:has_python3 = v:true
else
  let s:has_python3 = v:false
endif

let g:terminal_ansi_colors = [
      \ '#282c34', '#e06c75', '#98c379', '#d19a66',
      \ '#61afef', '#c678dd', '#56b6c2', '#abb2bf',
      \ '#5c6370', '#e06c75', '#98c379', '#d19a66',
      \ '#61afef', '#c678dd', '#56b6c2', '#ffffff'
      \ ]

execute "Plug '" . expand('$MYVIMHOME') . "'"

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
if !has('nvim')
  Plug 'cocopon/iceberg.vim'
endif
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
if !has('nvim')
  Plug 'Shougo/neosnippet.vim'
  Plug 'Shougo/neosnippet-snippets'
endif

if s:has_python3
  " Plug 'SirVer/ultisnips'
endif
Plug 'rafamadriz/friendly-snippets'
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

if !has('nvim')
  " --- asyncomplete ---
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  if s:has_python3
    " Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
  endif
  " Disabled because when I insert '//' on Windows, vim freezes.
  " Plug 'prabirshrestha/asyncomplete-file.vim'
  Plug 'shun095/asyncomplete-buffer.vim', {'branch': 'wip/japanese_completion'}
  " Plug 'shun095/asyncomplete-neosnippet.vim', {'branch': 'fix-behavior-on-zero-match'}
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
    " Plug 'thomasfaingnaert/vim-lsp-ultisnips'
  endif
  Plug 'rhysd/vim-healthcheck'
else
  " -- nvim native lsp & dap---
  Plug 'mfussenegger/nvim-dap'
  Plug 'mfussenegger/nvim-jdtls'
  Plug 'mfussenegger/nvim-dap-python'
  Plug 'jbyuki/one-small-step-for-vimkind'
  Plug 'jay-babu/mason-nvim-dap.nvim'
  Plug 'nvim-neotest/nvim-nio'
  Plug 'rcarriga/nvim-dap-ui'
  Plug 'theHamsta/nvim-dap-virtual-text'
  Plug 'jay-babu/mason-null-ls.nvim'
  Plug 'nvimtools/none-ls.nvim'
  Plug 'MysticalDevil/inlay-hints.nvim'
  Plug 'folke/neoconf.nvim'
  Plug 'folke/trouble.nvim'
  Plug 'stevearc/aerial.nvim'
  Plug 'm-demare/hlargs.nvim'

  Plug 'nvimdev/lspsaga.nvim'
  Plug 'kosayoda/nvim-lightbulb'
  " Plug 'ray-x/guihua.lua', {'do': 'cd lua/fzy && make' }
  " Plug 'ray-x/navigator.lua'

  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/cmp-calc'
  Plug 'hrsh7th/cmp-emoji'
  Plug 'hrsh7th/cmp-nvim-lsp-document-symbol'
  Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
  Plug 'hrsh7th/cmp-omni'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'dmitmel/cmp-cmdline-history'
  Plug 'teramako/cmp-cmdline-prompt.nvim'
  Plug 'uga-rosa/cmp-skkeleton'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'rcarriga/cmp-dap'
  " Plug 'quangnguyen30192/cmp-nvim-ultisnips'
  " Plug 'tzachar/cmp-ai'

  Plug 'onsails/lspkind.nvim'

  " Plug 'L3Mon4D3/LuaSnip'
  " Plug 'rafamadriz/friendly-snippets'
  " Plug 'saadparwaiz1/cmp_luasnip'

  " Plug 'karb94/neoscroll.nvim'
  " Plug 'folke/trouble.nvim'
  " Plug 'MunifTanjim/nui.nvim'
  Plug 'rcarriga/nvim-notify'
  Plug 'folke/noice.nvim'
  " Plug 'j-hui/fidget.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'LukasPietzschmann/telescope-tabs'
  Plug 'nvim-telescope/telescope-ui-select.nvim'
  Plug 'kevinhwang91/nvim-bqf'
  " Plug 'nvim-tree/nvim-web-devicons'
  " Plug 'vim-fall/fall.vim'
  " Plug 'petertriho/nvim-scrollbar'
  Plug 'kevinhwang91/nvim-hlslens'
  Plug 'andersevenrud/nvim_context_vt'
  " Plug 'stevearc/dressing.nvim'
  " Plug 'stevearc/conform.nvim'
  " Plug 'yetone/avante.nvim', { 'branch': 'main', 'do': 'make' }
endif

" --- coc.nvim ---
" Plug 'neoclide/coc.nvim', {'branch': 'release'}

" }}}

" === Debug Adapter Protocl === {{{
if !has('nvim')
  " Plug 'puremourning/vimspector'
endif
" }}}

" === Filer === {{{
" Plug 'scrooloose/nerdtree'
" Plug 'jistr/vim-nerdtree-tabs'
" Plug 'shun095/nerdtree-git-plugin'
" Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Plug 'ryanoasis/vim-devicons'
" Plug 'justinmk/vim-dirvish'

" if has('nvim')
  Plug 'nvim-neo-tree/neo-tree.nvim'
" else
  Plug 'lambdalisue/fern.vim'
  Plug 'lambdalisue/fern-hijack.vim'
  Plug 'lambdalisue/fern-git-status.vim'
  Plug 'lambdalisue/fern-ssh'
  Plug 'lambdalisue/nerdfont.vim'
  if has('nvim')
    Plug 'shun095/fern-renderer-web-devicons.nvim', { 'branch': 'use-web-devicons-color' }
  else
    Plug 'lambdalisue/fern-renderer-nerdfont.vim'
  endif
  Plug 'lambdalisue/vim-fern-comparator-lexical'
  Plug 'lambdalisue/vim-glyph-palette'
  Plug 'lambdalisue/vim-fern-bookmark'
  Plug 'lambdalisue/vim-fern-mapping-git'
  " Plug 'LumaKernel/fern-mapping-fzf.vim'
  Plug 'andykog/fern-highlight.vim'
  Plug 'yuki-yano/fern-preview.vim'
" endif

" Plug 'francoiscabrol/ranger.vim'

" Plug 'kristijanhusak/defx-git'
" }}}

" === Language specific completions === {{{
" Plug 'OmniSharp/omnisharp-vim', {'for': ['cs']}
" Plug 'Quramy/tsuquyomi', {'for': ['javascript', 'typescript']}
" Plug 'vim-scripts/dbext.vim', {'for': ['sql']}
" Plug 'tpope/vim-dadbod', {'for': ['sql']}
" Plug 'othree/csscomplete.vim', {'for': ['css']}
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
if has('nvim')
  Plug 'windwp/nvim-autopairs'
endif
" }}}

" === Language/environment specific plugins === {{{
" Plug 'shun095/rosmake.vim', {'on': ['Catkinmake', 'Rosmake']}
" Plug 'mopp/next-alter.vim', {'for': ['c', 'cpp', 'vim']}
" Plug 'OrangeT/vim-csharp', {'for': ['cs', 'csi', 'csx']}
if has('nvim')
else
  Plug 'chrisbra/csv.vim', {'for': ['csv']}
endif
" Plug 'fatih/vim-go', {'for': ['go']}
if !has('nvim')
  Plug 'alvan/vim-closetag', {'for': ['html', 'xml', 'xhtml', 'phtml']}
endif
Plug 'mattn/emmet-vim', {'for': ['html', 'xml']}
Plug 'Valloric/MatchTagAlways', {'for': ['html', 'xml']}
Plug 'kat0h/bufpreview.vim', { 'do': 'deno task prepare' }
if has('nvim')
  Plug 'ixru/nvim-markdown'
  Plug 'MeanderingProgrammer/render-markdown.nvim'
endif
Plug 'dhruvasagar/vim-table-mode', {'for': ['markdown']}
Plug 'mzlogin/vim-markdown-toc', {'for': ['markdown']}
Plug 'shinespark/vim-list2tree', {'for': ['markdown']}
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
if has('nvim')
  Plug 'sindrets/diffview.nvim'
endif
Plug 'Konfekt/FastFold'
Plug 'LeafCage/foldCC.vim'
if has('nvim')
  Plug 'nvim-lualine/lualine.nvim'
else
  Plug 'vim-airline/vim-airline'
endif
" Plug 'edkolev/tmuxline.vim'
Plug 'luochen1990/rainbow', {'on': ['RainbowToggle', 'RainbowToggleOff', 'RainbowToggleOn']}
" Plug 'junegunn/rainbow_parentheses.vim'
" Plug 'kien/rainbow_parentheses.vim'
" Plug 'google/vim-searchindex'
if !has('nvim')
  Plug 'Yggdroot/indentLine'
endif
" Plug 'nathanaelkane/vim-indent-guides'

" Git plugins
" Plug 'lambdalisue/gina.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'junegunn/gv.vim'
if has('nvim')
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'nacro90/numb.nvim'
  " Plug 'uga-rosa/ccc.nvim'
  Plug 'norcalli/nvim-colorizer.lua'
else
  Plug 'airblade/vim-gitgutter'
endif
" Plug 'iberianpig/tig-explorer.vim'

" General purpose motions
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

if has('nvim')
  Plug 'monaqa/dial.nvim'
endif

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
if has('nvim')
  " Plug 'willothy/flatten.nvim'
  Plug 'akinsho/toggleterm.nvim'
  " Plug 'neo451/feed.nvim'
endif
" Non lazy load for QuickRun with pandoc
Plug 'thinca/vim-quickrun'
if has('nvim')
  " Plug 'michaelb/sniprun', { 'do': 'sh ./install.sh' }
  Plug 'lambdalisue/vim-quickrun-neovim-job'
endif
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

Plug 'christoomey/vim-tmux-navigator'

" Libraries
Plug 'vim-denops/denops.vim'
Plug 'vim-denops/denops-helloworld.vim'
Plug 'vim-denops/denops-shared-server.vim'

Plug 'vim-jp/autofmt'
Plug 'vim-jp/vimdoc-ja'
" Plug 'haya14busa/vim-migemo'
Plug 'junegunn/vader.vim'
Plug 'thinca/vim-themis'

" To update Vital, run :Vitalize $MYDOTFILES/vim
Plug 'vim-jp/vital.vim'
Plug 'lambdalisue/vital-Whisky'

Plug 'dstein64/vim-startuptime'
if has('nvim')
  " Plug 'stevearc/profile.nvim'
endif
Plug 'vim-skk/skkeleton'

Plug 'shun095/revimses'

let &cpo = s:save_cpo
unlet s:save_cpo
