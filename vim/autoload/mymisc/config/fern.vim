scriptencoding utf-8

fun! mymisc#config#fern#setup() abort

  nno <silent> <Leader>e :FernDo :<CR>
  nno <silent> <Leader>E :Fern %:h -drawer -reveal=%:p<CR>
  nno <silent> <Leader><c-e> :Fern . -drawer -reveal=%:p<CR>
  nno <Leader>n :Fern<space>

  let g:fern#drawer_width = 40
  let g:fern#drawer_keep = g:true

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
            \fern_preview#smart_preview(
            \    "\<Cmd>cal \<SID>fern_close_preview()\<CR>", 
            \    "\<Cmd>close\<CR>")
      nmap <silent> <buffer> q <Plug>(fern-quit-or-close-preview)
    endf

    aug fern-settings
      au!
      au FileType fern call s:fern_settings()
    aug END
  endif

  let s:inherited_renderer = fern#renderer#nerdfont#new()
  " let s:inherited_renderer = fern#renderer#default#new()

  fun! s:renderer_new() abort
    return extend(copy(s:inherited_renderer), {
          \ 'render': funcref('s:render'),
          \})
  endf

  function! s:render(nodes) abort
    let l:list = []
    return s:inherited_renderer.render(a:nodes)
          \.then({
          \  v -> s:render_node(v, a:nodes)
          \})
  endfunction

  function! s:render_node(v, nodes) abort
    let l:copy = copy(a:v)
    cal map(l:copy, 'strdisplaywidth(v:val)')

    let l:copy_byte = copy(a:nodes)
    cal map(l:copy_byte, 'len(string(getfsize(v:val["_path"])))')

    let l:results = []
    let l:max = max([max(l:copy) + 1, g:fern#drawer_width])
    let l:byte_max = max(l:copy_byte)

    for i in range(len(a:v))
      let l:result_string = ""
      let l:result_string .= a:v[i]

      for cnt in range(l:max - strdisplaywidth(a:v[i]))
        let l:result_string .= " "
      endfor

      let l:result_string .= getfperm(a:nodes[i]['_path'])
      let l:result_string .= " "
      let l:result_string .= printf("%". l:byte_max . "d byte" , getfsize(a:nodes[i]['_path']))
      let l:result_string .= " "
      let l:result_string .= strftime('%Y/%m/%d %H:%M:%S',getftime(a:nodes[i]['_path']))

      cal add(l:results, l:result_string)
    endfor

    return l:results
  endfunction

  let g:fern#renderer = 'my_renderer'
  call extend(g:fern#renderers, {
        \ 'my_renderer': funcref('s:renderer_new')
        \})

endf


