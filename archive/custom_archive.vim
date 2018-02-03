if myvimrc#plug_tap('vim-devicons')
  let g:webdevicons_enable_nerdtree = 1
  let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '
  let g:WebDevIconsUnicodeDecorateFolderNodes = 1
  let g:DevIconsEnableFoldersOpenClose = 1
  let g:DevIconsEnableFolderExtensionPatternMatching = 1
endif

if myvimrc#plug_tap('unite.vim')
  nnoremap <silent> <Leader>ub :<C-u>Unite buffer<CR>
  " if has('win32')
  nnoremap <silent> <Leader>uf :call myvimrc#command_at_destdir(expand('%:h'),['UniteWithProjectDir file_rec'])<CR>
  " else
  " nnoremap <silent> <Leader>uf :call myvimrc#command_at_destdir(expand('%:h'),['UniteWithProjectDir file_rec/async'])<CR>
  " endif
  nnoremap <silent> <Leader>uc :<C-u>Unite file_rec<CR>
  nnoremap <silent> <Leader>ul :<C-u>Unite line<CR>
  nnoremap <silent> <Leader>ug :<C-u>UniteWithProjectDir grep<CR>
  nnoremap <silent> <Leader>ur :<C-u>Unite register<CR>
  nnoremap <silent> <Leader>um :<C-u>Unite file_mru<CR>
  " UniteOutLine
  nnoremap <silent> <Leader>uo :<C-u>Unite -vertical -no-quit -winwidth=40 outline -direction=botright<CR>
  let g:unite_force_overwrite_statusline = 0
  " call unite#filters#sorter_default#use(['sorter_length'])
  " call unite#custom#profile('default', 'context', {
  " \	'start_insert': 1,
  " \	'winheight': 10,
  " \	'direction': 'botright'
  " \ })
  " ウィンドウを分割して開く
  augroup vimrc_unite
    autocmd!
    " autocmd FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
    " autocmd FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
    " " ウィンドウを縦に分割して開く
    " autocmd FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
    " autocmd FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
    " " タブで開く
    " autocmd FileType unite nnoremap <silent> <buffer> <expr> <C-t> unite#do_action('tabopen')
    " autocmd FileType unite inoremap <silent> <buffer> <expr> <C-t> unite#do_action('tabopen')
    " ESCキーを2回押すと終了する
    autocmd FileType unite nmap <silent> <buffer> <ESC><ESC> <Plug>(unite_exit)
    autocmd FileType unite imap <silent> <buffer> <ESC><ESC> <Plug>(unite_exit)
    autocmd FileType unite imap <silent> <buffer> <C-j> <Plug>(unite_select_next_line)
    autocmd FileType unite imap <silent> <buffer> <C-k> <Plug>(unite_select_previous_line)
    autocmd FileType unite imap <silent> <buffer> <Tab> <Plug>(unite_complete)
    autocmd FileType unite imap <silent> <buffer> <C-Tab> <Plug>(unite_choose_action)
    autocmd FileType unite call unite#filters#matcher_default#use(['matcher_fuzzy'])
  augroup END
  let g:unite_source_history_yank_enable = 1
  " if has('win32')
  " 	let g:unite_source_rec_async_command =
  " 				\ ['dir', '/-n /b /s /a-d | findstr /v /l ".jpg \\tmp\\ .git\\ .svn\\ .hg\\"']
  " else
  " 	let g:unite_source_rec_async_command =
  " 				\ ['find', '-type f | grep -v -P "\.git/|\.svn/|\.hg/|\.jpg$|/tmp/"']
  " endif
  "nice unite and ag
  " let g:unite_source_rec_async_command =
  " 			\ ['ag', '--follow', '--nocolor', '--nogroup',
  " 			\  '--hidden', '-g', '']
  let g:unite_source_rec_max_cache_files = 20000
  let g:unite_source_rec_min_cache_files = 10
  " search a file in the filetree
  " nnoremap <space><space> :<C-u>Unite -start-insert file_rec/async<cr>
  " reset not it is <C-l> normally
  " nnoremap <space>r <Plug>(unite_restart)
endif

if myvimrc#plug_tap('vim-airline')
  let g:airline#extensions#tagbar#enabled            = 0
  let g:airline#extensions#branch#enabled            = 1
  let g:airline#extensions#branch#empty_message      = ''
  " let g:airline#extensions#whitespace#checks	 = [ 'indent',  'mixed-indent-file' ]
  let g:airline#extensions#syntastic#enabled         = 0
  let g:airline#extensions#tabline#enabled           = 1 "{{{
  " right side show mode
  let g:airline#extensions#tabline#show_tab_type     = 0
  " プレビューウィンドウのステータスライン(Airline優先:0か,他のプラグイン優先:1)
  let g:airline#extensions#tabline#exclude_preview   = 0

  let g:airline#extensions#tabline#show_tabs         = 1
  let g:airline#extensions#tabline#show_splits       = 0
  let g:airline#extensions#tabline#show_buffers      = 0
  let g:airline#extensions#tabline#tab_nr_type       = 2 " splits and tab number
  let g:airline#extensions#tabline#show_close_button = 0 "}}}

  let g:airline#extensions#tabline#buffer_idx_mode = 1
  nmap <leader>1 <Plug>AirlineSelectTab1
  nmap <leader>2 <Plug>AirlineSelectTab2
  nmap <leader>3 <Plug>AirlineSelectTab3
  nmap <leader>4 <Plug>AirlineSelectTab4
  nmap <leader>5 <Plug>AirlineSelectTab5
  nmap <leader>6 <Plug>AirlineSelectTab6
  nmap <leader>7 <Plug>AirlineSelectTab7
  nmap <leader>8 <Plug>AirlineSelectTab8
  nmap <leader>9 <Plug>AirlineSelectTab9

  " let g:airline_powerline_fonts=1
  if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif
  " powerline symbols" {{{
  " if has('win32') && (!has('gui_running'))
    let g:airline_left_sep                         = ''
    let g:airline_left_alt_sep                     = ''
    let g:airline_right_sep                        = ''
    let g:airline_right_alt_sep                    = ''
    let g:airline_symbols.branch                   = ''
  " else
    " let g:airline#extensions#tabline#left_sep      = '⮀'
    " let g:airline#extensions#tabline#left_alt_sep  = '⮁'
    " let g:airline#extensions#tabline#right_sep     = '⮂'
    " let g:airline#extensions#tabline#right_alt_sep = '⮃'
    " let g:airline_left_sep                         = '⮀'
    " let g:airline_left_alt_sep                     = '⮁'
    " let g:airline_right_sep                        = '⮂'
    " let g:airline_right_alt_sep                    = '⮃'

    " let g:airline_symbols.branch                   = '⭠'
    " let g:airline_symbols.readonly                 = '⭤'
    " let g:airline_symbols.linenr                   = '⭡'
  " endif " }}}
  let g:airline_symbols.maxlinenr                  = ''
  let g:airline_symbols.linenr                     = ''

  " disable warning " {{{
  " let g:airline#extensions#default#layout = [
  "			 \ [ 'a', 'b', 'c' ],
  "			 \ [ 'x', 'y', 'z' ]
  "			 \ ] " }}}
endif

if myvimrc#plug_tap('lightline.vim')
  let g:lightline = {
        \ 'colorscheme': 'iceberg',
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'gitgutter', 'ctrlpprev', 'ctrlpcur', 'ctrlpnext' ], [ 'truncate_path' ] ],
        \   'right': [ [ 'lineinfo' ], [ 'percent' ], [ 'tagbar', 'filetype', 'fileenc_and_fomat' ] ]
        \ },
        \ 'inactive': {
        \   'left': [ [ 'fugitive', 'gitgutter', 'truncate_path' ] ],
        \   'right': [ [ 'lineinfo' ], [ 'percent' ], [ 'filetype', 'fileenc_and_fomat' ] ]
        \ },
        \ 'tab': {
        \   'active': [ 'tabnum', 'filename', 'readonly', 'modified' ],
        \   'inactive': [ 'tabnum', 'filename', 'readonly', 'modified' ],
        \ },
        \ 'tab_component_function': {
        \   'filename': 'LightlineTabFilename',
        \   'modified': 'lightline#tab#modified',
        \   'readonly': 'lightline#tab#readonly',
        \   'tabnum':   'lightline#tab#tabnum',
        \ },
        \ 'component': {
        \   'truncate_path': '%<%{LightlineFilename()}',
        \ },
        \ 'component_function': {
        \   'fugitive': 'LightlineFugitive',
        \   'filename': 'LightlineFilename',
        \   'fileformat': 'LightlineFileformat',
        \   'filetype': 'LightlineFiletype',
        \   'fileencoding': 'LightlineFileencoding',
        \   'fileenc_and_fomat': 'LightlineFileEncAndFomat',
        \   'lineinfo': 'LightlineLineinfo',
        \   'percent': 'LightlinePercent',
        \   'mode': 'LightlineMode',
        \   'ctrlpprev': 'CtrlPPrev',
        \   'ctrlpnext': 'CtrlPNext',
        \   'gitgutter': 'LightlineGitgutter',
        \   'tagbar': 'LightlineTagbar',
        \ },
        \ 'component_expand': {
        \   'syntastic': 'SyntasticStatuslineFlag',
        \   'ctrlpcur': 'CtrlPCur',
        \ },
        \ 'component_type': {
        \   'syntastic': 'error',
        \   'ctrlpcur': 'insert',
        \ },
        \   'separator': { 'left': "\ue0c8", 'right': "\ue0ca" },
        \   'subseparator': { 'left': '', 'right': '' }
        \ }
  if !has('gui_running')
    let g:lightline['separator'] = { 'left': '', 'right': '' }
    let g:lightline['subseparator'] = { 'left': '|', 'right': '|' }
  endif

  function! LightlineModified()
    return &ft =~# 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
  endfunction

  function! LightlineReadonly()
    if has('gui_running')
      return &ft !~? 'help' && &readonly ? '' : ''
    else
      return &ft !~? 'help' && &readonly ? 'RO' : ''
    endif
  endfunction

  function! LightlineFilename()
    let fname = expand('%:t')
    let abspath = expand('%:p')
    let tagbar_sort = g:tagbar_sort
    " return fname ==# 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
    return fname ==# 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? getcwd() :
          \ fname =~# '__Tagbar__' ? 
          \   (tagbar_sort ? 
          \   '[Name]  ' . g:lightline.fname : 
          \   '[Order] ' . g:lightline.fname) :
          \ fname =~# '__Gundo\|NERD_tree' ? '' :
          \ &ft ==# 'denite' ? denite#get_status_path() :
          \ &ft ==# 'vimfiler' ? vimfiler#get_status_string() :
          \ &ft ==# 'unite' ? unite#get_status_string() :
          \ &ft ==# 'vimshell' ? vimshell#get_status_string() :
          \ ('' !=# LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
          \ ('' !=# fname ? abspath : '[No Name]') .
          \ ('' !=# LightlineModified() ? ' ' . LightlineModified() : '')
  endfunction

  function! LightlineTabFilename(n) abort
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    let name = expand('#'.buflist[winnr - 1].':p')
    let fmod = ':~:.'
    let _ = ''

    if empty(name)
      let _ .= '[No Name]'
    else
      let _ .= substitute(fnamemodify(name, fmod), '\v\w\zs.{-}\ze(\\|/)', '', 'g')
    endif

    let _ = substitute(_, '\\', '/', 'g')
    return _
  endfunction

  function! LightlineGitgutter()
    let str = ''
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler'
      let str = myvimrc#statusline_gitgutter()
    endif
    return str
  endfunction

  function! LightlineFugitive()
    try
      if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
        if has('gui_running')
          let mark = ''  " edit here for cool mark
        else
          let mark = ''
        endif
        let branch = fugitive#head()
        return branch !=# '' ? mark.branch : ''
      endif
    catch
    endtry
    return ''
  endfunction

  function! LightlineFileformat()
    return winwidth(0) > 85 ? &fileformat : ''
  endfunction

  function! LightlineFiletype()
    return winwidth(0) > 85 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
  endfunction

  function! LightlineFileencoding()
    return winwidth(0) > 85 ? (&fenc !=# '' ? &fenc : &enc) : ''
  endfunction

  function! LightlineFileEncAndFomat()
    let str = winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
    let str .= winwidth(0) > 70 ? '[' . &fileformat . ']' : ''
    return str
  endfunction

  function! LightlineTagbar()
    return winwidth(0) > 90 ? myvimrc#statusline_tagbar() : ''
  endfunction

  function! LightlineLineinfo()
    return winwidth(0) > 40 ? printf('%4d:%3d',line('.'),col('.')) : ''
  endfunction

  function! LightlinePercent()
    return winwidth(0) > 40 ? printf('%3d%%',float2nr(1.0*line('.')/line('$')*100)) : ''
  endfunction

  function! LightlineMode()
    if &ft ==# 'denite'
      let mode_str = substitute(denite#get_status_mode(), '-\| ', '', 'g')
      " call lightline#link(tolower(mode_str[0]))
      return mode_str
    else
      let fname = expand('%:t')
      return fname =~# '__Tagbar__' ? 'Tagbar' :
            \ fname ==# 'ControlP' ? 'CtrlP' :
            \ fname ==# '__Gundo__' ? 'Gundo' :
            \ fname ==# '__Gundo_Preview__' ? 'Gundo Preview' :
            \ fname =~# 'NERD_tree' ? 'NERDTree' :
            \ &ft ==# 'unite' ? 'Unite' :
            \ &ft ==# 'vimfiler' ? 'VimFiler' :
            \ &ft ==# 'vimshell' ? 'VimShell' :
            \ winwidth(0) > 90 ? lightline#mode() : lightline#mode()[0:2]
    endif
  endfunction

  function! CtrlPCur()
    if expand('%:t') =~# 'ControlP' && has_key(g:lightline, 'ctrlp_item')
      return g:lightline.ctrlp_item
    else
      return ''
    endif
  endfunction

  function! CtrlPPrev()
    if expand('%:t') =~# 'ControlP' && has_key(g:lightline, 'ctrlp_item')
      call lightline#link('iR'[g:lightline.ctrlp_regex])
      return g:lightline.ctrlp_prev
    else
      return ''
    endif
  endfunction

  function! CtrlPNext()
    if expand('%:t') =~# 'ControlP' && has_key(g:lightline, 'ctrlp_item')
      return g:lightline.ctrlp_next
    else
      return ''
    endif
  endfunction

  let g:ctrlp_status_func = {
        \ 'main': 'CtrlPStatusFunc_1',
        \ 'prog': 'CtrlPStatusFunc_2',
        \ }

  function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
    let g:lightline.ctrlp_regex = a:regex
    let g:lightline.ctrlp_prev = a:prev
    let g:lightline.ctrlp_item = a:item
    let g:lightline.ctrlp_next = a:next
    return lightline#statusline(0)
  endfunction

  function! CtrlPStatusFunc_2(str)
    let g:lightline.ctrlp_prev = ''
    let g:lightline.ctrlp_item = ''
    let g:lightline.ctrlp_next = printf('%s',a:str)
    return lightline#statusline(0)
  endfunction

  let g:tagbar_status_func = 'TagbarStatusFunc'

  function! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
    return lightline#statusline(0)
  endfunction

  let g:unite_force_overwrite_statusline = 0
  let g:vimfiler_force_overwrite_statusline = 0
  let g:vimshell_force_overwrite_statusline = 0

  " lightline.vim側で描画するのでdeniteでstatuslineを描画しないようにする
  call denite#custom#option('default', 'statusline', v:false)
endif

if myvimrc#plug_tap('vim-clang-format')
  let g:clang_format#auto_format = 0
  let g:clang_format#command = 'clang-format'
  if has('unix')
    if !executable('clang-format')
      for majorversion in range(4, 3, -1)
        for minorversion in range(9, 1, -1)
          if executable('clang-format-' . majorversion . '.' . minorversion)
            let g:clang_format#command = 'clang-format-' . majorversion . '.' . minorversion
          endif
        endfor
      endfor
    endif
  endif
  let g:clang_format#style_options = {
        \ 'AllowShortIfStatementsOnASingleLine':'true',
        \ 'AllowShortBlocksOnASingleLine'      :'true',
        \ 'AllowShortCaseLabelsOnASingleLine'  :'true',
        \ 'AllowShortFunctionsOnASingleLine'   :'true',
        \ 'AllowShortLoopsOnASingleLine'       :'true',
        \ 'AlignAfterOpenBracket'              :'AlwaysBreak',
        \ 'AlignConsecutiveAssignments'        :'true',
        \ 'AlignConsecutiveDeclarations'       :'true',
        \ 'AlignTrailingComments'              :'true',
        \ 'TabWidth'                           :'4',
        \ 'UseTab'                             :'Never',
        \ 'ColumnLimit'                        :'120'
        \ }
endif

if myvimrc#plug_tap('vim-dirvish')
  nnoremap <silent> <Leader>e :exe ":" . <SID>open_mydirvish()<CR>
  nnoremap <silent> <Leader>E :Dirvish .<cr>
  " nnoremap <silent> <Leader>e :Dirvish %:p:h<CR>
  " nnoremap <silent> <Leader>E :Dirvish .<CR>

  fun! s:open_mydirvish()
    let savepre = 'let w:dirvish_before = [expand("%:p")]'
    " if len(tabpagebuflist()) > 1
    let w:dirvish_splited = 0
    let w:dirvish_start_cd = getcwd()
    return savepre . '| Dirvish %:p:h'
    " else
    " return 'leftabove vsplit|' . savepre .'| let w:dirvish_splited = 1 | Dirvish %:p:h'
    " endif
  endf

  fun! s:quit_mydirvish()
    if !exists('w:dirvish_splited')
      let w:dirvish_splited = 0
    endif
    if w:dirvish_splited == 1 && len(tabpagebuflist()) > 1
      quit
    else
      nmap <buffer> q <plug>(dirvish_quit)
      exe 'normal q'
      unlet w:dirvish_before
    endif
    if(exists('w:dirvish_start_cd'))
      exe 'cd ' . w:dirvish_start_cd
      unlet w:dirvish_start_cd
    endif
  endf

  fun! s:mydirvish_selectprevdir()
    if !exists('w:dirvish_before')
      let w:dirvish_before = []
    endif
    if len(w:dirvish_before) > 0
      call search('\V\^'.escape(w:dirvish_before[0], '\').'\$', 'cw')
    endif
  endf

  fun! s:mydirvish_open()

    if len(w:dirvish_before) > 1
      call remove(w:dirvish_before,0,1)
    elseif len(w:dirvish_before) == 1
      call remove(w:dirvish_before,0)
    endif

    call dirvish#open('edit', 0)

  endf

  augroup vimrc_dirvish
    autocmd!
    " hとlによる移動
    autocmd FileType dirvish nnoremap <silent><buffer> l :call <SID>mydirvish_open()<CR>
    autocmd FileType dirvish xnoremap <silent><buffer> l :call <SID>mydirvish_open()<CR>
    autocmd FileType dirvish nmap <silent><buffer> h <Plug>(dirvish_up)
    autocmd FileType dirvish xmap <silent><buffer> h <Plug>(dirvish_up)
    " 独自quitスクリプト
    autocmd FileType dirvish nmap <silent><buffer> q :call <SID>quit_mydirvish()<cr>
    " 起動時にソート.行末記号を入れないことで全行ソートする(共通部はソートしない)
    autocmd FileType dirvish silent sort /.*\([\\\/]\)\@=/
    " autocmd FileType dirvish silent keeppatterns g@\v[\/]\.[^\/]+[\/]?$@d
    " .とsに隠しファイルとソートを割り当て
    autocmd FileType dirvish nnoremap <silent><buffer> . :keeppatterns g@\v[\/]\.[^\/]+[\/]?$@d<cr>
    autocmd FileType dirvish nnoremap <silent><buffer> s :sort /.*\([\\\/]\)\@=/<cr>

    autocmd FileType dirvish nnoremap <silent><buffer> ~ :Dirvish ~/<CR>

    autocmd FileType dirvish nnoremap <silent><buffer> dd :Shdo rm -rf {}<CR>
    autocmd FileType dirvish vnoremap <silent><buffer> d :Shdo rm -rf {}<CR>
    autocmd FileType dirvish nnoremap <silent><buffer> rr :Shdo mv {}<CR>
    autocmd FileType dirvish vnoremap <silent><buffer> r :Shdo mv {}<CR>
    autocmd FileType dirvish nnoremap <silent><buffer> cc :Shdo cp {}<CR>
    autocmd FileType dirvish vnoremap <silent><buffer> c :Shdo cp {}<CR>

    " 開いていたファイルやDirectory(w:dirvish_before)にカーソルをあわせる
    autocmd FileType dirvish call <SID>mydirvish_selectprevdir()
    autocmd FileType dirvish call insert(w:dirvish_before,expand("%:p"))
    autocmd FileType dirvish CdCurrent
  augroup END
endif

if myvimrc#plug_tap('vim-easymotion')
  let g:EasyMotion_do_mapping = 0
  nmap <Leader>s <Plug>(easymotion-overwin-f2)
endif

if myvimrc#plug_tap('vim-indent-guides')
  let g:indent_guides_guide_size = 0
  let g:indent_guides_color_change_percent = 5
  let g:indent_guides_start_level = 1
  let g:indent_guides_enable_on_vim_startup = 1
endif

if myvimrc#plug_tap('vim-multiple-cursors')
  let g:multi_cursor_use_default_mapping = 0
  " Default mapping
  let g:multi_cursor_start_key = 'g<C-n>'
  let g:multi_cursor_next_key = '<C-n>'
  let g:multi_cursor_prev_key = '<C-p>'
  let g:multi_cursor_skip_key = '<C-x>'
  let g:multi_cursor_quit_key = '<Esc>'
endif

if myvimrc#plug_tap('vim-precious')
  " let g:context_filetype#search_offset = 300
  let g:precious_enable_switch_CursorMoved = {
        \   '*' : 0,
        \}
  let g:precious_enable_switch_CursorMoved_i = {
        \   '*' : 0,
        \}
  let g:precious_enable_switch_CursorHold = {
        \	'*' : 0,
        \   'toml' : 1,
        \   'help' : 1,
        \}
  " INSERTモードのON／OFFに合わせてトグル
  augroup vimrc_precious
    autocmd!
    " autocmd InsertEnter * :PreciousSwitch
    " autocmd InsertLeave * :PreciousSwitch
    autocmd FileType toml :syntax sync fromstart
  augroup END


  " setfiletype を無効
  " let g:precious_enable_switchers = {
  " \	"*" : {
  " \		"setfiletype" : 0,
  " \	},
  " \}
  " augroup test
  "	 autocmd!
  "	 autocmd User PreciousFileType let &l:syntax = precious#context_filetype()
  " augroup END
endif

if myvimrc#plug_tap('yankround.vim')
  nmap p <Plug>(yankround-p)
  xmap p <Plug>(yankround-p)
  nmap P <Plug>(yankround-P)
  nmap gp <Plug>(yankround-gp)
  xmap gp <Plug>(yankround-gp)
  nmap gP <Plug>(yankround-gP)
  nnoremap <silent><SID>(ctrlp) :<C-u>CtrlP<CR>
  nmap <expr><C-p> yankround#is_active() ?
        \ "\<Plug>(yankround-prev)" :
        \ ":CtrlP<CR>"
  nmap <C-n> <Plug>(yankround-next)
endif

if myvimrc#plug_tap('vaffle.vim')
  nnoremap <silent> <Leader>e :Vaffle %:p:h<CR>
  nnoremap <silent> <Leader>E :Vaffle .<CR>
  function! s:customize_vaffle_mappings() abort
    " Customize key mappings here
    nmap <buffer> <tab> <Plug>(vaffle-toggle-current)
  endfunction
  augroup vimrc_vaffle
    autocmd FileType vaffle call s:customize_vaffle_mappings()
    autocmd FileType vaffle command! -buffer CdCurrent execute printf('cd %s', vaffle#buffer#get_env().dir)
  augroup END
endif

if myvimrc#plug_tap('vimfiler.vim')
  " let g:vimfiler_force_overwrite_statusline = 0
  let g:vimfiler_enable_auto_cd = 1
  let g:vimfiler_as_default_explorer = 1
  call vimfiler#custom#profile('default', 'context' , { 'simple' : 1 })
  " let g:vimfiler_restore_alternate_file = 0
  nnoremap <silent> <Leader>v :VimFilerBufferDir -split -winwidth=35 -simple -toggle -find -force-quit -split-action=below<CR>
  nnoremap <silent> <Leader>V :VimFilerCurrentDir -split -winwidth=35 -simple -toggle -force-quit -split-action=below<CR>
  nnoremap <silent> <Leader>e :VimFilerBufferDir -split -winwidth=35 -simple -toggle -find -force-quit -split-action=below<CR>
  nnoremap <silent> <Leader>E :VimFilerCurrentDir -split -winwidth=35 -simple -toggle -force-quit -split-action=below<CR>
  " nnoremap <silent> <Leader>e :VimFilerBufferDir -toggle -find -force-quit -split  -status -winwidth=35 -simple -split-action=below<CR>
  " nnoremap <silent> <Leader>E :VimFilerCurrentDir -split -toggle -force-quit -status -winwidth=35 -simple -split-action=below<CR>
endif

if myvimrc#plug_tap('thumbnail.vim')
  augroup vimrc_thumbnail
    autocmd!
  augroup END
  if myvimrc#plug_tap('vim-indent-guides')
    autocmd vimrc_thumbnail FileType thumbnail IndentGuidesDisable
  endif
endif

