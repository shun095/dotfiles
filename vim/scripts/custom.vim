scriptencoding utf-8

if &compatible
  set nocompatible
endif

if mymisc#plug_tap('YouCompleteMe')
  call mymisc#config#YouCompleteMe#setup()
endif

if mymisc#plug_tap('vim-dirvish')
  call mymisc#config#dirvish#setup()
endif

if mymisc#plug_tap('vim-dirvish-git')
  call mymisc#config#dirvish_git#setup()
endif

if mymisc#plug_tap('vim-easymotion')
  let g:EasyMotion_do_mapping = 0
  nmap s <Plug>(easymotion-overwin-f2)
endif

if mymisc#plug_tap('foldCC.vim')
  let g:foldCCtext_enable_autofdc_adjuster = 1
  let g:foldCCtext_head = ''
  let g:foldCCtext_tail = 'printf(" %4d lines Lv%-2d", v:foldend-v:foldstart+1, v:foldlevel)'
  set foldtext=FoldCCtext()
endif

if mymisc#plug_tap('html5.vim')
  let g:html5_event_handler_attributes_complete = 1
  let g:html5_rdfa_attributes_complete = 1
  let g:html5_microdata_attributes_complete = 1
  let g:html5_aria_attributes_complete = 1
endif

if mymisc#plug_tap('markdown-preview.vim')
  let g:mkdp_auto_close = 1
  let g:mkdp_auto_open = 0
  let g:mkdp_auto_start = 0
  if has('win32')
    let s:browser_path='C:\Program Files\Mozilla Firefox\firefox.exe'
    if executable(s:browser_path)
      let g:mkdp_path_to_chrome=shellescape(s:browser_path)
    endif
    unlet s:browser_path
  elseif has('mac')
    let g:mkdp_path_to_chrome = 'open'
  else
    let g:mkdp_path_to_chrome = 'xdg-open'
  endif
endif

if mymisc#plug_tap('memolist.vim')
  call mymisc#config#memolist#setup()
endif

if mymisc#plug_tap('nerdtree')
  call mymisc#config#nerdtree#setup()
endif

if mymisc#plug_tap('open-browser.vim')
  let g:netrw_nogx = 1 " disable netrw's gx mapping.
  nmap gx <Plug>(openbrowser-smart-search)
  vmap gx <Plug>(openbrowser-smart-search)
  nnoremap <Leader>Bh :<C-u>OpenBrowser https://
  nnoremap <Leader>Bs :<C-u>OpenBrowserSearch<Space>
  command! -nargs=1 Weblio OpenBrowser http://ejje.weblio.jp/content/<args>
endif

if mymisc#plug_tap('previm')
  let g:previm_enable_realtime = 1
  " let g:previm_custom_css_path =
  let g:previm_disable_default_css = 1
  let g:previm_custom_css_path = $MYDOTFILES . "/third-party/github-markdown.css"
  let g:previm_show_header = 0
  function! s:setup_setting()
    command! -buffer -nargs=? -complete=dir PrevimSaveHTML call mymisc#previm_save_html('<args>')
  endfunction

  augroup vimrc_previm
    autocmd!
    autocmd FileType *{mkd,markdown,rst,textile}* call <SID>setup_setting()
  augroup END
endif

if mymisc#plug_tap('restart.vim')
  let g:restart_sessionoptions = &sessionoptions
endif

if mymisc#plug_tap('tagbar')
  nnoremap <silent> <Leader>t :<C-u>TagbarOpen j<CR>
  let g:tagbar_show_linenumbers = 0
  let g:tagbar_sort = 0
  let g:tagbar_indent = 1
  let g:tagbar_autoshowtag = 1
  let g:tagbar_autopreview = 0
  let g:tagbar_autofocus = 1
  let g:tagbar_autoclose = 0
  " let g:tagbar_width = 30
  augroup vimrc_tagbar
    autocmd!
    autocmd FileType help let b:tagbar_ignore = 1
  augroup END
endif

if mymisc#plug_tap('undotree')
  let g:undotree_WindowLayout = 2
  let g:undotree_SplitWidth = 30
  nnoremap <Leader>gu :<C-u>UndotreeToggle<cr>
endif

if mymisc#plug_tap('vim-searchindex')
  augroup vimrc_searchindex
    autocmd!
    autocmd VimEnter * vnoremap * "9y:<C-u>let @/ = '\<'.@9.'\>\C'<CR>/<CR>:<C-u>SearchIndex<CR>
    autocmd VimEnter * vnoremap g* "9y:<C-u>let @/ = @9.'\C'<CR>/<CR>:<C-u>SearchIndex<CR>
    autocmd VimEnter * vnoremap # "9y:<C-u>let @/ = '\<'.@9.'\>\C'<CR>?<CR>:<C-u>SearchIndex<CR>
    autocmd VimEnter * vnoremap g# "9y:<C-u>let @/ = @9.'\C'<CR>?<CR>:<C-u>SearchIndex<CR>
  augroup END
endif

if mymisc#plug_tap('vim-anzu')
  " mapping
  nmap n <Plug>(anzu-n-with-echo)
  nmap N <Plug>(anzu-N-with-echo)

  " vnoremap * "9y:<C-u>let @/ = '\<'.@9.'\>\C'<CR>/<CR>
  " vnoremap g* "9y:<C-u>let @/ = @9.'\C'<CR>/<CR>
  " vnoremap # "9y:<C-u>let @/ = '\<'.@9.'\>\C'<CR>?<CR>
  " vnoremap g# "9y:<C-u>let @/ = @9.'\C'<CR>?<CR>
  " nmap * <Plug>(anzu-star-with-echo)
  " nmap # <Plug>(anzu-sharp-with-echo)
endif

if mymisc#plug_tap('vim-easy-align')
  " ヴィジュアルモードで選択し，easy-align 呼んで整形．(e.g. vip<Enter>)
  vmap <Enter> <Plug>(LiveEasyAlign)
  " easy-align を呼んだ上で，移動したりテキストオブジェクトを指定して整形．(e.g. gaip)
  " nmap ga <Plug>(EasyAlign)
  " " Start interactive EasyAlign in visual mode (e.g. vipga)
  " xmap ga <Plug>(EasyAlign)
endif

if mymisc#plug_tap('vim-quickrun')
  call mymisc#config#quickrun#setup()
endif

if mymisc#plug_tap('vimshell.vim')
  let g:vimshell_prompt = '% '
  let g:vimshell_secondary_prompt = '> '
  let g:vimshell_user_prompt = 'getcwd()'
endif

if mymisc#plug_tap('vimtex')
  call mymisc#config#vimtex#setup()
endif

if mymisc#plug_tap('revimses')
  let g:revimses#sessionoptions = &sessionoptions
endif

if mymisc#plug_tap('vim-indent-guides')
  let g:indent_guides_enable_on_vim_startup = 1
  let g:indent_guides_auto_colors = 1
  let g:indent_guides_color_change_percent = 5
endif

if mymisc#plug_tap('calendar.vim')
  augroup vimrc_calendar
    autocmd!
  augroup END

  if mymisc#plug_tap('vim-indent-guides')
    autocmd vimrc_calendar FileType calendar IndentGuidesDisable
  endif

  if mymisc#plug_tap('indentLine')
    autocmd vimrc_calendar FileType calendar IndentLinesDisable
  endif

  let g:calendar_google_calendar = 1
  let g:calendar_google_task = 1
  let g:calendar_time_zone = '+0900'
  let g:calendar_first_day='sunday'
endif

if mymisc#plug_tap('autofmt')
  set formatexpr=autofmt#japanese#formatexpr()
endif

if mymisc#plug_tap('vimfiler.vim')
  let g:vimfiler_as_default_explorer = 1
  " call vimfiler#custom#profile('default', 'context', {
  "       \   'split' : 1,
  "       \   'horizontal' : 0,
  "       \   'direction' : 'topleft',
  "       \   'winwidth' : 35,
  "       \   'simple' : 1
  "       \ })
  " let g:vimfiler_force_overwrite_statusline = 0
  " let g:vimfiler_restore_alternate_file = 0
  nnoremap <silent> <Leader>e :VimFilerBufferDir  -force-quit -split -winwidth=35 -simple -find<CR>
  nnoremap <silent> <Leader>E :VimFilerCurrentDir -force-quit -split -winwidth=35 -simple <CR>
endif

if mymisc#plug_tap('defx.nvim')
  call mymisc#config#defx#setup()
endif

if mymisc#plug_tap('ctrlp.vim')
  call mymisc#config#ctrlp#setup()
endif

if mymisc#plug_tap('fzf.vim')
  call mymisc#config#fzf#setup()
endif

if mymisc#plug_tap('vim-peekaboo')
  " let g:peekaboo_window = 'vert abo 40new'
  " let g:peekaboo_compact = 1
  " let g:peekaboo_prefix = '<leader>'
  " let g:peekaboo_ins_prefix = '<C-x>'
endif

if mymisc#plug_tap('denite.nvim')
  call mymisc#config#denite#setup()
endif

if mymisc#plug_tap('delimitMate')
  let delimitMate_expand_cr = 1
  let delimitMate_expand_space = 1
  let delimitMate_expand_inside_quotes = 1
  let delimitMate_jump_expansion = 1
  let delimitMate_balance_matchpairs = 1
  " imap <silent><expr> <CR> pumvisible() ? "\<C-Y>" : "<Plug>delimitMateCR"
  " augroup vimrc_delimitmate
  "   au FileType html,xhtml,phtml let b:delimitMate_autoclose = 0
  " augroup END
endif

if mymisc#plug_tap('ultisnips')
  if has('unix')
    if has('python3')
      let g:UltiSnipsUsePythonVersion = 3
    elseif has('python')
      let g:UltiSnipsUsePythonVersion = 2
    endif
  endif

  " To Manage mappgins by my self
  let g:UltiSnipsExpandTrigger       = '<Plug>(RemapUltiSnipsExpandTrigger)'
  let g:UltiSnipsListSnippets        = '<Plug>(RemapUltiSnipsListSnippets)'
  let g:UltiSnipsJumpForwardTrigger  = '<Plug>(RemapUltiSnipsJumpForwardTrigger)'
  let g:UltiSnipsJumpBackwardTrigger = '<Plug>(RemapUltiSnipsJumpBackwardTrigger)'

  smap <silent> <Tab> <Plug>(RemapUltiSnipsJumpForwardTrigger)
  smap <silent> <S-Tab> <Plug>(RemapUltiSnipsJumpBackwardTrigger)
  imap <silent> <expr><S-TAB> pumvisible() ?
        \ "\<C-p>" : "\<C-r>=UltiSnips#JumpBackwards()<CR>"
endif

if mymisc#plug_tap('supertab')
  let g:SuperTabDefaultCompletionType = '<c-n>'
endif

if mymisc#plug_tap('deoplete.nvim')
  call mymisc#config#deoplete#setup()
endif

if mymisc#plug_tap('ale')
  call mymisc#config#ale#setup()
endif

if mymisc#plug_tap('LanguageClient-neovim')
  call mymisc#config#LanguageClient#setup()
endif

if mymisc#plug_tap('vim-lsp')
  call mymisc#config#lsp#setup()
endif

if mymisc#plug_tap('asyncomplete.vim')
  call mymisc#config#asyncomplete#setup()
endif

if mymisc#plug_tap('clang_complete')
  " let g:clang_library_path='/usr/lib/llvm-3.8/lib'
  let g:clang_complete_auto=0
endif

if mymisc#plug_tap('jedi-vim')
  let g:jedi#completions_enabled = 0
  let g:jedi#show_call_signatures = 2
  let g:jedi#auto_initialization = 0
  augroup vimrc_jedi
    autocmd!
    autocmd FileType python nnoremap <buffer> <F2> :call jedi#rename()<CR>
    autocmd FileType python nnoremap <buffer> K :call jedi#show_documentation()<CR>
    autocmd FileType python nnoremap <buffer> <C-]> :call jedi#goto()<CR>
    autocmd FileType python setlocal omnifunc=jedi#completions
  augroup END
endif

if mymisc#plug_tap('omnisharp-vim')
  let g:OmniSharp_selector_ui = 'ctrlp'
  let g:omnicomplete_fetch_full_documentation = 1
  let g:OmniSharp_want_snippet = 0
  let g:OmniSharp_timeout = 5

  if mymisc#plug_tap('deoplete.nvim')
    call deoplete#custom#source('omnisharp','input_pattern','[^. \t0-9]\.\w*')
  endif

  augroup omnisharp_commands
    autocmd!
    autocmd FileType cs setlocal omnifunc=OmniSharp#Complete
    autocmd FileType cs OmniSharpHighlightTypes
    autocmd FileType cs setlocal expandtab
    " autocmd CursorHold,CursorHoldI *.cs call OmniSharp#TypeLookupWithoutDocumentation()
    autocmd FileType cs nnoremap <buffer> <C-]> :OmniSharpGotoDefinition<CR>
    autocmd FileType cs nnoremap <buffer> K :OmniSharpDocumentation<CR>
    autocmd FileType cs nnoremap <buffer> <F2> :OmniSharpRename<CR>
  augroup END
endif

if mymisc#plug_tap('tsuquyomi')
  let g:tsuquyomi_completion_detail = 1
  let g:tsuquyomi_javascript_support = 1
endif

if mymisc#plug_tap('nerdcommenter')
  call mymisc#config#nerdcommenter#setup()
endif

if mymisc#plug_tap('vim-javacomplete2')
  augroup vimrc_javacomplete2
    autocmd!
    autocmd Filetype java setlocal omnifunc=javacomplete#Complete
  augroup END
endif

if mymisc#plug_tap('vim-cpp-enhanced-highlight')
  let g:cpp_class_scope_highlight = 1
  let g:cpp_member_variable_highlight = 1
  let g:cpp_class_decl_highlight = 1
  let g:cpp_concepts_highlight = 1
endif

if mymisc#plug_tap('next-alter.vim')
  nmap <F4> <Plug>(next-alter-open)
  augroup vimrc_nextalter
    autocmd!
    autocmd BufEnter * let g:next_alter#search_dir = [ expand('%:h'), '.' , '..', './include', '../include', './src', '../src' ]
  augroup END
endif

if mymisc#plug_tap('auto-pairs')
  let g:AutoPairsMapCR = 0
  let g:AutoPairsFlyMode = 0
  let g:AutoPairsMultilineClose = 1
  let g:AutoPairsShortcutBackInsert = '<C-j>'
endif

if mymisc#plug_tap('lexima.vim')
  let g:lexima_ctrlh_as_backspace = 1

  for [begin, end] in [['(', ')'], ['{','}'], ['[',']']]
    call lexima#add_rule({'char':begin, 'at':'\%#[:alnum:]', 'input':begin})
    call lexima#add_rule({'char':end,   'at':'\%#\n\s*'.end, 'input':'<CR>'.end, 'delete':end})
  endfor

  for mark in ['"', "'"]
    call lexima#add_rule({'at': '\%#[:alnum:]', 'char': mark, 'input': mark})
  endfor
endif

if mymisc#plug_tap('vim-submode')
  call mymisc#config#submode#setup()
endif

if mymisc#plug_tap('indentLine')
  " let g:indentLine_showFirstIndentLevel=1
endif

if mymisc#plug_tap('vim-autoformat')
  let g:autoformat_verbosemode = 1
endif

if mymisc#plug_tap('vim-startify')
  let g:startify_files_number = 20
endif

if mymisc#plug_tap('vim-devicons')
  let g:WebDevIconsNerdTreeAfterGlyphPadding = ''
  let g:WebDevIconsUnicodeDecorateFolderNodes = 1
endif

if mymisc#plug_tap('vim-go')
  let g:go_gocode_propose_builtins = 0
endif

if mymisc#plug_tap('gina.vim')
  cabbrev G Gina
  nnoremap <Leader>gs :<C-u>Gina status --opener=split<CR>
  nnoremap <Leader>gc :<C-u>Gina commit --opener=split<CR>
  " nnoremap <Leader>gp :<C-u>Gina push<CR>
  " nnoremap <Leader>gl :<C-u>Gina pull<CR>
  nnoremap <Leader>gf :<C-u>Gina fetch --all -t<CR>
  nnoremap <Leader>gm :<C-u>Gina merge<CR>

  call gina#custom#mapping#nmap(
        \ 'status', 'q',
        \ ':<C-u>bd<CR><C-w>p',
        \ {'noremap': 1, 'silent': 0},
        \)
  call gina#custom#mapping#nmap(
        \ 'commit', 'q',
        \ ':<C-u>bd<CR><C-w>p',
        \ {'noremap': 1, 'silent': 0},
        \)
  call gina#custom#mapping#nmap(
        \ 'diff', 'q',
        \ ':<C-u>bd<CR><C-w>p',
        \ {'noremap': 1, 'silent': 0},
        \)
endif

if mymisc#plug_tap('vim-fugitive')
  nnoremap <Leader>gs :<C-u>Gstatus<CR>
  nnoremap <Leader>gc :<C-u>Gcommit<CR>
  nnoremap <Leader>gf :<C-u>Gfetch --all -t<CR>
  nnoremap <Leader>gm :<C-u>Gmerge<CR>
endif

if mymisc#plug_tap('vim-gitgutter')
  let g:gitgutter_async = 1
  nnoremap <Leader>gg :<C-u>GitGutterAll<CR>
  augroup vimrc_gitgutter
    autocmd!
    autocmd User GitGutter call mymisc#set_statusline_vars()
    autocmd BufWrite * GitGutterAll
  augroup END
endif

if mymisc#plug_tap('rainbow_parentheses.vim')
  let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{','}']]
  augroup vimrc-rainbow
    au!
    au VimEnter * RainbowParentheses
  augroup END
  " augroup vimrc-rainbow
  "   au!
  "   au VimEnter * RainbowParenthesesToggle
  "   au Syntax * RainbowParenthesesLoadRound
  "   au Syntax * RainbowParenthesesLoadSquare
  "   au Syntax * RainbowParenthesesLoadBraces
  "   au Syntax * RainbowParenthesesLoadChevrons
  " augroup END
endif

if mymisc#plug_tap('rainbow')
  " let g:rainbow_active = 1
  let g:rainbow_conf = {
        \ 'guifgs': ['#e06c75', '#98c379', '#d19a66', '#61afef', '#c678dd', '#56b6c2'],
        \ 'ctermfgs': [1, 2, 3, 4, 5, 6]
        \ }
endif

if mymisc#plug_tap('vim-nerdtree-syntax-highlight')
  " let g:NERDTreeFileExtensionHighlightFullName = 1
  " let g:NERDTreeExactMatchHighlightFullName = 1
  " let g:NERDTreePatternMatchHighlightFullName = 1
  " let g:NERDTreeHighlightFolders = 1 " enables folder icon highlighting using exact match
  " let g:NERDTreeHighlightFoldersFullName = 1 " highlights the folder name
  let g:NERDTreeLimitedSyntax = 1
endif

if mymisc#plug_tap('vim-nerdtree-tabs')
  let g:nerdtree_tabs_open_on_gui_startup = 0
endif

if mymisc#plug_tap('vim-vue')
  augroup vimrc-vue
    autocmd!
    " autocmd FileType vue syntax sync fromstart
    " autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript.css
  augroup END
endif

if mymisc#plug_tap('CamelCaseMotion')
  call camelcasemotion#CreateMotionMappings(',')
endif

if mymisc#plug_tap('sonictemplate-vim')
  let g:sonictemplate_vim_template_dir = [
        \ $MYDOTFILES.'/vim/template',
        \ ]
  let g:sonictemplate_key             = "\<C-g>\<C-y>t"
  let g:sonictemplate_intelligent_key = "\<C-g>\<C-y>T"
  let g:sonictemplate_postfix_key     = "\<C-g>\<C-y>\<C-b>"
endif

if mymisc#plug_tap('nerdtree-git-plugin')
  let g:NERDTreeIndicatorMapCustom = {
        \ 'Modified'  : '!',
        \ 'Staged'    : '+',
        \ 'Untracked' : 'u',
        \ 'Renamed'   : '>',
        \ 'Unmerged'  : '=',
        \ 'Deleted'   : 'x',
        \ 'Dirty'     : '!',
        \ 'Clean'     : '',
        \ 'Ignored'   : 'i',
        \ 'Unknown'   : '?',
        \ }
endif

if mymisc#plug_tap('vim-airline')
  call mymisc#config#airline#setup()
endif

if mymisc#plug_tap('jasegment.vim')
  call mymisc#config#jasegment#setup()
endif

source $MYDOTFILES/vim/scripts/custom_global.vim
