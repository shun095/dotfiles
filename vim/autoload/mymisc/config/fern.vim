scriptencoding utf-8

fun! mymisc#config#fern#setup() abort

  let s:Promise = vital#mymisc#import('Async.Promise')
  let s:L = vital#mymisc#import('Data.List')
  let s:Lambda = vital#mymisc#import('Lambda')
  let s:AsyncLambda = vital#mymisc#import('Async.Lambda')

  nno <silent> <Leader>e :FernDo :<CR>
  nno <silent> <Leader>E :Fern %:h -drawer -reveal=%:p<CR>
  nno <silent> <Leader><c-e> :Fern . -drawer -reveal=%:p<CR>
  nno <Leader>n :Fern<space>

  let g:fern#drawer_width = 40
  let g:fern#drawer_keep = g:true
  let g:fern#disable_drawer_hover_popup = g:true

  fun! s:init_fern() abort
    " Write custom code here

    IndentLinesDisable
    nno           <buffer>  <Leader>e      :<C-u>Fern<Space>
    nno  <silent> <buffer>  ~              <Cmd>Fern ~<CR>
    nno  <silent> <buffer>  q              <Cmd>close<CR>
    nmap <silent> <buffer>  cd             <Plug>(fern-action-cd)
    nmap <silent> <buffer>  <CR>           <Plug>(fern-action-open-or-enter)
    nmap <silent> <buffer>  <2-LeftMouse>  <Plug>(fern-action-open-or-expand)
    nmap <silent> <buffer>  <2-RightMouse> <Plug>(fern-action-collapse)
    nmap <silent> <buffer>  <X2Mouse>      <Plug>(fern-action-open-or-enter)
    nmap <silent> <buffer>  <X1Mouse>      <Plug>(fern-action-leave)
    nmap <silent> <buffer>  I              <Plug>(fern-action-hidden:toggle)
    nmap <silent> <buffer>  <C-l>          <Plug>(fern-action-reload:all)
    nmap <silent> <buffer>  o              <Plug>(fern-action-open-or-expand)
    nmap <silent> <buffer>  O              <Plug>(fern-action-open:split)
    nmap <silent> <buffer>  S              <Plug>(fern-action-open:vsplit)
    nmap <silent> <buffer>  x              <Plug>(fern-action-collapse)
    nmap <silent> <buffer>  X              <Plug>(fern-action-open:system)
    nmap <silent> <buffer>  F              <Plug>(fern-action-new-file)
    nmap <silent> <buffer>  u              <Plug>(fern-action-leave)
    nmap <silent> <buffer>  A              <Plug>(fern-action-zoom:full)

    " Prevent from default mapping
    nmap  <silent> <buffer> N N
    unmap <silent> <buffer> N
    nmap  <silent> <buffer> n n
    unmap <silent> <buffer> n
  endf

  aug vimrc_fern
    au! *
    au FileType fern call s:init_fern()
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
      au FileType fern call s:fern_settings()
    aug END
  endif

  let s:inherited_renderer = fern#renderer#nerdfont#new()
  " let s:inherited_renderer = fern#renderer#default#new()

  fun! s:renderer_new()
    return extend(copy(s:inherited_renderer), {
          \ 'render': funcref('s:render'),
          \})
  endf

  function! s:render(nodes)
    " echom "s:render start
    let l:list = []
    return s:inherited_renderer.render(a:nodes)
          \.then({
          \  prev_text_list -> s:render_nodes(prev_text_list, a:nodes)
          \})
          \.catch({
          \  e -> s:reject_render(e)
          \})
    " echom "s:render end
  endfunction

  function! s:fallback_render(prev)
    " echom "s:fallback start
    " echom "s:fallback end
    return a:prev
  endfunction

  let s:show_error_once = 0
  function! s:reject_render(err)
    " echom "s:reject_render start
    if !s:show_error_once
      echom "fern error: " . string(a:err[1]) . " -- Falling back to normal rendering."
      let s:show_error_once = 1
    endif
    " echom "s:reject_render end
    return a:err[0]
  endfunction

  function! s:render_nodes(prev_text_list, nodes)
    " echom "s:render_nodes start
    let l:prev_text_lengths = map(copy(a:prev_text_list) , { key, val -> strdisplaywidth(val)})
    let l:max_prev_text_length = max([max(l:prev_text_lengths) + 1, g:fern#drawer_width])

    let l:promise = s:Promise.new(funcref('s:render_nodes_denops', [a:prev_text_list, l:max_prev_text_length, a:nodes]))
    " echom "s:render_nodes end
    return l:promise
  endfunction

  function! s:render_nodes_denops(prev_text_list, max_prev_text_length, nodes, resolve, reject)
    " echom "s:render_nodes_denops start
    try
      cal denops#request_async('denops-mymisc', 'getRenderStrings', [a:prev_text_list, a:max_prev_text_length, a:nodes],
            \ { v -> s:success(a:resolve, v)},
            \ { e -> s:failure(a:reject, a:prev_text_list, e)}
            \)
      " echom "s:render_nodes_denops end
    catch
      " echom "s:render_nodes_denops catch start"
      cal a:reject([a:prev_text_list, v:exception])
      " echom "s:render_nodes_denops catch end
    endtry
  endfunction

  function! s:success(resolve, v)
    " echom "s:success start
    cal a:resolve(json_decode(a:v))
    " echom "s:success end
  endfunction

  function! s:failure(reject, prev_text_list, e)
    " echom "s:failure start
    echom "fern error: " . string(a:e)
    cal a:reject([json_decode(a:e), e])
    " echom "s:failure end
  endfunction

  let g:fern#renderer = 'my_renderer'
  call extend(g:fern#renderers, {
        \ 'my_renderer': funcref('s:renderer_new')
        \})

endf


