
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
Plug 'tyru/open-browser.vim'
Plug 'tyru/restart.vim'
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
Plug 'gregsexton/MatchTag'
Plug 'othree/html5.vim'
Plug 'mattn/emmet-vim'
Plug 'pangloss/vim-javascript'
Plug 'glidenote/memolist.vim'

Plug 'kana/vim-submode'

Plug 'lervag/vimtex'
Plug 'osyo-manga/vim-precious'
Plug 'Shougo/context_filetype.vim'
Plug 'rdnetto/YCM-Generator'
Plug 'Valloric/YouCompleteMe'
Plug 'tell-k/vim-autopep8'
Plug 'itchyny/calendar.vim'
Plug 'majutsushi/tagbar'
Plug 'artur-shaik/vim-javacomplete2'
Plug 'AndrewRadev/linediff.vim'

Plug 'osyo-manga/vim-watchdogs'

Plug 'haya14busa/vim-open-googletranslate'
Plug 'mbbill/undotree'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'mopp/next-alter.vim'

call plug#end()

augroup _myplug
  autocmd!
  autocmd VimEnter * call PlugPostHook()
augroup END

fun! PlugPostHook()
  call submode#enter_with('winsize', 'n', '', '<C-w>>', '<C-w>>')
  call submode#enter_with('winsize', 'n', '', '<C-w><', '<C-w><')
  call submode#enter_with('winsize', 'n', '', '<C-w>+', '<C-w>+')
  call submode#enter_with('winsize', 'n', '', '<C-w>-', '<C-w>-')
  call submode#map('winsize', 'n', '', '>', '5<C-w>>')
  call submode#map('winsize', 'n', '', '<', '5<C-w><')
  call submode#map('winsize', 'n', '', '+', '5<C-w>+')
  call submode#map('winsize', 'n', '', '-', '5<C-w>-')

  " watchdogs settings
  let g:watchdogs_check_BufWritePost_enable = 1
  let g:watchdogs_check_BufWritePost_enables = {
        \ 'cpp' : 0,
        \ 'java': 0
        \}
  let g:watchdogs_check_CursorHold_enable = 0

  let s:watchdogs_config = {
        \   'watchdogs_checker/_' : {
        \     'runner' : 'vimproc',
        \     'runner/vimproc/updatetime' : 100,
        \     'outputter' : 'quickfix',
        \     'outputter/quickfix/open_cmd' : 'copen 8'
        \   },
        \   'watchdogs_checker/javac' : {
        \   },
        \   'cpp/watchdogs_checker' : {
        \     'type' : 'watchdogs_checker/g++',
        \     'hook/add_include_option/enable' : 1,
        \     'cmdopt' : '-std=c++11 -Wall'
        \   }
        \ }

  if has('job')
    call extend(s:watchdogs_config['watchdogs_checker/_'], {
          \ 'runner' : 'job',
          \ 'runner/job/interval' : 100,
          \ })
  endif
  call extend(g:quickrun_config, s:watchdogs_config)

  let s:watchdogs_config_javac={
        \ 'exec' : '%c %o -d %S:p:h %S:p'
        \ }
  call extend(g:quickrun_config['watchdogs_checker/javac'], s:watchdogs_config_javac)

  unlet s:watchdogs_config
  try
    call watchdogs#setup(g:quickrun_config)
  catch
    echom v:exception
  endtry
  call camelcasemotion#CreateMotionMappings(',')

  " call lexima#add_rule({'char': '<', 'input_after': '>'})
  call lexima#add_rule({'char': '>', 'at': '\%#>', 'leave': 1})
  call lexima#add_rule({'char': '<BS>', 'at': '<\%#>', 'input': '<BS>', 'delete' : 1})

  for [begin, end] in [['(', ')'], ['{','}'], ['[',']']]
    call lexima#add_rule({'at': '\%#.*[-0-9a-zA-Z_,:]', 'char': begin, 'input': begin})
    call lexima#add_rule({'at': '\%#\n\s*'.end , 'char': end, 'input': '<CR>'.end, 'delete': end})
  endfor

  for mark in ['"', "'"]
    call lexima#add_rule({'at': '\%#.*[-0-9a-zA-Z_,:]', 'char': mark, 'input': mark})
  endfor

  call lexima#init()
  " <BS>,<CR>が文字列ではなく展開されてしまうためうまくいかないので<lt>を利用
  inoremap <silent><expr> <C-h> lexima#expand('<lt>BS>', 'i')
  imap <silent><expr> <CR> pumvisible() ? '<C-y>' : lexima#expand('<lt>CR>', 'i')
endf

let &cpo = s:save_cpo
unlet s:save_cpo
