scriptencoding utf-8

if &compatible
	set nocompatible
endif

if !dein#check_install(["vimfiler.vim"])
	let g:vimfiler_force_overwrite_statusline = 0
	let g:vimfiler_enable_auto_cd = 1
	let g:vimfiler_as_default_explorer = 0
	nnoremap <silent> <Leader>e :VimFilerBufferDir -split -winwidth=35 -simple -toggle -find -no-quit -split-action=below<CR>
	nnoremap <silent> <Leader>E :VimFilerCurrentDir -split -winwidth=35 -simple -toggle -no-quit -split-action=below<CR>
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
