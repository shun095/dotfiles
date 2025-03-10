scriptencoding utf-8

fun! mymisc#config#fern#setup() abort
  let s:Promise = vital#mymisc#import('Async.Promise')

  function! s:fern_open_or_focus() abort
    if &filetype ==# 'fern'
      wincmd p
    else
      FernDo :
      if &filetype !=# 'fern'
        Fern . -drawer -reveal=%:p -keep
      endif
    endif
  endfunction

  nno <silent> <Leader>e :cal <SID>fern_open_or_focus()<CR>
  nno <silent> <Leader>E :Fern %:h -drawer -reveal=%:p -keep<CR>
  nno <silent> <Leader><c-e> :Fern . -drawer -reveal=%:p -keep<CR>
  nno <Leader>N :Fern %:h -drawer -reveal=%:p -keep<CR>
  nno <Leader>n :Fern . -drawer -reveal=%:p -keep<CR>

  let g:fern#drawer_width = 35
  let g:fern#drawer_keep = v:true
  let g:fern#disable_drawer_hover_popup = v:true
  
  function! s:fern_toggle_zoom() abort
    if winwidth(0) ==# g:fern#drawer_width
      cal feedkeys("\<Plug>(fern-action-zoom:full)")
    else
      cal feedkeys("\<Plug>(fern-action-zoom:reset)")
    endif
  endfunction

  fun! s:init_fern() abort
    " Write custom code here

    if exists(':IndentLinesDisable')
      IndentLinesDisable
    endif
    " nno           <buffer>  <Leader>e      :<C-u>Fern<Space>
    nno  <silent> <buffer>  ~              <Cmd>Fern ~<CR>
    nno  <silent> <buffer>  q              <Cmd>close<CR>
    nmap <silent> <buffer>  cd             <Plug>(fern-action-tcd)
    nmap <silent> <buffer>  <CR>           <Plug>(fern-action-open-or-enter)
    nmap <silent> <buffer>  <2-LeftMouse>  <Plug>(fern-action-open-or-expand)
    nmap <silent> <buffer>  <2-RightMouse> <Plug>(fern-action-collapse)
    nmap <silent> <buffer>  <X2Mouse>      <Plug>(fern-action-open-or-enter)
    nmap <silent> <buffer>  <X1Mouse>      <Plug>(fern-action-leave)
    nmap <silent> <buffer>  I              <Plug>(fern-action-hidden:toggle)
    nmap <silent> <buffer>  <C-l>          <Plug>(fern-action-reload:all)
    nmap <silent> <buffer>  o              <Plug>(fern-action-open-or-expand)
    nmap <silent> <buffer>  <Right>        <Plug>(fern-action-open-or-expand)
    nmap <silent> <buffer>  O              <Plug>(fern-action-open:split)
    nmap <silent> <buffer>  S              <Plug>(fern-action-open:vsplit)
    nmap <silent> <buffer>  x              <Plug>(fern-action-collapse)
    nmap <silent> <buffer>  <Left>         <Plug>(fern-action-collapse)
    nmap <silent> <buffer>  X              <Plug>(fern-action-open:system)
    nmap <silent> <buffer>  F              <Plug>(fern-action-new-file)
    nmap <silent> <buffer>  u              <Plug>(fern-action-leave)
    nmap <silent> <buffer>  A              :cal <SID>fern_toggle_zoom()<CR>
    nno  <silent> <buffer>  }              j:cal search("\/")<CR>0:noh<CR>
    nno  <silent> <buffer>  {              :cal search("\/","b")<CR>0:noh<CR>

    " Prevent from default mapping
    nmap  <silent> <buffer> N N
    unmap <silent> <buffer> N
    nmap  <silent> <buffer> n n
    unmap <silent> <buffer> n

    setlocal nonumber
    setlocal signcolumn=no
    setlocal norelativenumber

    " let g:glyph_palette#palette = v:lua.require('fr-web-icons').palette()
    let g:fern#renderer#web_devicons#use_web_devicons_color_palette = v:true
  endf

  fun s:fern_change_dir(...) abort
    Fern . -drawer -reveal=%:p -keep -stay
  endfun

  aug vimrc_fern
    au! *
    au FileType fern cal s:init_fern()
    " au FileType fern call glyph_palette#apply()
    " au DirChanged global,tabpage call timer_start(0, funcref("s:fern_change_dir"))
  aug END

  if mymisc#startup#plug_tap('fern-preview.vim')

    fun! s:fern_close_preview()
      cal fern_preview#disable_auto_preview()
      cal fern_preview#close()
    endf

    fun! s:fern_settings() abort
      nmap <silent> <buffer> p     <Plug>(fern-action-preview:toggle)
      nmap <silent> <buffer> <C-p> <Plug>(fern-action-preview:auto:toggle)
      "Preview通常のFernウィンドウでエラーが発生してしまうため一旦コメントアウト
      "nmap <silent> <buffer> <C-d> <Plug>(fern-action-preview:scroll:down:half)
      "nmap <silent> <buffer> <C-u> <Plug>(fern-action-preview:scroll:up:half)
      nmap <silent> <buffer> <expr> <Plug>(fern-quit-or-close-preview)
            \ fern_preview#smart_preview(
            \     "\<Cmd>cal \<SID>fern_close_preview()\<CR>",
            \     "\<Cmd>close\<CR>")
      nmap <silent> <buffer> q <Plug>(fern-quit-or-close-preview)
    endf

    aug fern-settings
      au!
      au FileType fern cal s:fern_settings()
    aug END
  endif

  if has('nvim')
    let g:fern#renderer#web_devicons#indent_markers = v:true
    let s:inherited_renderer = fern#renderer#web_devicons#new()
  else
    let s:inherited_renderer = fern#renderer#nerdfont#new()
    " let s:inherited_renderer = fern#renderer#default#new()
  endif

  fun! s:renderer_new()
    cal denops#server#wait({"timeout": 5000})
    retu extend(copy(s:inherited_renderer), {
          \ 'render': funcref('s:render'),
          \})
  endf

  fun! s:render(nodes)
    " echom "s:render start
    let l:list = []
    retu s:inherited_renderer.render(a:nodes)
          \.then({
          \  prev_text_list -> s:render_nodes(prev_text_list, a:nodes)
          \})
          \.catch({
          \  e -> s:reject_render(e)
          \})
    " echom "s:render end
  endf

  let s:show_error_once = 0
  fun! s:reject_render(err)
    " echom "s:reject_render start
    if !s:show_error_once
      echom "fern error: " . string(a:err[1]) . " -- Falling back to normal rendering."
      let s:show_error_once = 1
    endif
    " echom "s:reject_render end
    retu a:err[0]
  endf

  fun! s:render_nodes(prev_text_list, nodes)
    " echom "s:render_nodes start
    let l:promise = s:Promise.new(funcref('s:render_nodes_denops', [a:prev_text_list, a:nodes]))
    " echom "s:render_nodes end
    retu l:promise
  endf

  fun! s:render_nodes_denops(prev_text_list, nodes, resolve, reject)
    " echom "s:render_nodes_denops start
    try
      cal denops#request_async('fern-custom-renderer', 'getRenderStrings', [a:prev_text_list, a:nodes],
            \ { v -> s:success(a:resolve, v)},
            \ { e -> s:failure(a:reject, a:prev_text_list, e)}
            \)
      " echom "s:render_nodes_denops end
    catch
      " echom "s:render_nodes_denops catch start"
      cal a:reject([a:prev_text_list, v:exception])
      " echom "s:render_nodes_denops catch end
    endtry
  endf

  fun! s:success(resolve, v)
    " echom "s:success start
    cal a:resolve(json_decode(a:v))
    " echom "s:success end
  endf

  fun! s:failure(reject, prev_text_list, e)
    " echom "s:failure start
    echom "fern error: " . string(a:e)
    cal a:reject([a:prev_text_list, a:e])
    " echom "s:failure end
  endf

  let g:fern#renderer = 'my_renderer'
  cal extend(g:fern#renderers, {
        \ 'my_renderer': funcref('s:renderer_new')
        \})

endf


