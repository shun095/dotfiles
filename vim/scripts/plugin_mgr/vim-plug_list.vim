
let s:save_cpo = &cpo
set cpo&vim

if exists('g:loaded_vim_plug_list')
  finish
endif
let g:loaded_vim_plug_list = 1

Plug 'scrooloose/nerdtree'
Plug 'Konfekt/FastFold'
Plug 'LeafCage/foldCC.vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'ervandew/supertab'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-dispatch'
Plug 'junegunn/gv.vim'
if has('python3')
  Plug 'Shougo/denite.nvim'
        \ | Plug 'Shougo/neomru.vim'
        \ | Plug 'Shougo/unite-outline'
endif
Plug 'junegunn/fzf.vim'
Plug 'ishitaku5522/revimses', { 'branch': 'dev' }
Plug 'junegunn/vim-easy-align'
Plug 'Yggdroot/indentLine'
Plug 'osyo-manga/vim-anzu'
Plug 'tmux-plugins/vim-tmux'
Plug 'tpope/vim-surround'
Plug 'vim-jp/vimdoc-ja'
Plug 'vim-jp/vital.vim'
Plug 'vim-jp/autofmt'
Plug 'cocopon/iceberg.vim'
Plug 'thinca/vim-quickrun'
      \ | Plug 'osyo-manga/shabadou.vim'
Plug 'aperezdc/vim-template'
Plug 'itchyny/vim-cursorword'
Plug 'chiel92/vim-autoformat'
Plug 'scrooloose/nerdcommenter'
Plug 'kana/vim-submode'
if has('nvim')
  Plug 'Shougo/deoplete.nvim'
        \ | Plug 'carlitux/deoplete-ternjs'
        \ | Plug 'zchee/deoplete-jedi', { 'for': ['python'] }
        \ | Plug 'https://github.com/Rip-Rip/clang_complete'
else
  Plug 'Valloric/YouCompleteMe'
endif
Plug 'raimondi/delimitmate'
if !has('job')
  Plug 'Shougo/vimproc.vim'
endif

" lazy
Plug "bkad/CamelCaseMotion"
on_map = ['n', ',']
hook_post_source = ''' " {{{
call g:plugin_mgr.lazy_hook('CamelCaseMotion')
''' # }}}
# call g:plugin_mgr.lazy_hook('lexima.vim')
Plug 'iamcco/markdown-preview.vim'
on_ft = 'markdown'
Plug 'kannokanno/previm'
on_ft = 'markdown'
Plug 'plasticboy/vim-markdown'
on_ft = 'markdown'
Plug 'ishitaku5522/TweetVim'
on_cmd = ['TweetVimHomeTimeline', 'TweetVimUserStream', 'TweetVimSay', 'TweetVimCommandSay']
depends = ['bitly.vim', 'twibill.vim',  'open-browser.vim']
Plug 'basyura/twibill.vim'
Plug 'basyura/bitly.vim'
Plug 'cespare/vim-toml'
on_ft = 'toml'
Plug 'csscomb/vim-csscomb'
on_ft = 'css'
Plug 'gregsexton/MatchTag'
on_ft = ['html','xml']
Plug 'othree/html5.vim'
on_ft = ['html']
Plug 'mattn/emmet-vim'
on_ft = ['html','xml']
Plug 'pangloss/vim-javascript'
on_ft = 'javascript'
Plug 'glidenote/memolist.vim'
on_cmd = ['MemoNew', 'MemoList']
Plug 'lervag/vimtex'
on_ft = ['tex']
Plug 'rdnetto/YCM-Generator'
on_cmd = 'YcmGenerateConfig'
depends = "YouCompleteMe"
Plug 'itchyny/calendar.vim'
on_cmd = 'Calendar'
Plug 'majutsushi/tagbar'
on_cmd = ['TagbarToggle', 'TagbarOpen']
Plug 'artur-shaik/vim-javacomplete2'
on_ft = 'java'
Plug 'AndrewRadev/linediff.vim'
on_cmd = 'Linediff'
Plug "osyo-manga/vim-watchdogs"
on_event = ['BufWrite','CursorHold']
depends = ['vim-quickrun']
on_cmd = ['WatchdogsRun']
hook_post_source = ''' " {{{
call g:plugin_mgr.lazy_hook('vim-watchdogs')
''' # }}}
Plug 'haya14busa/vim-open-googletranslate'
on_cmd = 'OpenGoogleTranslate'
depends = ['open-browser']
Plug 'mbbill/undotree'
on_cmd = ['UndotreeFocus', 'UndotreeHide', 'UndotreeShow', 'UndotreeToggle']
Plug 'octol/vim-cpp-enhanced-highlight'
on_ft = ['c','cpp']
Plug 'mopp/next-alter.vim'
on_ft = ['c','cpp']
Plug 'tyru/open-browser.vim'
on_cmd = [ 'OpenBrowser', 'OpenBrowserSearch', 'OpenBrowserSmartSearch' ]
Plug 'tyru/restart.vim'
on_cmd = 'Restart'
Plug 'chiel92/vim-autoformat'
on_cmd = 'Autoformat'

call plug#end()

source $MYVIMHOME/scripts/lazy_hooks.vim

augroup _myplug
  autocmd!

  for plugname in keys(g:plugs)
    if has_key(g:plugs[plugname], 'event')
      if type(g:plugs[plugname]['event']) == v:t_string
        execute 'autocmd ' . g:plugs[plugname]['event'] . ' * call g:plugin_mgr.lazy_hook(''' . plugname . ''')'

      elseif type(g:plugs[plugname]['event']) == v:t_list
        for cmd in g:plugs[plugname]['event']
          execute 'autocmd ' . cmd . ' * call g:plugin_mgr.lazy_hook(''' . plugname . ''')'
        endfor

      endif
    elseif g:plugin_mgr.lazy_hook_available(plugname)
      execute 'autocmd VimEnter * call g:plugin_mgr.lazy_hook('''.plugname.''')'
    endif
  endfor


augroup END


let &cpo = s:save_cpo
unlet s:save_cpo
