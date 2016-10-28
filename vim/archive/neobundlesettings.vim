
"using neobundle {{{
"==================================================
"USING NEOBUNDLE
"==================================================
" 一度ファイルタイプをオフにしてから最後に再度オンにする
"-----NeoBundle-----
" vim起動時のみruntimepathにneobundle.vimを追加
if has('vim_starting')
	set nocompatible
	"絶対パスでのみ動く
	set runtimepath+=~/.vim/bundle/neobundle.vim
endif
" neobundle.vimの初期化
" call neobundle#rc(expand('~/.vim/bundle'))
call neobundle#begin(expand('~/.vim/bundle/'))
" NeoBundleを更新するための設定
NeoBundleFetch 'Shougo/neobundle.vim'

"-----Visual Studio Plugin-----
NeoBundle 'taku25/vim-visualstudio'
let g:visualstudio_controllerpath = "VisualStudioController.exe"
let g:visualstudio_enableerrormarker = 1
let g:visualstudio_terminalencoding =500

" Web系で便利らしいの一式
" NeoBundle 'mattn/emmet-vim'
NeoBundle 'tpope/vim-surround'
NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'jelera/vim-javascript-syntax'
" NeoBundle 'taichouchou2/html5.vim'
" NeoBundle 'taichouchou2/vim-javascript'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'othree/javascript-libraries-syntax.vim'
NeoBundle 'gregsexton/MatchTag'

nnoremap <C-]> g<C-]>
NeoBundle 'vim-scripts/TagHighlight'


" augroup VIMINDENTGUIDES    " {{{
"   NeoBundle  'nathanaelkane/vim-indent-guides'
"   let g:indent_guides_enable_on_vim_startup = 1
" augroup END    "}}}

" NeoBundle 'octol/vim-cpp-enhanced-highlight'
let g:cpp_class_scope_highlight = 1
" let g:cpp_experimental_template_highlight = 1

" NeoBundle 'vim-jp/cpp-vim',{
"             \ 'autoload' :{'filetypes': 'cpp'}
"             \}

augroup cpp-path
	autocmd!
	" autocmd FileType cpp setlocal path+=G:\Softwares\Microsoft_Visual_studio_14.0\VC\include
	" autocmd FileType cpp set expandtab|set tabstop=2|set shiftwidth=2
	" NeoBundle 'OmniCppComplete'
augroup END
" augroup Python_Path
" 	autocmd!
" 	set path+=C:\Python26\
" augroup END

"-----Auto Format-----
" NeoBundle 'Chiel92/vim-autoformat'

"----------migemo settings----------
" NeoBundle "https://github.com/haya14busa/vim-migemo"
" set migemodict=$VIM/migemo-dict
" source ~/.vim/bundle/migemo.vim

call neobundle#end()

" 最終段階
NeoBundleCheck

