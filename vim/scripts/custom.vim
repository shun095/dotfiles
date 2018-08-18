scriptencoding utf-8

if &compatible
  set nocompatible
endif

if mymisc#plug_tap('TweetVim')
  " 1ページに表示する最大数
  " let g:tweetvim_tweet_per_page = 100
  " F6と,uvでTweetVimのtimeline選択

  " fork original option
  let g:tweetvim_say_insert_account = 1
  let g:tweetvim_expand_t_co = 1
  let g:tweetvim_display_source = 1
  let g:tweetvim_display_username = 1
  let g:tweetvim_display_icon = 1
  let g:tweetvim_display_separator = 1
  let g:tweetvim_async_post = 1

  " let g:tweetvim_updatetime = 10
  " nnoremap <Leader>Tl :<C-u>Unite tweetvim<CR>
  nnoremap <Leader>Tm :<C-u>TweetVimMentions<CR>
  nnoremap <Leader>Tu :<C-u>TweetVimUserStream<CR>
  nnoremap <Leader>Ts :<C-u>TweetVimSay<CR>
  nnoremap <Leader>Tc :<C-u>TweetVimCommandSay<CR>
  " "tweetvim用
  " augroup mytweetvim
  "   autocmd FileType tweetvim nnoremap <buffer> j gj
  "   autocmd FileType tweetvim nnoremap <buffer> k gk
  " augroup END
endif

if mymisc#plug_tap('YouCompleteMe')
  let g:ycm_global_ycm_extra_conf = $MYDOTFILES . '/vim/scripts/.ycm_extra_conf.py'
  let g:ycm_min_num_of_chars_for_completion = 1
  let g:ycm_complete_in_comments = 1
  let g:ycm_collect_identifiers_from_comments_and_strings = 1
  let g:ycm_collect_identifiers_from_tags_files = 1
  let g:ycm_seed_identifiers_with_syntax = 1
  let g:ycm_add_preview_to_completeopt = 1
  let g:ycm_autoclose_preview_window_after_insertion = 1
  let g:ycm_python_binary_path = 'python'

  let g:ycm_error_symbol = 'E'
  let g:ycm_warning_symbol = 'W'

  let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
  let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
  " autocmd VIMRCCUSTOM FileType python nnoremap <buffer> K :<C-u>YcmCompleter GetDoc<CR>
  nnoremap <leader><c-]> :<C-u>YcmCompleter GoTo<CR>
  nnoremap <leader>} :<C-u>YcmCompleter GoToDefinition<CR>
  nnoremap <leader>{ :<C-u>YcmCompleter GoToDeclaration<CR>
  augroup vimrc_ycm
    autocmd!
    autocmd filetype c,cpp,h,hpp,python nnoremap <buffer>
          \ K :<C-u>YcmCompleter GetDoc<CR>
    autocmd filetype c,cpp,h,hpp,python nnoremap <buffer>
          \ <c-]> :<C-u>YcmCompleter GoTo<CR>
  augroup END
endif

if mymisc#plug_tap('vim-dirvish')
  nnoremap <silent> <Leader>e :exe ":" . <SID>mydirvish_start('%:p:h')<CR>
  nnoremap <silent> <Leader>E :exe ":" . <SID>mydirvish_start('.')<cr>

  fun! s:mydirvish_start(path)
    let save_curpath = 'let w:dirvish_before = [expand("%:p")]'
    return save_curpath . '| Dirvish ' . a:path
  endf

  fun! s:mydirvish_open()
    if len(w:dirvish_before) > 1
      call remove(w:dirvish_before,0,1)
    elseif len(w:dirvish_before) == 1
      call remove(w:dirvish_before,0)
    endif

    call dirvish#open('edit', 0)
  endf

  fun! s:mydirvish_hide_hiddenfiles()
    keeppatterns g@\v[\/]\.[^\/]+[\/]?$@d _
  endf

  fun! s:mydirvish_update_beforelist()
    if len(w:dirvish_before) == 0 || w:dirvish_before[0] !=# expand("%:p") 
      call insert(w:dirvish_before,expand("%:p")) 
    endif
  endf

  fun! s:mydirvish_selectprevdir()
    if len(w:dirvish_before) > 1
      call search('\V\^'.escape(w:dirvish_before[1], '\').'\$', 'cw')
    endif
  endf

  fun! s:mydirvish_quit()
    nmap <buffer> q <plug>(dirvish_quit)
    exe 'normal q'
    if exists('w:dirvish_before')
      unlet w:dirvish_before
    endif
  endf

  " a open("vsplit",1)
  " o open("p",1)
  " o open("split",1)

  augroup vimrc_dirvish
    autocmd!
    autocmd FileType dirvish if !exists('w:dirvish_before') | let w:dirvish_before = [] | endif
    " hとlによる移動
    autocmd FileType dirvish nnoremap <silent><buffer> l :call <SID>mydirvish_open()<CR>
    autocmd FileType dirvish xnoremap <silent><buffer> l :call <SID>mydirvish_open()<CR>
    autocmd FileType dirvish nmap <silent><buffer> h <Plug>(dirvish_up)
    autocmd FileType dirvish xmap <silent><buffer> h <Plug>(dirvish_up)

    autocmd FileType dirvish nnoremap <silent><buffer> <CR> :call <SID>mydirvish_open()<CR>
    autocmd FileType dirvish xnoremap <silent><buffer> <CR> :call <SID>mydirvish_open()<CR>
    autocmd FileType dirvish nnoremap <silent><buffer> i :call <SID>mydirvish_open()<CR>
    autocmd FileType dirvish xnoremap <silent><buffer> i :call <SID>mydirvish_open()<CR>
    " 独自quitスクリプト
    autocmd FileType dirvish nmap <silent><buffer> q :call <SID>mydirvish_quit()<cr>
    " 起動時にソート.行末記号を入れないことで全行ソートする(共通部はソートしない)
    autocmd FileType dirvish silent sort /.*\([\\\/]\)\@=/
    " autocmd FileType dirvish silent keeppatterns g@\v[\/]\.[^\/]+[\/]?$@d
    " .とsに隠しファイルとソートを割り当て
    autocmd FileType dirvish nnoremap <buffer> . :call <SID>mydirvish_hide_hiddenfiles()<CR>
    autocmd FileType dirvish nnoremap <silent><buffer> s :sort /.*\([\\\/]\)\@=/<cr>

    autocmd FileType dirvish nnoremap <silent><buffer> ~ :Dirvish ~/<CR>

    autocmd FileType dirvish nnoremap <silent><buffer> dd :Shdo rm -rf {}<CR>
    autocmd FileType dirvish vnoremap <silent><buffer> d :Shdo rm -rf {}<CR>
    autocmd FileType dirvish nnoremap <silent><buffer> rr :Shdo mv {}<CR>
    autocmd FileType dirvish vnoremap <silent><buffer> r :Shdo mv {}<CR>
    autocmd FileType dirvish nnoremap <silent><buffer> cc :Shdo cp {}<CR>
    autocmd FileType dirvish vnoremap <silent><buffer> c :Shdo cp {}<CR>

    " 開いていたファイルやDirectory(w:dirvish_before)にカーソルをあわせる
    autocmd FileType dirvish call <SID>mydirvish_update_beforelist()
    autocmd FileType dirvish call <SID>mydirvish_selectprevdir()
  augroup END
endif

if mymisc#plug_tap('ctrlp.vim')
  let g:ctrlp_max_files = 20000
  let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:20,results:100'
  let g:ctrlp_show_hidden = 1
  let g:ctrlp_root_markers = ['.ctrlproot']
  let g:ctrlp_mruf_default_order = 1
  let s:ctrlp_my_match_func = {}

  if mymisc#plug_tap('cpsm') " ========== For cpsm
    " let s:cpsm_path = expand('$HOME') . '/.vim/dein/repos/github.com/nixprime/cpsm'
    let s:cpsm_path = expand('$HOME') . '/.vim/plugged/cpsm'

    if !filereadable(s:cpsm_path . '/bin/cpsm_py.pyd') && !filereadable(s:cpsm_path . '/bin/cpsm_py.so')
      echomsg "Cpsm has not been built yet."
    else
      let s:ctrlp_my_match_func = { 'match' : 'cpsm#CtrlPMatch' }
    endif
    let g:cpsm_query_inverting_delimiter = ' '

  elseif mymisc#plug_tap('ctrlp-py-matcher') " ========== For pymatcher
    let s:ctrlp_my_match_func = { 'match' : 'pymatcher#PyMatch' }
  endif

  let g:ctrlp_match_func = s:ctrlp_my_match_func

  augroup vimrc_ctrlp
    autocmd!
    autocmd VimEnter * com! -n=? -com=dir CtrlPMRUFiles let g:ctrlp_match_func = {} |
          \ cal ctrlp#init('mru', { 'dir': <q-args> }) |
          \ let g:ctrlp_match_func = s:ctrlp_my_match_func
  augroup END

  nnoremap <Leader><Leader> :CtrlPMixed<CR>
  nnoremap <Leader>T        :CtrlPTag<CR>
  nnoremap <Leader>al       :CtrlPLine<CR>
  nnoremap <Leader>b        :CtrlPBuffer<CR>
  nnoremap <Leader>c        :CtrlPCurWD<CR>
  nnoremap <Leader>f        :CtrlP<CR>
  " gr
  nnoremap <Leader>l        :CtrlPLine %<CR>
  nnoremap <Leader>o        :CtrlPBufTag<CR>
  nnoremap <Leader>r        :CtrlPRegister<CR>
  nnoremap <Leader>u        :CtrlPMRUFiles<CR>

  let s:ctrlp_command_options = '--hidden --nocolor --nogroup --follow -g ""'

  " if has('win32')
  if g:mymisc_files_is_available
    let g:ctrlp_user_command = 'files -a %s'
  elseif g:mymisc_pt_is_available
    let g:ctrlp_user_command = 'pt ' . s:ctrlp_command_options . ' %s'
  elseif g:mymisc_ag_is_available
    let g:ctrlp_user_command = 'ag ' . s:ctrlp_command_options . ' %s'
  endif
  " else
  "   " Brought from denite 
  "   let g:ctrlp_user_command = 'find -L %s -path "*/.git/*" -prune -o  -type l -print -o -type f -print'
  " endif

  unlet s:ctrlp_command_options
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
  set fillchars=vert:\|
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
    let s:google_chrome_path='C:\Program Files\Mozilla Firefox\firefox.exe'
    if executable(s:google_chrome_path)
      let g:mkdp_path_to_chrome=shellescape(s:google_chrome_path)
    endif
    unlet s:google_chrome_path
  else
    let g:mkdp_path_to_chrome = 'xdg-open'
  endif
endif

if mymisc#plug_tap('memolist.vim')
  " let g:memolist_memo_suffix = 'txt'
  " let g:memolist_unite = 1
  " let g:memolist_denite = 1
  " let g:memolist_vimfiler = 1
  " let g:memolist_vimfiler_option = '-force-quit'
  " let g:memolist_ex_cmd = 'Denite file_rec '
  " if mymisc#plug_tap('nerdtree')
  " let g:memolist_ex_cmd = 'e'
  " endif

  nmap <Leader>mn :MemoNew<cr>
  nmap <Leader>ml :MemoList<cr>
  " nmap <Leader>ml :execute "Denite file_rec -path=" . g:memolist_path<cr>
endif

if mymisc#plug_tap('nerdtree')
  let g:loaded_netrw       = 1
  let g:loaded_netrwPlugin = 1
  nnoremap <Leader>e :NERDTreeFind<CR>
  nnoremap <Leader>E :NERDTreeCWD<CR>

  " let g:NERDTreeMapOpenSplit = 's'
  " let g:NERDTreeMapPreviewSplit = 'gs'
  " let g:NERDTreeMapOpenVSplit = 'v'
  " let g:NERDTreeMapPreviewVSplit = 'gv'

  let g:NERDTreeHijackNetrw = 1
  let g:NERDTreeQuitOnOpen = 0
  let g:NERDTreeShowHidden = 0
  let g:NERDTreeWinSize = 35

  let g:NERDTreeMinimalUI = 1
  let g:NERDTreeShowBookmarks = 1

  let g:NERDTreeIgnore = ['\.meta','\.sw[po]','\.pyc']

  " let g:NERDTreeDirArrowExpandable = '+'
  " let g:NERDTreeDirArrowCollapsible = '-'
endif

if mymisc#plug_tap('open-browser.vim')
  let g:netrw_nogx = 1 " disable netrw's gx mapping.
  nmap gx <Plug>(openbrowser-smart-search)
  vmap gx <Plug>(openbrowser-smart-search)
  nnoremap <Leader>oh :<C-u>OpenBrowser https://
  nnoremap <Leader>os :<C-u>OpenBrowserSearch<Space>
  command! -nargs=1 Weblio OpenBrowser http://ejje.weblio.jp/content/<args>
endif

if mymisc#plug_tap('previm')
  let g:previm_enable_realtime = 1
  " let g:previm_custom_css_path = $HOME . '/.vim/dein/repos/github.com/jasonm23/markdown-css-themes/markdown.css'
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

if mymisc#plug_tap('undotree')
  let g:undotree_WindowLayout = 2
  let g:undotree_SplitWidth = 30
  nnoremap <Leader>gu :<C-u>UndotreeToggle<cr>
endif

if mymisc#plug_tap('vim-anzu')
  " mapping
  nmap n <Plug>(anzu-n-with-echo)
  nmap N <Plug>(anzu-N-with-echo)
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
        \ 'outputter/quickfix/open_cmd' : 'copen 20',
        \ 'hook/inu/enable' : 1,
        \ 'hook/inu/wait' : 1,
        \ 'outputter/buffer/split' : ':botright 20',
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
          \ 'runner/terminal/opener': 'botright 20split',
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
  nnoremap <expr><silent> <C-c> quickrun#is_running() ? <SID>mymisc_quickrun_sweep() : "\<C-c>"

  fun! s:mymisc_quickrun_sweep()
    echo 'Quickrun Sweep'
    call quickrun#sweep_sessions()
  endf
endif

if mymisc#plug_tap('vimshell.vim')
  let g:vimshell_prompt = '% '
  let g:vimshell_secondary_prompt = '> '
  let g:vimshell_user_prompt = 'getcwd()'
endif

if mymisc#plug_tap('vimtex')
  let g:vimtex_compiler_latexmk_engines = { '_' : '-pdfdvi' }
  let g:vimtex_compiler_latexmk = {
        \ 'background' : 1,
        \ 'build_dir' : '',
        \ 'callback' : 1,
        \ 'continuous' : 1,
        \ 'executable' : 'latexmk',
        \ 'options' : [
        \   '-pdfdvi',
        \   '-verbose',
        \   '-file-line-error',
        \   '-synctex=-1',
        \   '-interaction=nonstopmode',
        \ ],
        \}

  if has('win32')
    let g:vimtex_view_general_viewer = 'SumatraPDF'
    let g:vimtex_view_general_options
          \ = '-reuse-instance -forward-search @tex @line @pdf'
          \ . ' -inverse-search "gvim --servername ' . v:servername
          \ . ' --remote-send \"^<C-\^>^<C-n^>'
          \ . ':drop \%f^<CR^>:\%l^<CR^>:normal\! zzzv^<CR^>'
          \ . ':execute ''drop '' . fnameescape(''\%f'')^<CR^>'
          \ . ':\%l^<CR^>:normal\! zzzv^<CR^>'
          \ . ':call remote_foreground('''.v:servername.''')^<CR^>^<CR^>\""'
    let g:vimtex_view_general_options_latexmk = '-reuse-instance'
  elseif has('unix')""
    let g:vimtex_view_general_viewer = 'xdg-open'
  endif
endif

if mymisc#plug_tap('revimses')
  let g:revimses#sessionoptions = &sessionoptions
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

if mymisc#plug_tap('denite.nvim')
  let g:neomru#file_mru_ignore_pattern = '^vaffle\|^quickrun\|'.
        \ '\~$\|\.\%(o\|exe\|dll\|bak\|zwc\|pyc\|sw[po]\)$'.
        \ '\|\%(^\|/\)\.\%(hg\|git\|bzr\|svn\)\%($\|/\)'.
        \ '\|^\%(\\\\\|/mnt/\|/media/\|/temp/\|/tmp/\|\%(/private\)\=/var/folders/\)'.
        \ '\|\%(^\%(fugitive\)://\)'.
        \ '\|\%(^\%(term\)://\)'

  call denite#custom#option('default','auto_resize'            ,'1')
  call denite#custom#option('default','reversed'               ,'1')
  call denite#custom#option('default','highlight_matched_char' ,'Special')
  call denite#custom#option('default','highlight_matched_range','Normal')
  call denite#custom#option('default','updatetime'             ,'10')

  if !exists('g:ctrlp_match_func')
    let g:ctrlp_match_func = {}
  endif

  if g:ctrlp_match_func != {} && g:ctrlp_match_func['match'] ==# 'cpsm#CtrlPMatch'
    let s:denite_matchers = ['matcher_cpsm']
  else
    let s:denite_matchers = ['matcher_fuzzy']
  endif

  call denite#custom#source('file_mru','matchers',s:denite_matchers)
  call denite#custom#source('file_rec','matchers',s:denite_matchers)
  call denite#custom#source('line'    ,'matchers',s:denite_matchers)
  call denite#custom#source('file_mru','sorters' ,[])
  call denite#custom#source('buffer'  ,'sorters' ,[])

  " Change mappings.
  call denite#custom#map('insert','<C-j>' ,'<denite:move_to_next_line>'    ,'noremap')
  call denite#custom#map('insert','<C-k>' ,'<denite:move_to_previous_line>','noremap')
  call denite#custom#map('insert','<Down>','<denite:move_to_next_line>'    ,'noremap')
  call denite#custom#map('insert','<Up>'  ,'<denite:move_to_previous_line>','noremap')
  call denite#custom#map('insert','<C-t>' ,'<denite:do_action:tabopen>'    ,'noremap')
  call denite#custom#map('insert','<C-v>' ,'<denite:do_action:vsplit>'     ,'noremap')
  call denite#custom#map('insert','<C-s>' ,'<denite:do_action:split>'      ,'noremap')
  call denite#custom#map('insert','<C-CR>','<denite:do_action:split>'      ,'noremap')
  call denite#custom#map('insert','<C-x>' ,'<denite:do_action:split>'      ,'noremap')
  call denite#custom#map('insert','<C-g>' ,'<denite:leave_mode>'           ,'noremap')

  " Change file_rec command.
  if g:mymisc_files_is_available
    call denite#custom#var('file_rec','command',['files','-a'])
  elseif g:mymisc_pt_is_available
    call denite#custom#var('file_rec','command',['pt','--follow','--nocolor','--nogroup','--hidden','-g',''])
  elseif g:mymisc_ag_is_available
    call denite#custom#var('file_rec','command',['ag','--follow','--nocolor','--nogroup','--hidden','-g',''])
  endif

  " rg command on grep source
  if g:mymisc_rg_is_available
    call denite#custom#var('grep','command'       ,['rg'])
    call denite#custom#var('grep','default_opts'  ,['--vimgrep'])
    call denite#custom#var('grep','recursive_opts',[])
    call denite#custom#var('grep','pattern_opt'   ,['--regexp'])
    call denite#custom#var('grep','separator'     ,['--'])
    call denite#custom#var('grep','final_opts'    ,[])
  endif

  " Mappings
  nnoremap <silent> <Leader><Leader> :call mymisc#command_at_destdir(expand('%:h'),['DeniteProjectDir file_rec file_mru buffer'])<CR>
  " nnoremap <silent> <Leader>T :<C-u>Denite tag<CR>
  " al
  " nnoremap <silent> <Leader>b :<C-u>Denite buffer<CR>
  nnoremap <silent> <Leader>c :<C-u>Denite file_rec<CR>
  nnoremap <silent> <Leader>f :call mymisc#command_at_destdir(expand('%:h'),['DeniteProjectDir file_rec'])<CR>
  nnoremap <silent> <Leader>gr :<C-u>Denite grep -no-quit<CR>
  " nnoremap <silent> <Leader>l :<C-u>Denite line<CR>
  " nnoremap <silent> <Leader>o :<C-u>Denite outline<CR>
  " nnoremap <silent> <Leader>r :<C-u>Denite register<CR>
  " nnoremap <silent> <Leader>u :<C-u>Denite file_mru<CR>
endif

if mymisc#plug_tap('delimitmate')
  let delimitMate_expand_cr = 1
  let delimitMate_expand_space = 1
  let delimitMate_expand_inside_quotes = 1
  let delimitMate_jump_expansion = 1
  let delimitMate_balance_matchpairs = 1
  imap <silent><expr> <CR> pumvisible() ? "\<C-Y>" : "<Plug>delimitMateCR"
  augroup vimrc_delimitmate
    au FileType html,xhtml,phtml let b:delimitMate_autoclose = 0
  augroup END
endif

if mymisc#plug_tap('ultisnips')
  " better key bindings for UltiSnipsExpandTrigger
  let g:UltiSnipsExpandTrigger = '<Tab>'
  let g:UltiSnipsJumpForwardTrigger = '<Tab>'
  let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'

  if has('unix')
    if has('python3')
      let g:UltiSnipsUsePythonVersion = 3
    elseif has('python')
      let g:UltiSnipsUsePythonVersion = 2
    endif
  endif
endif

if mymisc#plug_tap('supertab')
  let g:SuperTabDefaultCompletionType = '<c-n>'
endif


if mymisc#plug_tap('deoplete.nvim')
  if has('win32') && !exists('g:python3_host_prog')
    let g:python3_host_prog = 'python'
  endif

  " Use deoplete.
  let g:deoplete#enable_at_startup = 1
  " Use smartcase.
  call deoplete#custom#option('smart_case', v:true)

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
  endfunction

  let g:AutoPairsMapCR = 0
  imap <expr><CR> <SID>my_cr_function()
  imap <expr><TAB> <SID>my_tab_function()
  smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
        \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
  imap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
  inoremap <expr><C-Space> deoplete#mappings#manual_complete()

  function! s:my_cr_function() abort
    if pumvisible()
      if neosnippet#expandable()
        echo "Expanding snippet"
        return "\<Plug>(neosnippet_expand)"
      else
        echo "Popup closed"
        return deoplete#close_popup()
      endif
    else
      return "\<CR>\<C-R>=AutoPairsReturn()\<CR>"
    endif
  endfunction

  function! s:my_tab_function() abort
    if pumvisible()
      return "\<C-n>"
    elseif neosnippet#expandable_or_jumpable()
      return "\<Plug>(neosnippet_expand_or_jump)" 
    elseif <SID>check_back_space()
      return "\<TAB>"
    else
      call deoplete#mappings#manual_complete()
      return ""
    endif
  endfunction

  if mymisc#plug_tap('deoplete-clang')
    " let g:deoplete#sources#clang#libclang_path = '/usr/lib/llvm-3.8/lib/libclang.so.1'
    " let g:deoplete#sources#clang#clang_header = '/usr/include/clang/'
  endif

  if mymisc#plug_tap('deoplete-clangx')
    call deoplete#custom#var('clangx', 'clang_binary', '/usr/lib/llvm-6.0/bin/clang')
  endif

  if mymisc#plug_tap('deoplete-jedi')
    let g:deoplete#sources#jedi#server_timeout = 30
  endif

  call deoplete#custom#var('omni', 'input_patterns', {
        \ 'css':        ['\w*'],
        \ 'sass':       ['\w*'],
        \ 'scss':       ['\w*'],
        \})

  call deoplete#custom#var('omni', 'input_patterns', {
        \   'cs':'\w*'
        \ })
endif

if mymisc#plug_tap('ale')
  let g:ale_fixers = {
        \ 'javascript': 'prettier',
        \ 'python': 'autopep8',
        \ 'vue': 'prettier'
        \ }
  let g:ale_fix_on_save = 0
  let g:ale_linters = {
        \ 'cpp': '',
        \ 'python': ''
        \ }
  let g:ale_sign_error = 'E'
  let g:ale_sign_warning = 'W'
endif

if mymisc#plug_tap('LanguageClient-neovim')
  " let g:LanguageClient_waitOutputTimeout = 30
  " let g:LanguageClient_loggingLevel = 'INFO'
  let g:LanguageClient_loggingFile = $HOME.'/languageClient.log'
  let g:LanguageClient_serverStderr = $HOME.'/languageServer.log'
  if has('win32')
    let g:LanguageClient_serverCommands = {
          \ 'javascript': [$APPDATA.'/npm/javascript-typescript-stdio.cmd'],
          \ 'typescript': [$APPDATA.'/npm/javascript-typescript-stdio.cmd'],
          \ 'vue':        [$APPDATA.'/npm/vls.cmd'],
          \ 'cpp':        [$HOME.'/.vim/clangd']
          \ }
  else
    let g:LanguageClient_serverCommands = {
          \ 'javascript': ['javascript-typescript-stdio'],
          \ 'typescript': ['javascript-typescript-stdio'],
          \ 'vue':        ['vls'],
          \ 'cpp':        [$HOME.'/.vim/clangd']
          \ }
  endif
  let g:LanguageClient_diagnosticsDisplay =
        \ {
        \   1: {
        \     "name": "Error",
        \     "texthl": "ALEError",
        \     "signText": "E",
        \     "signTexthl": "ALEErrorSign",
        \   },
        \   2: {
        \     "name": "Warning",
        \     "texthl": "ALEWarning",
        \     "signText": "W",
        \     "signTexthl": "ALEWarningSign",
        \   },
        \   3: {
        \     "name": "Information",
        \     "texthl": "ALEInfo",
        \     "signText": "I",
        \     "signTexthl": "ALEInfoSign",
        \   },
        \   4: {
        \     "name": "Hint",
        \     "texthl": "ALEInfo",
        \     "signText": "H",
        \     "signTexthl": "ALEInfoSign",
        \   },
        \ }
  augroup vimrc_langclient
    autocmd!
    autocmd FileType vue setlocal iskeyword+=$ iskeyword+=-
  augroup END
endif

if mymisc#plug_tap('csscomplete.vim')
  augroup vimrc_csscomplete
    autocmd!
    autocmd InsertEnter *.vue call s:change_omnifunc()
  augroup END

  function! s:change_omnifunc() abort
    let ctx_filetype = context_filetype#get_filetype()
    if ctx_filetype == 'html'
      setl omnifunc=LanguageClient#complete
    elseif ctx_filetype == 'css'
      setl omnifunc=csscomplete#CompleteCSS
    elseif ctx_filetype == 'scss'
      setl omnifunc=csscomplete#CompleteCSS
    elseif ctx_filetype == 'sass'
      setl omnifunc=csscomplete#CompleteCSS
    elseif ctx_filetype == 'javascript'
      setl omnifunc=LanguageClient#complete
    else
      setl omnifunc=htmlcomplete#CompleteTags
    endif
  endfunction
endif

if mymisc#plug_tap('clang_complete')
  " let g:clang_library_path='/usr/lib/llvm-3.8/lib'
  let g:clang_complete_auto=0
endif

if mymisc#plug_tap('jedi-vim')
  let g:jedi#completions_enabled = 0
  let g:jedi#show_call_signatures = 2
  augroup vimrc_jedi
    autocmd!
    autocmd FileType python nnoremap <buffer> <C-]> :call jedi#goto()<CR>
  augroup END
endif

if mymisc#plug_tap('omnisharp-vim')
  augroup omnisharp_commands
    autocmd!
    autocmd FileType cs setlocal omnifunc=OmniSharp#Complete
    " Show type information automatically when the cursor stops moving
    autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()

    " The following commands are contextual, based on the cursor position.
    autocmd FileType cs nnoremap <buffer> <C-]> :OmniSharpGotoDefinition<CR>
    autocmd FileType cs OmniSharpHighlightTypes
    autocmd FileType cs nnoremap <buffer> K :OmniSharpDocumentation<CR>
  augroup END
  nnoremap <F2> :OmniSharpRename<CR>
endif

if mymisc#plug_tap('nerdcommenter')
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

if mymisc#plug_tap('vim-submode')
  augroup vimrc_submode
    autocmd!
    autocmd VimEnter * call g:plugin_mgr.lazy_hook('vim-submode')
  augroup END
endif

if mymisc#plug_tap('indentLine')
  " let g:indentLine_showFirstIndentLevel=1
endif

if mymisc#plug_tap('vim-autoformat')
  let g:autoformat_verbosemode = 0
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

if mymisc#plug_tap('vim-gitgutter')
  let g:gitgutter_async = 1
endif

if mymisc#plug_tap('rainbow_parentheses.vim')
  let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{','}']]
endif

if mymisc#plug_tap('vim-nerdtree-syntax-highlight')
  let g:NERDTreeFileExtensionHighlightFullName = 1
  let g:NERDTreeExactMatchHighlightFullName = 1
  let g:NERDTreePatternMatchHighlightFullName = 1
endif

if mymisc#plug_tap('vim-nerdtree-tabs')
  let g:nerdtree_tabs_open_on_gui_startup = 0
endif

if mymisc#plug_tap('vim-vue')
  augroup vimrc-vue
    autocmd!
    autocmd FileType vue syntax sync fromstart
    " autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript.css
  augroup END
endif

