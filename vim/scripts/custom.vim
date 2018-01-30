scriptencoding utf-8

if &compatible
  set nocompatible
endif

if myvimrc#plug_tap('TweetVim')
  " 1ページに表示する最大数
  " let g:tweetvim_tweet_per_page = 100
  " F6と,uvでTweetVimのtimeline選択


  " fork original option
  let g:tweetvim_panewidth = 40
  let g:tweetvim_say_insert_account = 1
  let g:tweetvim_expand_t_co = 1
  let g:tweetvim_open_buffer_cmd = g:tweetvim_panewidth . 'vsplit!'
  let g:tweetvim_display_source = 1
  let g:tweetvim_display_username = 1
  let g:tweetvim_display_icon = 1
  let g:tweetvim_display_separator = 1
  let g:tweetvim_async_post = 1
  let g:tweetvim_buffer_name = 'TweetVimBuffer'
  let g:tweetvim_default_account = 'NUSH06'


  " let g:tweetvim_updatetime = 10
  " nnoremap <Leader>Tl :<C-u>Unite tweetvim<CR>
  nnoremap <Leader>Tm :<C-u>TweetVimMentions<CR>
  nnoremap <Leader>Tu :<C-u>TweetVimUserStream<CR>
  nnoremap <Leader>Ts :<C-u>TweetVimSay<CR>
  nnoremap <Leader>Tc :<C-u>TweetVimCommandSay<CR>
  " "tweetvim用
  " augroup mytweetvim
  " 	autocmd FileType tweetvim nnoremap <buffer> j gj
  " 	autocmd FileType tweetvim nnoremap <buffer> k gk
  " augroup END
endif

if myvimrc#plug_tap('YouCompleteMe')
  let g:ycm_global_ycm_extra_conf = $MYDOTFILES . '/vim/scripts/.ycm_extra_conf.py'
  let g:ycm_min_num_of_chars_for_completion = 1
  let g:ycm_complete_in_comments = 1
  let g:ycm_collect_identifiers_from_comments_and_strings = 1
  let g:ycm_collect_identifiers_from_tags_files = 1
  let g:ycm_seed_identifiers_with_syntax = 1
  let g:ycm_add_preview_to_completeopt = 1
  let g:ycm_autoclose_preview_window_after_insertion = 1
  let g:ycm_python_binary_path = 'python'

  let g:ycm_error_symbol = ''
  let g:ycm_warning_symbol = ''

  let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
  let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
  " autocmd VIMRCCUSTOM FileType python nnoremap <buffer> K :<C-u>YcmCompleter GetDoc<CR>
  nnoremap <leader><c-]> :<C-u>YcmCompleter GoTo<CR>
  nnoremap <leader>} :<C-u>YcmCompleter GoToDefinition<CR>
  nnoremap <leader>{ :<C-u>YcmCompleter GoToDeclaration<CR>
  augroup vimrc_ycm
    autocmd filetype python nnoremap <buffer> K :<C-u>YcmCompleter GetDoc<CR><C-w>P:<C-u>set ft=rst<CR>
  augroup END
endif

if myvimrc#plug_tap('ctrlp.vim')
  " let g:ctrlp_cmd = 'CtrlPMRUFiles'
  " yankroundのところでマッピングし直している
  " let g:ctrlp_map = ''
  " let g:ctrlp_extensions = ['mixed']
  let g:ctrlp_max_files = 50000
  let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:100'
  let g:ctrlp_show_hidden = 1
  let g:ctrlp_root_markers = ['.ctrlproot']
  let g:ctrlp_mruf_default_order = 1
  " let g:ctrlp_user_command_async = 1
  " if has('unix')
  " let s:ctrlp_my_match_func = {}
  let s:ctrlp_my_match_func = {}

  if myvimrc#plug_tap('cpsm')
    " ========== For cpsm ==========
    " let s:cpsm_path = expand('$HOME') . '/.vim/dein/repos/github.com/nixprime/cpsm'
    let s:cpsm_path = expand('$HOME') . '/.vim/plugged/cpsm'

    fun! s:cpsm_build()
      let s:cpsm_install_confirm = confirm('Build cpsm now?',"&yes\n&no",2)

      if s:cpsm_install_confirm == 1
        if has('win32')
          exe '!' . $MYDOTFILES . '/tools/cpsm_winmake.bat'
        else
          if !isdirectory(s:cpsm_path . '/bin')
            call mkdir(s:cpsm_path . '/bin')
          endif
          exe '!pushd ' . s:cpsm_path . '/bin; cmake -DPY3=ON ..; make -j'
        endif

        if v:shell_error == 0
          let s:ctrlp_my_match_func = { 'match' : 'cpsm#CtrlPMatch' }
        else
          echoerr 'Couldn''t build cpsm correctly. Please build cpsm later.'
        endif
      else
        echomsg 'Please build cpsm later.'
      endif
    endf

    if !filereadable(s:cpsm_path . '/bin/cpsm_py.pyd') && !filereadable(s:cpsm_path . '/bin/cpsm_py.so')
      augroup vimrc_cpsm
        autocmd VimEnter * call s:cpsm_build()
      augroup END
    else
      let s:ctrlp_my_match_func = { 'match' : 'cpsm#CtrlPMatch' }
    endif
    let g:cpsm_query_inverting_delimiter = ' '
  elseif myvimrc#plug_tap('ctrlp-py-matcher')
    let s:ctrlp_my_match_func = { 'match' : 'pymatcher#PyMatch' }
  endif
  let g:ctrlp_match_func = s:ctrlp_my_match_func

  augroup vimrc_ctrlp
    autocmd VimEnter * com! -n=? -com=dir CtrlPMRUFiles let g:ctrlp_match_func = {} |
          \ cal ctrlp#init('mru', { 'dir': <q-args> }) |
          \ let g:ctrlp_match_func = s:ctrlp_my_match_func
  augroup END

  nnoremap <Leader><Leader> :CtrlP<CR>
  nnoremap <Leader>T        :CtrlPBufTag<CR>
  nnoremap <Leader>al       :CtrlPLine<CR>
  nnoremap <Leader>b        :CtrlPBuffer<CR>
  nnoremap <Leader>c        :CtrlPCurWD<CR>
  nnoremap <Leader>l        :CtrlPLine %<CR>
  nnoremap <Leader>mr       :CtrlPMRUFiles<CR>
  nnoremap <Leader>r        :CtrlPRegister<CR>

  let s:ctrlp_command_options = '--hidden --nocolor --nogroup --follow -g ""'

  if has('win32')
    if g:myvimrc_files_isAvalable
      let g:ctrlp_user_command = 'files -a %s'
    elseif g:myvimrc_pt_isAvalable
      let g:ctrlp_user_command = 'pt ' . s:ctrlp_command_options . ' %s'
    elseif g:myvimrc_ag_isAvalable
      let g:ctrlp_user_command = 'ag ' . s:ctrlp_command_options . ' %s'
    endif
  else
    " Brought from denite 
    let g:ctrlp_user_command = 'find -L %s -path "*/.git/*" -prune -o  -type l -print -o -type f -print'
  endif

  unlet s:ctrlp_command_options
endif

if myvimrc#plug_tap('foldCC.vim')
  let g:foldCCtext_enable_autofdc_adjuster = 1
  let g:foldCCtext_head = ''
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

if myvimrc#plug_tap('html5.vim')
  let g:html5_event_handler_attributes_complete = 1
  let g:html5_rdfa_attributes_complete = 1
  let g:html5_microdata_attributes_complete = 1
  let g:html5_aria_attributes_complete = 1
endif

if myvimrc#plug_tap('markdown-preview.vim')
  let g:mkdp_auto_close = 0
  let g:mkdp_auto_open = 0
  let g:mkdp_auto_start = 0
  if has('win32')
    let s:google_chrome_path='C:\Program Files\Mozilla Firefox\firefox.exe'
    if executable(s:google_chrome_path)
      let g:mkdp_path_to_chrome=shellescape(s:google_chrome_path)
    endif
    unlet s:google_chrome_path
  else
    let g:mkdp_path_to_chrome = 'firefox'
  endif
endif

if myvimrc#plug_tap('memolist.vim')
  " let g:memolist_memo_suffix = 'txt'
  " let g:memolist_unite = 1
  " let g:memolist_denite = 1
  " let g:memolist_ex_cmd = 'Denite file_rec '
  " if myvimrc#plug_tap('nerdtree')
  " let g:memolist_ex_cmd = 'e'
  " endif

  nmap <Leader>mn :MemoNew<cr>
  nmap <Leader>ml :MemoList<cr>
  " nmap <Leader>ml :execute "Denite file_rec -path=" . g:memolist_path<cr>
endif

if myvimrc#plug_tap('nerdtree')
  nnoremap <Leader>e :NERDTreeFind<CR>
  nnoremap <Leader>E :NERDTreeCWD<CR>

  let g:NERDTreeHijackNetrw = 1
  let g:NERDTreeQuitOnOpen = 1
  let g:NERDTreeShowHidden = 0
  let g:NERDTreeWinSize = 40

  let NERDTreeMinimalUI = 1
  let NERDTreeShowBookmarks = 1
  let NERDTreeIgnore = ['\~$', '\.pyc$', '\.sw[po]$']
endif

if myvimrc#plug_tap('open-browser.vim')
  let g:netrw_nogx = 1 " disable netrw's gx mapping.
  nmap gx <Plug>(openbrowser-smart-search)
  vmap gx <Plug>(openbrowser-smart-search)
  nnoremap <Leader>oh :<C-u>OpenBrowser https://
  nnoremap <Leader>os :<C-u>OpenBrowserSearch<Space>
endif

if myvimrc#plug_tap('previm')
  let g:previm_enable_realtime = 1
  " let g:previm_custom_css_path = $HOME . '/.vim/dein/repos/github.com/jasonm23/markdown-css-themes/markdown.css'
  let g:previm_show_header = 0
  function! s:setup_setting()
    command! -buffer -nargs=? -complete=dir PrevimSaveHTML call myvimrc#previm_save_html('<args>')
  endfunction

  augroup vimrc_previm
    autocmd!
    autocmd FileType *{mkd,markdown,rst,textile}* call <SID>setup_setting()
  augroup END
endif

if myvimrc#plug_tap('restart.vim')
  let g:restart_sessionoptions = &sessionoptions
endif

if myvimrc#plug_tap('supertab')
  let g:SuperTabDefaultCompletionType = '<c-n>'
endif

if myvimrc#plug_tap('tagbar')
  nnoremap <silent> <Leader>t :TagbarOpen j<CR>
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

if myvimrc#plug_tap('ultisnips')
  " better key bindings for UltiSnipsExpandTrigger
  let g:UltiSnipsExpandTrigger = '<c-j>'
  let g:UltiSnipsJumpForwardTrigger = '<c-j>'
  let g:UltiSnipsJumpBackwardTrigger = '<c-k>'

  if has('unix')
    if has('python3')
      let g:UltiSnipsUsePythonVersion = 3
    elseif has('python')
      let g:UltiSnipsUsePythonVersion = 2
    endif
  endif
endif

if myvimrc#plug_tap('undotree')
  let g:undotree_WindowLayout = 2
  let g:undotree_SplitWidth = 30
  nnoremap <Leader>gu :<C-u>UndotreeToggle<cr>
endif

if myvimrc#plug_tap('vim-anzu')
  " mapping
  nmap n <Plug>(anzu-n-with-echo)
  nmap N <Plug>(anzu-N-with-echo)
  nmap * <Plug>(anzu-star-with-echo)
  nmap # <Plug>(anzu-sharp-with-echo)
endif

if myvimrc#plug_tap('vim-easy-align')
  " ヴィジュアルモードで選択し，easy-align 呼んで整形．(e.g. vip<Enter>)
  vmap <Enter> <Plug>(LiveEasyAlign)
  " easy-align を呼んだ上で，移動したりテキストオブジェクトを指定して整形．(e.g. gaip)
  " nmap ga <Plug>(EasyAlign)
  " " Start interactive EasyAlign in visual mode (e.g. vipga)
  " xmap ga <Plug>(EasyAlign)
endif

if myvimrc#plug_tap('vim-quickrun')
  " quickrun modules
  " quickrun-hook-add-include-option {{{
  let s:hook = {
        \ 'name': 'add_include_option',
        \ 'kind': 'hook',
        \ 'config': {
        \   'enable': 0,
        \   },
        \ }

  function! s:hook.on_module_loaded(session, context)
    let l:clang_complete = findfile(".clang_complete",".;")
    let a:session.config.cmdopt .= ' '.join(readfile(l:clang_complete))

    let paths = filter(split(&path, ','), "len(v:val) && v:val !=#'.' && v:val !~# 'mingw'")
    if len(paths)
      let a:session.config.cmdopt .= ' -I'.join(paths, ' -I')
    endif
  endfunction

  try
    call quickrun#module#register(s:hook, 1)
  catch
    echom v:exception
  endtry
  unlet s:hook
  " }}}

  let g:quickrun_no_default_key_mappings = 1
  let g:quickrun_config = get(g:, 'quickrun_config', {})
  let g:quickrun_config['_'] = {
        \ 'hook/close_quickfix/enable_hook_loaded' : 1,
        \ 'hook/close_quickfix/enable_success' : 1,
        \ 'hook/close_buffer/enable_hook_loaded' : 1,
        \ 'hook/close_buffer/enable_failure' : 1,
        \ 'outputter' : 'multi:buffer:quickfix',
        \ 'outputter/quickfix/open_cmd' : 'copen 8',
        \ 'hook/inu/enable' : 1,
        \ 'hook/inu/wait' : 1,
        \ 'outputter/buffer/split' : ':botright 8',
        \ 'runner' : 'vimproc',
        \ 'runner/vimproc/updatetime' : 100,
        \ }

  if has('job')
    call extend(g:quickrun_config['_'], {
          \ 'runner' : 'job',
          \ 'runner/job/interval' : 100,
          \ })
  endif

  if has('terminal')
    call extend(g:quickrun_config['_'], {
          \ 'runner' : 'terminal',
          \ 'runner/terminal/opener': 'botright 8split',
          \ 'runner/terminal/into': 1
          \ })
  endif

  let g:quickrun_config['python'] = {
        \ 'command' : 'python',
        \ 'cmdopt' : '-u',
        \ }
  let g:quickrun_config['markdown'] = {
        \ 'type': 'markdown/pandoc',
        \ 'cmdopt': '-s',
        \ 'outputter' : 'multi:buffer:quickfix:browser'
        \ }
  let g:quickrun_config['cpp'] = {
        \ 'hook/add_include_option/enable' : 1
        \ }

  if has('win32')
    let s:quickrun_win_config = get(g:, 'quickrun_win_config', {})
    let s:quickrun_win_config['cpp'] = {
          \ 'exec' : ['%c %o %s -o %s:p:r' . '.exe', '%s:p:r' . '.exe %a'],
          \ }
    call extend(g:quickrun_config['cpp'], s:quickrun_win_config['cpp'])
    unlet s:quickrun_win_config
  endif

  nmap <silent> <Leader>R :CdCurrent<CR><Plug>(quickrun)
  nnoremap <expr><silent> <C-c> quickrun#is_running() ? <SID>myvimrc_quickrun_sweep() : "\<C-c>"

  fun! s:myvimrc_quickrun_sweep()
    echo 'Quickrun Sweep'
    call quickrun#sweep_sessions()
  endf
endif

if myvimrc#plug_tap('vimshell.vim')
  let g:vimshell_prompt = '% '
  let g:vimshell_secondary_prompt = '> '
  let g:vimshell_user_prompt = 'getcwd()'
endif

if myvimrc#plug_tap('vimtex')
  if has('win32')
    let g:vimtex_latexmk_continuous = 1
    let g:vimtex_latexmk_background = 1
    "let g:vimtex_latexmk_options = '-pdf'
    let g:vimtex_latexmk_options = '-pdfdvi'
    "let g:vimtex_latexmk_options = '-pdfps'
    let g:vimtex_view_general_viewer = 'SumatraPDF.exe'
    let g:vimtex_view_general_options =
          \ '-reuse-instance -inverse-search "\"' . $VIM . '\gvim.exe\" -n --remote-silent +\%l \"\%f\"" -forward-search @tex @line @pdf'
    let g:vimtex_view_general_options_latexmk = '-reuse-instance'
    "let g:vimtex_view_general_viewer = 'texworks'
  elseif has('unix')""
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

if myvimrc#plug_tap('revimses')
  let g:revimses#sessionoptions = &sessionoptions
endif

if myvimrc#plug_tap('calendar.vim')
  augroup vimrc_calendar
    autocmd!
  augroup END

  if myvimrc#plug_tap('vim-indent-guides')
    autocmd vimrc_calendar FileType calendar IndentGuidesDisable
  endif

  if myvimrc#plug_tap('indentLine')
    autocmd vimrc_calendar FileType calendar IndentLinesDisable
  endif

  let g:calendar_google_calendar = 1
  let g:calendar_google_task = 1
  let g:calendar_time_zone = '+0900'
  let g:calendar_first_day='sunday'
endif

if myvimrc#plug_tap('autofmt')
  set formatexpr=autofmt#japanese#formatexpr()
endif

if myvimrc#plug_tap('denite.nvim')
  if has('job')
    call timer_start(100, 'async_custom#denite',{'repeat':1})
  else
    augroup vimrc_denite
      autocmd!
      autocmd VimEnter * call async_custom#denite()
    augroup END
  endif
  " Change file_rec command.
  if g:myvimrc_files_isAvalable
    call denite#custom#var('file_rec', 'command', ['files', '-a'])
  elseif g:myvimrc_pt_isAvalable
    call denite#custom#var('file_rec','command',['pt','--follow','--nocolor','--nogroup','--hidden','-g',''])
  elseif g:myvimrc_ag_isAvalable
    call denite#custom#var('file_rec','command',['ag','--follow','--nocolor','--nogroup','--hidden','-g',''])
  endif

  if !exists('g:ctrlp_match_func')
    let g:ctrlp_match_func = {}
  endif

  call denite#custom#source('file_mru', 'sorters', [])
  call denite#custom#source('buffer', 'sorters', [])
  " change matchers
  call denite#custom#source('file_mru','matchers',['matcher_fuzzy'])
  call denite#custom#source('file_rec','matchers',['matcher_fuzzy'])
  call denite#custom#source('line',    'matchers',['matcher_fuzzy'])
  if g:ctrlp_match_func != {} && g:ctrlp_match_func['match'] ==# 'cpsm#CtrlPMatch'
    call denite#custom#source('file_mru','matchers',['matcher_cpsm'])
    call denite#custom#source('file_rec','matchers',['matcher_cpsm'])
    call denite#custom#source('line',    'matchers',['matcher_cpsm'])
  endif
  " Change mappings.
  call denite#custom#map('insert','<C-j>','<denite:move_to_next_line>',    'noremap')
  call denite#custom#map('insert','<C-k>','<denite:move_to_previous_line>','noremap')
  " rg command on grep source
  if g:myvimrc_rg_isAvalable
    call denite#custom#var('grep', 'command', ['rg'])
    call denite#custom#var('grep', 'default_opts', ['--vimgrep'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])
  endif
  " mappgins
  nnoremap <silent> <Leader>db :<C-u>Denite buffer<CR>
  nnoremap <silent> <Leader>dT :<C-u>Denite tag<CR>
  nnoremap <silent> <Leader>dc :<C-u>Denite file_rec<CR>
  nnoremap <silent> <Leader>dg :<C-u>Denite grep -no-quit<CR>
  nnoremap <silent> <Leader>dl :<C-u>Denite line<CR>
  nnoremap <silent> <Leader>dmr :<C-u>Denite file_mru<CR>
  nnoremap <silent> <Leader>do :<C-u>Denite outline<CR>
  nnoremap <silent> <Leader>dr :<C-u>Denite register<CR>
  nnoremap <silent> <leader>d<Leader> :call myvimrc#command_at_destdir(expand('%:h'),['DeniteProjectDir file_rec'])<CR>

  if exists('g:memolist_path')
    exe 'nnoremap <silent> <Leader>ml :<C-u>Denite file_rec -path='. g:memolist_path. '<CR>'
  endif
endif

if myvimrc#plug_tap('deoplete.nvim')
  let g:deoplete#enable_at_startup = 1
  let g:deoplete#auto_complete_start_length = 1
  if myvimrc#plug_tap('deoplete-clang')
    let g:deoplete#sources#clang#libclang_path = '/usr/lib/llvm-3.8/lib/libclang.so.1'
    let g:deoplete#sources#clang#clang_header = '/usr/include/clang/'
  endif
  if myvimrc#plug_tap('deoplete-jedi')
    let g:deoplete#sources#jedi#server_timeout = 30
  endif
endif

if myvimrc#plug_tap('clang_complete')
  let g:clang_library_path='/usr/lib/llvm-3.8/lib'
endif

if myvimrc#plug_tap('jedi-vim')
  if myvimrc#plug_tap('deoplete-jedi')
    let g:jedi#completions_enabled = 0
  endif
  let g:jedi#show_call_signatures = 2
endif


if myvimrc#plug_tap('nerdcommenter')
  let g:NERDSpaceDelims = 1
  xmap gcc <Plug>NERDCommenterComment
  nmap gcc <Plug>NERDCommenterComment
  xmap gcn <Plug>NERDCommenterNested
  nmap gcn <Plug>NERDCommenterNested
  xmap gc<space> <Plug>NERDCommenterToggle
  nmap gc<space> <Plug>NERDCommenterToggle
  xmap gcm <Plug>NERDCommenterMinimal
  nmap gcm <Plug>NERDCommenterMinimal
  xmap gci <Plug>NERDCommenterInvert
  nmap gci <Plug>NERDCommenterInvert
  xmap gcs <Plug>NERDCommenterSexy
  nmap gcs <Plug>NERDCommenterSexy
  xmap gcy <Plug>NERDCommenterYank
  nmap gcy <Plug>NERDCommenterYank
  nmap gc$ <Plug>NERDCommenterToEOL
  nmap gcA <Plug>NERDCommenterAppend
  nmap gca <Plug>NERDCommenterAltDelims
  xmap gcl <Plug>NERDCommenterAlignLeft
  nmap gcl <Plug>NERDCommenterAlignLeft
  xmap gcb <Plug>NERDCommenterAlignBoth
  nmap gcb <Plug>NERDCommenterAlignBoth
  xmap gcu <Plug>NERDCommenterUncomment
  nmap gcu <Plug>NERDCommenterUncomment
endif

if myvimrc#plug_tap('vim-javacomplete2')
  autocmd Filetype java setlocal omnifunc=javacomplete#Complete
endif

if myvimrc#plug_tap('vim-cpp-enhanced-highlight')
  let g:cpp_class_scope_highlight = 1
  let g:cpp_member_variable_highlight = 1
  let g:cpp_class_decl_highlight = 1
  let g:cpp_concepts_highlight = 1
endif

if myvimrc#plug_tap('next-alter.vim')
  nmap <F4> <Plug>(next-alter-open)
  augroup vimrc_nextalter
    autocmd!
    autocmd BufEnter * let g:next_alter#search_dir = [ expand('%:h'), '.' , '..', './include', '../include', './src', '../src' ]
  augroup END
endif

if myvimrc#plug_tap('vim-submode')
  augroup vimrc_submode
    autocmd VimEnter * call g:plugin_mgr.lazy_hook('vim-submode')
  augroup END
endif

if myvimrc#plug_tap('indentLine')
  " let g:indentLine_showFirstIndentLevel=1
endif

if myvimrc#plug_tap('delimitmate')
  let delimitMate_expand_cr = 1
  let delimitMate_expand_space = 1
  let delimitMate_expand_inside_quotes = 1
  let delimitMate_jump_expansion = 1
  let delimitMate_balance_matchpairs = 1
  imap <silent><expr> <CR> pumvisible() ? "\<C-Y>" : "<Plug>delimitMateCR"
endif

if myvimrc#plug_tap('vim-autoformat')
  let g:autoformat_verbosemode = 0
endif

if myvimrc#plug_tap('vim-startify')
  let g:startify_files_number = 20
endif

if myvimrc#plug_tap('vim-devicons')
  let g:webdevicons_enable = 1
  let g:webdevicons_enable = 1
  let g:webdevicons_enable_nerdtree = 1
  let g:webdevicons_enable_ctrlp = 1
  let g:WebDevIconsNerdTreeAfterGlyphPadding = ''
endif

if myvimrc#plug_tap('ale')
  let g:ale_fixers = {
        \ 'javascript': 'eslint',
        \ 'python': 'autopep8'
        \ }
  let g:ale_fix_on_save = 1
  let g:ale_linters = {
        \ 'cpp': '',
        \ }
  let g:ale_sign_error = ''
  let g:ale_sign_warning = ''
endif
