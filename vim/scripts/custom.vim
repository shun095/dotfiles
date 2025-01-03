scriptencoding utf-8

if &compatible
  set nocompatible
en

if mymisc#startup#plug_tap('YouCompleteMe')
  cal mymisc#config#YouCompleteMe#setup()
en

if mymisc#startup#plug_tap('vim-dirvish')
  cal mymisc#config#dirvish#setup()
en

if mymisc#startup#plug_tap('vim-dirvish-git')
  cal mymisc#config#dirvish_git#setup()
en

if mymisc#startup#plug_tap('vim-easymotion')
  let g:EasyMotion_do_mapping = 0
  nmap s <Plug>(easymotion-overwin-f2)
en

if mymisc#startup#plug_tap('foldCC.vim')
  let g:foldCCtext_enable_autofdc_adjuster = 1
  let g:foldCCtext_head = ''
  let g:foldCCtext_tail = 'printf(" %4d lines Lv%-2d", v:foldend-v:foldstart+1, v:foldlevel)'
  set foldtext=FoldCCtext()
en

if mymisc#startup#plug_tap('html5.vim')
  let g:html5_event_handler_attributes_complete = 1
  let g:html5_rdfa_attributes_complete = 1
  let g:html5_microdata_attributes_complete = 1
  let g:html5_aria_attributes_complete = 1
en

if mymisc#startup#plug_tap('markdown-preview.vim')
  let g:mkdp_auto_close = 1
  let g:mkdp_auto_open = 0
  let g:mkdp_auto_start = 0
  if has('win32')
    let s:browser_path='C:\Program Files\Mozilla Firefox\firefox.exe'
    if executable(s:browser_path)
      let g:mkdp_path_to_chrome=shellescape(s:browser_path)
    en
    unlet s:browser_path
  elseif has('mac')
    let g:mkdp_path_to_chrome = 'open'
  else
    let g:mkdp_path_to_chrome = 'xdg-open'
  en
en

if mymisc#startup#plug_tap('memolist.vim')
  cal mymisc#config#memolist#setup()
en

if mymisc#startup#plug_tap('nerdtree')
  cal mymisc#config#nerdtree#setup()
en

if mymisc#startup#plug_tap('fern.vim')
  cal mymisc#config#fern#setup()
en

if mymisc#startup#plug_tap('open-browser.vim')
  let g:netrw_nogx = 1 " disable netrw's gx mapping.
  nmap gx <Plug>(openbrowser-smart-search)
  vmap gx <Plug>(openbrowser-smart-search)
  nno <Leader>Bh :<C-u>OpenBrowser https://
  nno <Leader>Bs :<C-u>OpenBrowserSearch<Space>
  command! -nargs=1 Weblio OpenBrowser http://ejje.weblio.jp/content/<args>
en

if mymisc#startup#plug_tap('previm')
  let g:previm_enable_realtime = 1
  " let g:previm_custom_css_path =
  let g:previm_disable_default_css = 1
  let g:previm_custom_css_path = $MYDOTFILES . "/third-party/github-markdown.css"
  let g:previm_show_header = 0
  fun! s:setup_setting()
    command! -buffer -nargs=? -complete=dir PrevimSaveHTML cal mymisc#previm_save_html('<args>')
  endf

  aug vimrc_previm
    au!
    au FileType *{mkd,markdown,rst,textile}* cal <SID>setup_setting()
  aug END
en

if mymisc#startup#plug_tap('restart.vim')
  let g:restart_sessionoptions = &sessionoptions
en

if mymisc#startup#plug_tap('tagbar')
  nno <silent> <Leader>ta :<C-u>TagbarOpen j<CR>
  let g:tagbar_show_linenumbers = 0
  let g:tagbar_sort = 0
  let g:tagbar_indent = 1
  let g:tagbar_autoshowtag = 1
  let g:tagbar_autopreview = 0
  let g:tagbar_autofocus = 1
  let g:tagbar_autoclose = 0
  " let g:tagbar_width = 30
  aug vimrc_tagbar
    au!
    au FileType help let b:tagbar_ignore = 1
  aug END
en

if mymisc#startup#plug_tap('undotree')
  let g:undotree_WindowLayout = 2
  let g:undotree_SplitWidth = 30
  nno <Leader>gu :<C-u>UndotreeToggle<cr>
en

if mymisc#startup#plug_tap('vim-searchindex')
  aug vimrc_searchindex
    au!
    if has('patch-8.2.3430')
      au ModeChanged *:[vV\x16]* vno * "9y:<C-u>let @/ = '\<'.@9.'\>\C'<CR>/<CR>:<C-u>SearchIndex<CR>
      au ModeChanged *:[vV\x16]* vno g* "9y:<C-u>let @/ = @9.'\C'<CR>/<CR>:<C-u>SearchIndex<CR>
      au ModeChanged *:[vV\x16]* vno # "9y:<C-u>let @/ = '\<'.@9.'\>\C'<CR>?<CR>:<C-u>SearchIndex<CR>
      au ModeChanged *:[vV\x16]* vno g# "9y:<C-u>let @/ = @9.'\C'<CR>?<CR>:<C-u>SearchIndex<CR>
    else
      au VimEnter * vnoremap * "9y:<C-u>let @/ = '\<'.@9.'\>\C'<CR>/<CR>:<C-u>SearchIndex<CR>
      au VimEnter * vnoremap g* "9y:<C-u>let @/ = @9.'\C'<CR>/<CR>:<C-u>SearchIndex<CR>
      au VimEnter * vnoremap # "9y:<C-u>let @/ = '\<'.@9.'\>\C'<CR>?<CR>:<C-u>SearchIndex<CR>
      au VimEnter * vnoremap g# "9y:<C-u>let @/ = @9.'\C'<CR>?<CR>:<C-u>SearchIndex<CR>
    en
  aug END
en

if mymisc#startup#plug_tap('vim-anzu')
  " mapping
  nmap n <Plug>(anzu-n-with-echo)
  nmap N <Plug>(anzu-N-with-echo)

  " vno * "9y:<C-u>let @/ = '\<'.@9.'\>\C'<CR>/<CR>
  " vno g* "9y:<C-u>let @/ = @9.'\C'<CR>/<CR>
  " vno # "9y:<C-u>let @/ = '\<'.@9.'\>\C'<CR>?<CR>
  " vno g# "9y:<C-u>let @/ = @9.'\C'<CR>?<CR>
  " nmap * <Plug>(anzu-star-with-echo)
  " nmap # <Plug>(anzu-sharp-with-echo)
en

if mymisc#startup#plug_tap('vim-easy-align')
  " ヴィジュアルモードで選択し，easy-align 呼んで整形．(e.g. vip<Enter>)
  vmap <Enter> <Plug>(LiveEasyAlign)
  " easy-align を呼んだ上で，移動したりテキストオブジェクトを指定して整形．(e.g. gaip)
  " nmap ga <Plug>(EasyAlign)
  " " Start interactive EasyAlign in visual mode (e.g. vipga)
  " xmap ga <Plug>(EasyAlign)
en

if mymisc#startup#plug_tap('vim-quickrun')
  cal mymisc#config#quickrun#setup()
en

if mymisc#startup#plug_tap('vimshell.vim')
  let g:vimshell_prompt = '% '
  let g:vimshell_secondary_prompt = '> '
  let g:vimshell_user_prompt = 'getcwd()'
en

if mymisc#startup#plug_tap('vimtex')
  cal mymisc#config#vimtex#setup()
en

if mymisc#startup#plug_tap('revimses')
  let g:revimses#sessionoptions = &sessionoptions
en

if mymisc#startup#plug_tap('vim-indent-guides')
  let g:indent_guides_enable_on_vim_startup = 1
  let g:indent_guides_auto_colors = 1
  let g:indent_guides_color_change_percent = 5
en

if mymisc#startup#plug_tap('calendar.vim')
  aug vimrc_calendar
    au!
  aug END

  if mymisc#startup#plug_tap('vim-indent-guides')
    au vimrc_calendar FileType calendar IndentGuidesDisable
  en

  if mymisc#startup#plug_tap('indentLine')
    au vimrc_calendar FileType calendar IndentLinesDisable
  en

  let g:calendar_google_calendar = 1
  let g:calendar_google_task = 1
  let g:calendar_time_zone = '+0900'
  let g:calendar_first_day='sunday'
en

if mymisc#startup#plug_tap('autofmt')
  set formatexpr=autofmt#japanese#formatexpr()
en

if mymisc#startup#plug_tap('vimfiler.vim')
  let g:vimfiler_as_default_explorer = 1
  " cal vimfiler#custom#profile('default', 'context', {
  "       \   'split' : 1,
  "       \   'horizontal' : 0,
  "       \   'direction' : 'topleft',
  "       \   'winwidth' : 35,
  "       \   'simple' : 1
  "       \ })
  " let g:vimfiler_force_overwrite_statusline = 0
  " let g:vimfiler_restore_alternate_file = 0
  nno <silent> <Leader>e :VimFilerBufferDir  -force-quit -split -winwidth=35 -simple -find<CR>
  nno <silent> <Leader>E :VimFilerCurrentDir -force-quit -split -winwidth=35 -simple <CR>
en

if mymisc#startup#plug_tap('defx.nvim')
  cal mymisc#config#defx#setup()
en


if mymisc#startup#plug_tap('ddu.vim')
  cal mymisc#config#ddu#setup()
en

if mymisc#startup#plug_tap('ddc.vim')
  cal mymisc#config#ddc#setup()
en

if mymisc#startup#plug_tap('ctrlp.vim')
  cal mymisc#config#ctrlp#setup()
en

if mymisc#startup#plug_tap('fzf.vim')
  cal mymisc#config#fzf#setup()
en

if mymisc#startup#plug_tap('vim-peekaboo')
  " let g:peekaboo_window = 'vert abo 40new'
  " let g:peekaboo_compact = 1
  " let g:peekaboo_prefix = '<leader>'
  " let g:peekaboo_ins_prefix = '<C-x>'
en

if mymisc#startup#plug_tap('denite.nvim')
  cal mymisc#config#denite#setup()
en

if mymisc#startup#plug_tap('delimitMate')
  let delimitMate_expand_cr = 1
  let delimitMate_expand_space = 1
  let delimitMate_expand_inside_quotes = 1
  let delimitMate_jump_expansion = 1
  let delimitMate_balance_matchpairs = 1
  " imap <silent><expr> <CR> pumvisible() ? "\<C-Y>" : "<Plug>delimitMateCR"
  " aug vimrc_delimitmate
  "   au FileType html,xhtml,phtml let b:delimitMate_autoclose = 0
  " aug END
en

if mymisc#startup#plug_tap('ultisnips')
  if has('unix')
    if has('python3')
      let g:UltiSnipsUsePythonVersion = 3
    elseif has('python')
      let g:UltiSnipsUsePythonVersion = 2
    en
  en

  " To Manage mappgins by my self
  let g:UltiSnipsExpandTrigger       = '<Plug>(RemapUltiSnipsExpandTrigger)'
  let g:UltiSnipsListSnippets        = '<Plug>(RemapUltiSnipsListSnippets)'
  let g:UltiSnipsJumpForwardTrigger  = '<Plug>(RemapUltiSnipsJumpForwardTrigger)'
  let g:UltiSnipsJumpBackwardTrigger = '<Plug>(RemapUltiSnipsJumpBackwardTrigger)'

  smap <silent> <Tab> <Plug>(RemapUltiSnipsJumpForwardTrigger)
  smap <silent> <S-Tab> <Plug>(RemapUltiSnipsJumpBackwardTrigger)
  imap <silent> <expr><S-TAB> pumvisible() ?
        \ "\<C-p>" : "\<C-r>=UltiSnips#JumpBackwards()<CR>"
en

if mymisc#startup#plug_tap('supertab')
  let g:SuperTabDefaultCompletionType = '<c-n>'
en

if mymisc#startup#plug_tap('deoplete.nvim')
  cal mymisc#config#deoplete#setup()
en

if mymisc#startup#plug_tap('ale')
  cal mymisc#config#ale#setup()
en

if mymisc#startup#plug_tap('LanguageClient-neovim')
  cal mymisc#config#LanguageClient#setup()
en

if mymisc#startup#plug_tap('vim-lsp')
  cal mymisc#config#lsp#setup()
en

if mymisc#startup#plug_tap('asyncomplete.vim')
  cal mymisc#config#asyncomplete#setup()
en

if mymisc#startup#plug_tap('clang_complete')
  " let g:clang_library_path='/usr/lib/llvm-3.8/lib'
  let g:clang_complete_auto=0
en

if mymisc#startup#plug_tap('jedi-vim')
  let g:jedi#completions_enabled = 0
  let g:jedi#show_call_signatures = 2
  let g:jedi#auto_initialization = 0
  aug vimrc_jedi
    au!
    au FileType python nno <buffer> <F2> :cal jedi#rename()<CR>
    au FileType python nno <buffer> K :cal jedi#show_documentation()<CR>
    au FileType python nno <buffer> <C-]> :cal jedi#goto()<CR>
    au FileType python setlocal omnifunc=jedi#completions
  aug END
en

if mymisc#startup#plug_tap('omnisharp-vim')
  let g:OmniSharp_selector_ui = 'ctrlp'
  let g:omnicomplete_fetch_full_documentation = 1
  let g:OmniSharp_want_snippet = 0
  let g:OmniSharp_timeout = 5

  if mymisc#startup#plug_tap('deoplete.nvim')
    cal deoplete#custom#source('omnisharp','input_pattern','[^. \t0-9]\.\w*')
  en

  aug omnisharp_commands
    au!
    au FileType cs setlocal omnifunc=OmniSharp#Complete
    au FileType cs OmniSharpHighlightTypes
    au FileType cs setlocal expandtab
    " au CursorHold,CursorHoldI *.cs cal OmniSharp#TypeLookupWithoutDocumentation()
    au FileType cs nno <buffer> <C-]> :OmniSharpGotoDefinition<CR>
    au FileType cs nno <buffer> K :OmniSharpDocumentation<CR>
    au FileType cs nno <buffer> <F2> :OmniSharpRename<CR>
  aug END
en

if mymisc#startup#plug_tap('tsuquyomi')
  let g:tsuquyomi_completion_detail = 1
  let g:tsuquyomi_javascript_support = 1
en

if mymisc#startup#plug_tap('nerdcommenter')
  cal mymisc#config#nerdcommenter#setup()
en

if mymisc#startup#plug_tap('vim-javacomplete2')
  aug vimrc_javacomplete2
    au!
    au Filetype java setlocal omnifunc=javacomplete#Complete
  aug END
en

if mymisc#startup#plug_tap('vim-cpp-enhanced-highlight')
  let g:cpp_class_scope_highlight = 1
  let g:cpp_member_variable_highlight = 1
  let g:cpp_class_decl_highlight = 1
  let g:cpp_concepts_highlight = 1
en

if mymisc#startup#plug_tap('next-alter.vim')
  nmap <F4> <Plug>(next-alter-open)
  aug vimrc_nextalter
    au!
    au BufEnter * let g:next_alter#search_dir = [ expand('%:h'), '.' , '..', './include', '../include', './src', '../src' ]
  aug END
en

if mymisc#startup#plug_tap('auto-pairs')
  let g:AutoPairsMapCR = 0
  let g:AutoPairsFlyMode = 0
  let g:AutoPairsMultilineClose = 1
  let g:AutoPairsShortcutBackInsert = '<C-j>'
en

if mymisc#startup#plug_tap('lexima.vim')
  let g:lexima_ctrlh_as_backspace = 1

  for [begin, end] in [['(', ')'], ['{','}'], ['[',']']]
    cal lexima#add_rule({'char':begin, 'at':'\%#[:alnum:]', 'input':begin})
    cal lexima#add_rule({'char':end,   'at':'\%#\n\s*'.end, 'input':'<CR>'.end, 'delete':end})
  endfor

  for mark in ['"', "'"]
    cal lexima#add_rule({'at': '\%#[:alnum:]', 'char': mark, 'input': mark})
  endfor
en

if mymisc#startup#plug_tap('vim-submode')
  cal mymisc#config#submode#setup()
en

if mymisc#startup#plug_tap('indentLine')
  " let g:indentLine_showFirstIndentLevel=1
en

if mymisc#startup#plug_tap('vim-autoformat')
  let g:autoformat_verbosemode = 1
en

if mymisc#startup#plug_tap('vim-startify')
  let g:startify_files_number = 20
en

if mymisc#startup#plug_tap('vim-devicons')
  let g:WebDevIconsNerdTreeAfterGlyphPadding = ''
  let g:WebDevIconsUnicodeDecorateFolderNodes = 1
en

if mymisc#startup#plug_tap('vim-go')
  let g:go_gocode_propose_builtins = 0
en

if mymisc#startup#plug_tap('gina.vim')
  cabbrev G Gina
  nno <Leader>gs :<C-u>Gina status --opener=split<CR>
  nno <Leader>gc :<C-u>Gina commit --opener=split<CR>
  " nno <Leader>gp :<C-u>Gina push<CR>
  " nno <Leader>gl :<C-u>Gina pull<CR>
  nno <Leader>gf :<C-u>Gina fetch --all -t<CR>
  nno <Leader>gm :<C-u>Gina merge<CR>

  cal gina#custom#mapping#nmap(
        \ 'status', 'q',
        \ ':<C-u>bd<CR><C-w>p',
        \ {'no': 1, 'silent': 0},
        \)
  cal gina#custom#mapping#nmap(
        \ 'commit', 'q',
        \ ':<C-u>bd<CR><C-w>p',
        \ {'no': 1, 'silent': 0},
        \)
  cal gina#custom#mapping#nmap(
        \ 'diff', 'q',
        \ ':<C-u>bd<CR><C-w>p',
        \ {'no': 1, 'silent': 0},
        \)
en

if mymisc#startup#plug_tap('vim-fugitive')
  nno <Leader>gs :<C-u>Git<CR>
  nno <Leader>gc :<C-u>Git checkout<Space>
  nno <Leader>gf :<C-u>Git fetch --all -t<CR>
  nno <Leader>gm :<C-u>Git merge<Space>
en

if mymisc#startup#plug_tap('vim-gitgutter')
  let g:gitgutter_async = 1
  nno <Leader>gg :<C-u>GitGutterAll<CR>
  aug vimrc_gitgutter
    au!
    au User GitGutter cal mymisc#set_statusline_vars()
    au BufWrite * GitGutterAll
  aug END
en

if mymisc#startup#plug_tap('rainbow_parentheses.vim')
  let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{','}']]
  aug vimrc-rainbow
    au!
    au VimEnter * RainbowParentheses
  aug END
  " aug vimrc-rainbow
  "   au!
  "   au VimEnter * RainbowParenthesesToggle
  "   au Syntax * RainbowParenthesesLoadRound
  "   au Syntax * RainbowParenthesesLoadSquare
  "   au Syntax * RainbowParenthesesLoadBraces
  "   au Syntax * RainbowParenthesesLoadChevrons
  " aug END
en

if mymisc#startup#plug_tap('rainbow')
  " let g:rainbow_active = 1
  let g:rainbow_conf = {
        \ 'guifgs': ['#e06c75', '#98c379', '#d19a66', '#61afef', '#c678dd', '#56b6c2'],
        \ 'ctermfgs': [1, 2, 3, 4, 5, 6]
        \ }
en

if mymisc#startup#plug_tap('vim-nerdtree-syntax-highlight')
  " let g:NERDTreeFileExtensionHighlightFullName = 1
  " let g:NERDTreeExactMatchHighlightFullName = 1
  " let g:NERDTreePatternMatchHighlightFullName = 1
  " let g:NERDTreeHighlightFolders = 1 " enables folder icon highlighting using exact match
  " let g:NERDTreeHighlightFoldersFullName = 1 " highlights the folder name
  let g:NERDTreeLimitedSyntax = 1
en

if mymisc#startup#plug_tap('vim-nerdtree-tabs')
  let g:nerdtree_tabs_open_on_gui_startup = 0
en

if mymisc#startup#plug_tap('vim-vue')
  aug vimrc-vue
    au!
    " au FileType vue syntax sync fromstart
    " au BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript.css
  aug END
en

if mymisc#startup#plug_tap('CamelCaseMotion')
  cal camelcasemotion#CreateMotionMappings(',')
en

if mymisc#startup#plug_tap('sonictemplate-vim')
  let g:sonictemplate_vim_template_dir = [
        \ $MYDOTFILES.'/vim/template',
        \ ]
  let g:sonictemplate_key             = "\<C-g>\<C-y>t"
  let g:sonictemplate_intelligent_key = "\<C-g>\<C-y>T"
  let g:sonictemplate_postfix_key     = "\<C-g>\<C-y>\<C-b>"
en

if mymisc#startup#plug_tap('nerdtree-git-plugin')
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
en

if mymisc#startup#plug_tap('vim-airline')
  cal mymisc#config#airline#setup()
en

if mymisc#startup#plug_tap('jasegment.vim')
  cal mymisc#config#jasegment#setup()
en

if mymisc#startup#plug_tap('skkeleton')
  if !filereadable($HOME . '/.skk/SKK-JISYO.L')
    echom "Downloading SKK Dictionary"
    cal system(printf('curl -fLo "%s/.skk/SKK-JISYO.L.gz" --create-dirs https://skk-dev.github.io/dict/SKK-JISYO.L.gz',substitute($HOME,'\','/','g')))
    cal system(printf('gzip -d "%s/.skk/SKK-JISYO.L.gz"',substitute($HOME,'\','/','g')))
  en
  cal skkeleton#config({
        \  'globalDictionaries': [["~/.skk/SKK-JISYO.L", "euc-jp"]],
        \  'eggLikeNewline': v:true,
        \  'sources': ['skk_dictionary', 'google_japanese_input'],
        \})
  imap <C-j> <Plug>(skkeleton-enable)
  cmap <C-j> <Plug>(skkeleton-enable)
en

so $MYDOTFILES/vim/scripts/custom_global.vim
