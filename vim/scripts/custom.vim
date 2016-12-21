scriptencoding utf-8

if &compatible
	set nocompatible
endif

if !dein#check_install(["vimfiler.vim"])
	let g:vimfiler_force_overwrite_statusline = 0
	let g:vimfiler_enable_auto_cd = 1
	let g:vimfiler_as_default_explorer = 0
	nnoremap <silent> <Leader>e :VimFilerBufferDir -split -winwidth=35 -simple -toggle -find -force-quit -split-action=below<CR>
	nnoremap <silent> <Leader>E :VimFilerCurrentDir -split -winwidth=35 -simple -toggle -force-quit -split-action=below<CR>
	" nnoremap <silent> <Leader>e :VimFilerBufferDir -toggle -find -force-quit -split  -status -winwidth=35 -simple -split-action=below<CR>
	" nnoremap <silent> <Leader>E :VimFilerCurrentDir -split -toggle -force-quit -status -winwidth=35 -simple -split-action=below<CR>
endif

if !dein#check_install(["vimshell.vim"])
	let g:vimshell_prompt = "% "
	let g:vimshell_secondary_prompt = "> "
	let g:vimshell_user_prompt = 'getcwd()'
endif

if !dein#check_install(["ctrlp.vim"])
	" let g:ctrlp_cmd = "CtrlPMRUFiles"
	" yankroundのところでマッピングし直している
	let g:ctrlp_map = ''
	" let g:ctrlp_extensions = ['mixed']
	let g:ctrlp_max_files = 5000
	let g:ctrlp_match_window = "max:30"
	nnoremap <Leader>mr :<c-u>CtrlPMRUFiles<cr>
	nnoremap <Leader>c :<C-u>CtrlPCurWD<cr>
	" nnoremap <Leader>r :<C-u>CtrlPClearCache<cr>
	nnoremap <Leader>b :<C-u>CtrlPBuffer<cr>
	nnoremap <Leader><Leader> :<C-u>CtrlP<cr>
	if executable('ag')
		if !has("win32")
			let g:ctrlp_use_caching=1
			let g:ctrlp_user_command='ag %s -i --follow --nocolor --nogroup -g ""'
		else
			let g:ctrlp_use_caching=1
			let g:ctrlp_user_command='ag -i --follow --nocolor --nogroup -g "" %s'
		endif
	endif
endif

if !dein#check_install(["vim-easymotion"])
	let g:EasyMotion_do_mapping = 0
	nmap <Leader>s <Plug>(easymotion-overwin-f2)
endif

if !dein#check_install(["ctrlp-filer"])
	nnoremap <Leader>f :<C-u>CtrlPFiler<cr>
endif

if !dein#check_install(["vim-indent-guides"])
	let g:indent_guides_guide_size = 0
	let g:indent_guides_color_change_percent = 5
	let g:indent_guides_start_level = 1
	let g:indent_guides_enable_on_vim_startup = 1
endif

if !dein#check_install(["foldCC.vim"])
	let g:foldCCtext_enable_autofdc_adjuster = 1
	let g:foldCCtext_head = ''
	" let g:foldCCtext_tail = '"(ﾟｪﾟ  )". (v:foldend-v:foldstart+1)'

	let g:foldCCtext_tail = 'printf(" %4d lines Lv%-2d", v:foldend-v:foldstart+1, v:foldlevel)'

	set foldtext=FoldCCtext()
	set fillchars=vert:\|
	" augroup FoldCC "{{{
	"	 hi Folded gui=bold guibg=Grey28 guifg=gray80
	"	 hi FoldColumn guibg=Grey14 guifg=gray80
	"
	"	 " hi Folded gui=bold term=standout ctermbg=Grey ctermfg=DarkBlue guibg=Grey50 guifg=Grey80
	"	 " hi FoldColumn gui=bold term=standout ctermbg=Grey ctermfg=DarkBlue guibg=Grey guifg=DarkBlue
	" augroup END "}}}
endif

if !dein#check_install(["vim-airline"])
	let g:airline#extensions#branch#enabled		= 1
	let g:airline#extensions#branch#empty_message  = ''
	" let g:airline#extensions#whitespace#checks	 = [ 'indent',  'mixed-indent-file' ]
	let g:airline#extensions#syntastic#enabled	 = 0

	let g:airline#extensions#tabline#enabled	   = 1 "{{{
	" right side show mode
	let g:airline#extensions#tabline#show_tab_type = 1
	" プレビューウィンドウのステータスライン(Airline優先:0か,他のプラグイン優先:1)
	let g:airline#extensions#tabline#exclude_preview = 0
	let g:airline#extensions#tabline#show_tabs = 1
	let g:airline#extensions#tabline#show_splits   = 1
	let g:airline#extensions#tabline#show_buffers = 0
	let g:airline#extensions#tabline#tab_nr_type   = 2 " splits and tab number
	let g:airline#extensions#tabline#show_close_button = 0 "}}}

	" let g:airline_powerline_fonts=1
	if !exists('g:airline_symbols')
		let g:airline_symbols = {}
	endif
	" powerline symbols" {{{
	if has("gui_running")
		let g:airline#extensions#tabline#left_sep	  = '⮀'
		let g:airline#extensions#tabline#left_alt_sep  = '⮁'
		let g:airline#extensions#tabline#right_sep	 = '⮂'
		let g:airline#extensions#tabline#right_alt_sep = '⮃'
		let g:airline_left_sep		   = '⮀'
		let g:airline_left_alt_sep	   = '⮁'
		let g:airline_right_sep		  = '⮂'
		let g:airline_right_alt_sep	  = '⮃'
		let g:airline_symbols.branch	 = '⭠'
		let g:airline_symbols.readonly   = '⭤'
		let g:airline_symbols.linenr	 = '⭡'
	else
		let g:airline_left_sep		   = ''
		let g:airline_left_alt_sep	   = ''
		let g:airline_right_sep		  = ''
		let g:airline_right_alt_sep	  = ''
	endif " }}}

	" unicode symobols# {{{
	" let g:airline_symbols.crypt = '🔒'
	" let g:airline_symbols.linenr = '␊'
	" let g:airline_symbols.linenr = '␤'
	" let g:airline_symbols.linenr = '¶'
	" let g:airline_symbols.maxlinenr = '☰'
	" let g:airline_symbols.maxlinenr = ''
	" let g:airline_symbols.branch = '⎇'
	" let g:airline_symbols.paste = 'ρ'
	" let g:airline_symbols.paste = 'Þ'
	" let g:airline_symbols.paste = '∥'
	" let g:airline_symbols.spell = 'Ꞩ'
	" let g:airline_symbols.notexists = '∄'
	" let g:airline_symbols.whitespace = 'Ξ'# }}}

	" disable warning " {{{
	" let g:airline#extensions#default#layout = [
	"			 \ [ 'a', 'b', 'c' ],
	"			 \ [ 'x', 'y', 'z' ]
	"			 \ ] " }}}
endif

if !dein#check_install(["open-browser.vim.git"])
	let g:netrw_nogx = 1 " disable netrw's gx mapping.
	nmap gx <Plug>(openbrowser-smart-search)
	vmap gx <Plug>(openbrowser-smart-search)
	nnoremap <Leader>oh :<C-u>OpenBrowser https://
	nnoremap <Leader>os :<C-u>OpenBrowserSearch 
endif

if !dein#check_install(["vim-anzu"])
	" mapping
	nmap n <Plug>(anzu-n-with-echo)
	nmap N <Plug>(anzu-N-with-echo)
	nmap * <Plug>(anzu-star-with-echo)
	nmap # <Plug>(anzu-sharp-with-echo)

	" if start anzu-mode key mapping
	" anzu-mode is anzu(12/51) in screen
	" nmap n <Plug>(anzu-mode-n)
	" nmap N <Plug>(anzu-mode-N)
endif

if !dein#check_install(["ultisnips"])
	" better key bindings for UltiSnipsExpandTrigger
	let g:UltiSnipsExpandTrigger = "<c-j>"
	let g:UltiSnipsJumpForwardTrigger = "<c-j>"
	let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
	" let g:UltiSnipsSnippetsDir = "~/.vim/UltiSnips"
	if has("unix")
		if !g:myvimrc_python_version == ""
			let g:UltiSnipsUsePythonVersion = g:myvimrc_python_version
		else
			let g:UltiSnipsUsePythonVersion = 2
		endif
	endif
endif

if !dein#check_install(["supertab"])
	let g:SuperTabDefaultCompletionType = '<c-n>'
endif

if !dein#check_install(["html5.vim"])
	let g:html5_event_handler_attributes_complete = 1
	let g:html5_rdfa_attributes_complete = 1
	let g:html5_microdata_attributes_complete = 1
	let g:html5_aria_attributes_complete = 1
endif

if !dein#check_install(["yankround.vim"])
	nmap p <Plug>(yankround-p)
	xmap p <Plug>(yankround-p)
	nmap P <Plug>(yankround-P)

	nmap gp <Plug>(yankround-gp)
	xmap gp <Plug>(yankround-gp)
	nmap gP <Plug>(yankround-gP)

	nnoremap <silent><SID>(ctrlp) :<C-u>CtrlP<CR>
	nmap <expr><C-p> yankround#is_active() ? "\<Plug>(yankround-prev)" : "<SID>(ctrlp)"
	nmap <C-n> <Plug>(yankround-next)
endif

if !dein#check_install(["vim-easy-align"])
	" ヴィジュアルモードで選択し，easy-align 呼んで整形．(e.g. vip<Enter>)
	vmap <Enter> <Plug>(LiveEasyAlign)

	" easy-align を呼んだ上で，移動したりテキストオブジェクトを指定して整形．(e.g. gaip)
	" nmap ga <Plug>(EasyAlign)
	" " Start interactive EasyAlign in visual mode (e.g. vipga)
	" xmap ga <Plug>(EasyAlign)
endif

if !dein#check_install(["vim-dirvish"])
	nnoremap <silent> <Leader>d :let w:dirvishbefore=expand("%:p")<cr>:Dirvish %:p:h<cr>
	nnoremap <silent> <Leader>D :Dirvish<cr>

	fun s:mydirvish_selectbeforedir()
		if exists("w:dirvishbefore")
			call search('\V\^'.escape(w:dirvishbefore, '\').'\$', 'cw')
		endif
	endf

	augroup mydirvish
		autocmd!
		" hとlによる移動
		autocmd FileType dirvish nnoremap <silent><buffer> l :call dirvish#open('edit', 0)<CR>
		autocmd FileType dirvish xnoremap <silent><buffer> l :call dirvish#open('edit', 0)<CR>
		autocmd FileType dirvish nmap <silent><buffer> h <Plug>(dirvish_up)
		autocmd FileType dirvish xmap <silent><buffer> h <Plug>(dirvish_up)
		" 起動時にソート 行末記号を入れないことで全部ソートする
		autocmd FileType dirvish silent sort /.*\([\\\/]\)\@=/
		" autocmd FileType dirvish silent keeppatterns g@\v[\/]\.[^\/]+[\/]?$@d
		" .とsに隠しファイルとソートを割り当て
		autocmd FileType dirvish nnoremap <silent><buffer> . :keeppatterns g@\v[\/]\.[^\/]+[\/]?$@d<cr>
		" 行末記号を入れないことで全部ソートする
		autocmd FileType dirvish nnoremap <silent><buffer> s :sort /.*\([\\\/]\)\@=/<cr>

		" 開いていたファイルやDirectory(w:dirvishbefore)にカーソルをあわせる
		autocmd FileType dirvish call <SID>mydirvish_selectbeforedir()
		autocmd FileType dirvish let w:dirvishbefore=expand("%:p")
	augroup END
endif

if !dein#check_install(["vim-multiple-cursors"])
	let g:multi_cursor_use_default_mapping = 0
	" Default mapping
	let g:multi_cursor_start_key = 'g<C-n>'
	let g:multi_cursor_next_key = '<C-n>'
	let g:multi_cursor_prev_key = '<C-p>'
	let g:multi_cursor_skip_key = '<C-x>'
	let g:multi_cursor_quit_key = '<Esc>'
endif

if !dein#check_install(["undotree"])
	let g:undotree_WindowLayout = 2
	let g:undotree_SplitWidth = 30
	nnoremap <Leader>gu :<C-u>UndotreeToggle<cr>
endif

if !dein#check_install(["vim-clang-format"])
	let g:clang_format#auto_format = 0

	let g:clang_format#command = 'clang-format'
	for minorversion in range(10)
		if executable('clang-format-3.' . minorversion)
			let g:clang_format#command = 'clang-format-3.' . minorversion
		endif
	endfor

	let g:clang_format#style_options = {
				\ "AllowShortIfStatementsOnASingleLine" : "true",
				\ "AllowShortBlocksOnASingleLine" : "true",
				\ "AllowShortCaseLabelsOnASingleLine" : "true",
				\ "AllowShortFunctionsOnASingleLine" : "true",
				\ "AllowShortLoopsOnASingleLine" : "true",
				\ "AlignAfterOpenBracket" : "AlwaysBreak",
				\ "AlignConsecutiveAssignments" : "true",
				\ "AlignConsecutiveDeclarations" : "true",
				\ "AlignTrailingComments" : "true",
				\ "TabWidth" : "4",
				\ "UseTab" : "Never",
				\ "ColumnLimit" : "120"
				\ }
endif

if !dein#check_install(["memolist.vim"])
	" let g:memolist_memo_suffix = 'txt'
	let g:memolist_unite = 0
	let g:memolist_ex_cmd = "Dirvish"
	nmap <Leader>mn :MemoNew<cr>
	nmap <Leader>ml :MemoList<cr>
endif

if !dein#check_install(["tagbar"])
	nnoremap <silent> <Leader>t :TagbarOpen j<CR>
	let g:tagbar_show_linenumbers = 1
	let g:tagbar_sort = 0
	let g:tagbar_indent = 1
	let g:tagbar_autoshowtag = 1
	let g:tagbar_autopreview = 0
	let g:tagbar_autofocus = 1
	let g:tagbar_autoclose = 1
	autocmd FileType help let b:tagbar_ignore = 1
endif

if !dein#check_install(["TweetVim.git"])
	" 1ページに表示する最大数
	let g:tweetvim_tweet_per_page = 20
	" F6と,uvでTweetVimのtimeline選択
	let g:tweetvim_expand_t_co = 1
	" let g:tweetvim_open_buffer_cmd = "split!"
	let g:tweetvim_display_source = 1
	let g:tweetvim_display_username = 1
	let g:tweetvim_display_icon = 1
	" let g:tweetvim_async_post = 0
	nnoremap <Leader>Tl :<C-u>Unite tweetvim<CR>
	nnoremap <Leader>Tm :<C-u>TweetVimMentions<CR>
	" nnoremap <Leader>Tl :<C-u>TweetVimListStatuses
	nnoremap <Leader>Tu :<C-u>TweetVimUserStream<CR>
	nnoremap <Leader>Ts :<C-u>TweetVimSay<CR>
	nnoremap <Leader>Tc :<C-u>TweetVimCommandSay<CR>
endif

if !dein#check_install(["YouCompleteMe"])
	let g:ycm_global_ycm_extra_conf =
				\'~/.vim/dein/repos/github.com/Valloric/YouCompleteMe
				\/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

	let g:ycm_min_num_of_chars_for_completion = 1
	let g:ycm_complete_in_comments = 1
	let g:ycm_collect_identifiers_from_comments_and_strings = 1
	let g:ycm_collect_identifiers_from_tags_files = 1
	let g:ycm_seed_identifiers_with_syntax = 1
	let g:ycm_add_preview_to_completeopt = 1
	let g:ycm_autoclose_preview_window_after_completion = 1
	" setting of the which python is used
	if has("unix")
		let g:ycm_python_binary_path = "python" . g:myvimrc_python_version
	endif
	let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
	let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
	autocmd VIMRC FileType python nnoremap <buffer> K :<C-u>YcmCompleter GetDoc<CR>
	autocmd VIMRC FileType python nnoremap <buffer> <C-]> :<C-u>YcmCompleter GoTo<CR>
endif

if !dein#check_install(["vimtex"])
	if has("win32")
		let g:vimtex_latexmk_continuous = 1
		let g:vimtex_latexmk_background = 1
		"let g:vimtex_latexmk_options = '-pdf'
		let g:vimtex_latexmk_options = '-pdfdvi'
		"let g:vimtex_latexmk_options = '-pdfps'
		let g:vimtex_view_general_viewer = "SumatraPDF.exe"
		let g:vimtex_view_general_options =
					\ '-reuse-instance -inverse-search "\"' . $VIM . '\gvim.exe\" -n --remote-silent +\%l \"\%f\"" -forward-search @tex @line @pdf'
		let g:vimtex_view_general_options_latexmk = '-reuse-instance'
		"let g:vimtex_view_general_viewer = 'texworks'
	elseif has("unix")""
		let g:vimtex_latexmk_continuous = 1
		let g:vimtex_latexmk_background = 1
		"let g:vimtex_latexmk_options = '-pdf'
		let g:vimtex_latexmk_options = '-pdfdvi'
		"let g:vimtex_latexmk_options = '-pdfps'
		let g:vimtex_view_general_viewer = 'xdg-open'
		"let g:vimtex_view_general_viewer = 'okular'
		"let g:vimtex_view_general_options = '--unique @pdf\#src:@line@tex'
		"let g:vimtex_view_general_options_latexmk = '--unique'
		"let g:vimtex_view_general_viewer = 'qpdfview'
		"let g:vimtex_view_general_options = '--unique @pdf\#src:@tex:@line:@col'
		"let g:vimtex_view_general_options_latexmk = '--unique'
	endif
endif

if !dein#check_install(["markdown-preview.vim"])
	let g:mkdp_auto_close = 0
	let g:mkdp_auto_open = 0
	let g:mkdp_auto_start = 0
	if has('win32') != 0
		let s:google_chrome_path="C:/Program\ Files/Google/Chrome/Application/chrome.exe"
		let s:google_chrome_path32="C:/Program\ Files\ (x86)/Google/Chrome/Application/chrome.exe"
		if executable(s:google_chrome_path)
			let g:mkdp_path_to_chrome=s:google_chrome_path
		else
			let g:mkdp_path_to_chrome=s:google_chrome_path32
		endif
	endif
endif

if !dein#check_install(["previm"])
	let g:previm_enable_realtime = 1
endif

if !dein#check_install(["unite.vim"])
	nnoremap <silent> <Leader>ub :<C-u>Unite buffer<CR>
	nnoremap <silent> <Leader>uf :<C-u>UniteWithBufferDir -buffer-name=files -start-insert file_rec/async<CR>
	nnoremap <silent> <Leader>ur :<C-u>Unite -buffer-name=register register<CR>
	nnoremap <silent> <Leader>um :<C-u>Unite file_mru<CR>
	nnoremap <silent> <Leader>uu :<C-u>Unite buffer file_mru<CR>
	" Unite All
	nnoremap <silent> <Leader>ua :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
	" UniteOutLine
	nnoremap <silent> <Leader>uo :<C-u>Unite -vertical -no-quit -winwidth=40 outline -direction=botright<CR>
	let g:unite_force_overwrite_statusline = 0
	let g:unite_enable_start_insert = 0
	" ウィンドウを分割して開く
	augroup CustomUnite
		autocmd!
		autocmd FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
		autocmd FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
		" ウィンドウを縦に分割して開く
		autocmd FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
		autocmd FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
		" タブで開く
		autocmd FileType unite nnoremap <silent> <buffer> <expr> <C-t> unite#do_action('tabopen')
		autocmd FileType unite inoremap <silent> <buffer> <expr> <C-t> unite#do_action('tabopen')
		" ESCキーを2回押すと終了する
		autocmd FileType unite nmap <silent> <buffer> <ESC><ESC> <Plug>(unite_exit)
		autocmd FileType unite imap <silent> <buffer> <ESC><ESC> <Plug>(unite_exit)
		autocmd FileType unite imap <silent> <buffer> <C-j> <Plug>(unite_select_next_line)
		autocmd FileType unite imap <silent> <buffer> <C-k> <Plug>(unite_select_previous_line)
		autocmd FileType unite call unite#filters#matcher_default#use(['matcher_fuzzy'])
	augroup END
	"nice unite and ag
	" let g:unite_source_history_yank_enable = 1
	" try
	let g:unite_source_rec_async_command =
				\ ['ag', '--follow', '--nocolor', '--nogroup',
				\  '--hidden', '-g', '']
	let g:unite_source_rec_max_cache_files = 5000
	" catch
	" endtry
	" search a file in the filetree
	" nnoremap <space><space> :<C-u>Unite -start-insert file_rec/async<cr>
	" reset not it is <C-l> normally
	" nnoremap <space>r <Plug>(unite_restart)
endif

if !dein#check_install(["vim-brightest"])
	let g:brightest#highlight = {
				\   "group" : "BrightestUnderline"
				\}
endif
