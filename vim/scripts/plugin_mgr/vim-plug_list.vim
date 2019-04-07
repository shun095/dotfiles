
let s:save_cpo = &cpo
set cpo&vim

if has('python3')
  let s:has_python3 = g:true
  py3 pass
else
  let s:has_python3 = g:false
endif

if has('python')
  let s:has_python = g:true
else
  let s:has_python = g:false
endif

let s:lazy_plugins = {}

function! s:lazy_plugin_register(plugin, event) abort
  if !has_key(s:lazy_plugins, a:event)
    let s:lazy_plugins[a:event] = []
  endif

  let name = split(a:plugin, '/')[-1]
  let s:lazy_plugins[a:event] = add(s:lazy_plugins[a:event], name)
  execute "Plug '" . a:plugin . "', {'on':[]}"
endfunction

function! s:on_insert_enter_load() abort
  if !has_key(s:lazy_plugins, 'InsertEnter')
    return
  endif
  for l:plug_name in s:lazy_plugins['InsertEnter']
    call plug#load(l:plug_name)
  endfor
endfunction

augroup myload_on_insert_enter
  autocmd!
  autocmd InsertEnter * 
        \ call s:on_insert_enter_load() | autocmd! myload_on_insert_enter
augroup END


" Color schemes
Plug 'rakr/vim-one'
let g:terminal_ansi_colors = [
      \ '#000000', '#e06c75', '#98c379', '#d19a66',
      \ '#61afef', '#c678dd', '#56b6c2', '#abb2bf',
      \ '#5c6370', '#e06c75', '#98c379', '#d19a66',
      \ '#61afef', '#c678dd', '#56b6c2', '#ffffff'
      \ ]

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
" Shougo wares
let s:use_shougo_ware = 0

if has('nvim')
  if s:has_python3
    if executable('python')
      let s:use_shougo_ware = system("python --version") =~# 'Python\ 3\.[6-9]'
    endif

    if !s:use_shougo_ware && executable('python3')
      let s:use_shougo_ware = system("python3 --version") =~# 'Python\ 3\.[6-9]'
    endif
  endif
endif

" if s:use_shougo_ware
if 0
  if has('nvim')
    Plug 'Shougo/denite.nvim', {'do':':UpdateRemotePlugins'}
    Plug 'Shougo/deoplete.nvim', {'do':':UpdateRemotePlugins'}
    Plug 'Shougo/defx.nvim', {'do':':UpdateRemotePlugins'}
    " Plug 'Shougo/deoplete-lsp'
    " call lsp#server#add('python', ['python', '-m', 'pyls'])
  else
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
    Plug 'Shougo/denite.nvim'
    Plug 'Shougo/deoplete.nvim'
    Plug 'Shougo/defx.nvim'
  endif
  Plug 'Shougo/context_filetype.vim'
  Plug 'Shougo/neomru.vim'
  " Plug 'Shougo/vimproc.vim'
  " if has('win32')
  "   Plug 'tbodt/deoplete-tabnine', { 'do': 'powershell.exe .\install.ps1' }
  " else
  "   Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }
  " endif

  if 0
    if has('win32')
      fun! DownloadLanguageClient(info)
        if a:info.status == 'installed' || a:info.status == 'updated' || a:info.force
          let l:confirm_install = confirm(
                \ 'LanguageClient updated. Install now?',
                \ "&yes\n&no", 2)
          if l:confirm_install == 1
            let l:cmd = ':exe ":!start powershell Start-Sleep -s 3; .\\install.ps1" | qa!'
            call mymisc#command_at_destdir(
                  \ g:plugin_mgr.plugin_dir."/LanguageClient-neovim",
                  \ [l:cmd])
          endif
        endif
      endf
      Plug 'autozimu/LanguageClient-neovim', {
            \ 'branch':'next',
            \ 'do':function('DownloadLanguageClient'),
            \ }
    else
      Plug 'autozimu/LanguageClient-neovim', {
            \ 'branch':'next',
            \ 'do':'bash install.sh',
            \ }
    endif
  endif
else
  " Plug 'Valloric/YouCompleteMe'
  " Plug 'rdnetto/YCM-Generator', {'on':'YcmGenerateConfig', 'branch':'stable'}
  " Plug 'ervandew/supertab'

  Plug 'ishitaku5522/asyncomplete.vim', {'branch':'close_popup_v2'}
  Plug 'prabirshrestha/async.vim'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
  Plug 'prabirshrestha/asyncomplete-file.vim'
  Plug 'prabirshrestha/asyncomplete-buffer.vim'
  Plug 'yami-beta/asyncomplete-omni.vim'
  Plug 'prabirshrestha/asyncomplete-necovim.vim'
  Plug 'prabirshrestha/asyncomplete-neosnippet.vim'

  Plug 'scrooloose/nerdtree'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
  Plug 'jistr/vim-nerdtree-tabs'
  Plug 'ishitaku5522/nerdtree-git-plugin'
  " Plug 'ryanoasis/vim-devicons'
  " Plug 'justinmk/vim-dirvish'
endif

" Language specific completions
Plug 'OmniSharp/omnisharp-vim', {'for':['cs']}
" Plug 'Rip-Rip/clang_complete', {'for':['c', 'cpp']} " for goto definition (completed by LC)
" Plug 'davidhalter/jedi-vim', {'for':['python']} " for goto definition (completed by LC)
" Plug 'zchee/deoplete-jedi', {'for':['python']} " for completion
" Plug 'carlitux/deoplete-ternjs', {'for':['javascript']}
" Plug 'zchee/deoplete-go', {'for':['go']}
Plug 'othree/csscomplete.vim'
Plug 'artur-shaik/vim-javacomplete2', {'for':['java']}
Plug 'Shougo/neco-vim' " for vim

" Snippets, templates
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
if s:has_python3 || s:has_python
  Plug 'SirVer/ultisnips'
endif
Plug 'honza/vim-snippets'
Plug 'mattn/sonictemplate-vim'
" Plug 'aperezdc/vim-template'

" General purpose completions, linters
Plug 'scrooloose/nerdcommenter'
Plug 'w0rp/ale'
" Plug 'gorodinskiy/vim-coloresque'
Plug 'chiel92/vim-autoformat', {'on':['Autoformat']}
Plug 'jiangmiao/auto-pairs'
" Plug 'Raimondi/delimitMate'
" Plug 'cohama/lexima.vim'

" Language/environment specific plugins
Plug 'lervag/vimtex', {'for':['tex']}
Plug 'iamcco/markdown-preview.vim', {'for':['markdown']}
Plug 'kannokanno/previm', {'for':['markdown']}
Plug 'jceb/vim-orgmode', {'for':['org']}
Plug 'OrangeT/vim-csharp', {'for':['cs', 'csi', 'csx']}
Plug 'fatih/vim-go', {'for':['go']}
Plug 'mattn/emmet-vim', {'for':['html', 'xml']}
Plug 'mopp/next-alter.vim', {'for':['c', 'cpp', 'vim']}
Plug 'Valloric/MatchTagAlways', {'for':['html', 'xml']}
Plug 'ishitaku5522/rosmake.vim', {'on':['Catkinmake', 'Rosmake']}
Plug 'alvan/vim-closetag', {'for': ['xml', 'html', 'xhtml', 'phtml']}

" Syntax highlights
Plug 'othree/html5.vim', {'for':['html']}
Plug 'digitaltoad/vim-pug', {'for':['pug', 'jade']}
Plug 'briancollins/vim-jst', {'for':['ejs', 'jst']}
Plug 'groenewege/vim-less', {'for':['less']}
Plug 'cakebaker/scss-syntax.vim', {'for':['scss']}
Plug 'wavded/vim-stylus', {'for':['stylus']}
Plug 'leafgarland/typescript-vim', {'for':['typescript']}
Plug 'pangloss/vim-javascript', {'for':['javascript']}
Plug 'posva/vim-vue', {'for':['vue']}
Plug 'elzr/vim-json', {'for':['json']}
Plug 'cespare/vim-toml', {'for':'toml'}
Plug 'tmux-plugins/vim-tmux', {'for':['tmux']}
Plug 'chr4/nginx.vim', {'for':['nginx']}
Plug 'pboettch/vim-cmake-syntax', {'for':['cmake']}
Plug 'octol/vim-cpp-enhanced-highlight', {'for':['c', 'cpp']}
" Plug 'hdima/python-syntax'

" General purpose viewers/indicators
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mattn/ctrlp-register'
Plug 'mattn/ctrlp-mark'
Plug 'FelikZ/ctrlp-py-matcher'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-peekaboo'
if has('win32')
  Plug 'ishitaku5522/cpsm'
else
  Plug 'nixprime/cpsm', {'do':'bash install.sh'}
endif

Plug 'mbbill/undotree', {'on':['UndotreeFocus', 'UndotreeHide', 'UndotreeShow', 'UndotreeToggle']}
Plug 'majutsushi/tagbar', {'on':['TagbarToggle', 'TagbarOpen']}
Plug 'AndrewRadev/linediff.vim', {'on':'Linediff'}
Plug 'Konfekt/FastFold'
Plug 'LeafCage/foldCC.vim'
Plug 'luochen1990/rainbow'
" Plug 'junegunn/rainbow_parentheses.vim'
" Plug 'kien/rainbow_parentheses.vim'
Plug 'google/vim-searchindex'
" Plug 'osyo-manga/vim-anzu'
Plug 'Yggdroot/indentLine'
" Plug 'nathanaelkane/vim-indent-guides'

" Git plugins
Plug 'lambdalisue/gina.vim'
Plug 'airblade/vim-gitgutter'

" General purpose motions
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
Plug 'deris/vim-shot-f'
Plug 'junegunn/vim-easy-align'
Plug 'kana/vim-submode'
Plug 'bkad/CamelCaseMotion'
Plug 'deton/jasegment.vim'

" Applications
Plug 'glidenote/memolist.vim', {'on':['MemoNew', 'MemoList']}
Plug 'itchyny/calendar.vim', {'on':'Calendar'}

" Tools
Plug 'thinca/vim-quickrun'
Plug 'lambdalisue/suda.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'tyru/open-browser.vim'
Plug 'haya14busa/vim-open-googletranslate', {'on':'OpenGoogleTranslate'}
Plug 'tyru/capture.vim'
if has('nvim') && has('win32')
  Plug 'pepo-le/win-ime-con.nvim'
  let g:win_ime_con_mode = 0
endif

" Libraries
Plug 'vim-jp/autofmt'
Plug 'vim-jp/vimdoc-ja'

Plug 'ishitaku5522/revimses', {'branch':'dev'}

let &cpo = s:save_cpo
unlet s:save_cpo
