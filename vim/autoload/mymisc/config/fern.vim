scriptencoding utf-8

fun! mymisc#config#fern#setup() abort

  nno <silent> <Leader>e :FernDo :<CR>
  nno <silent> <Leader>E :Fern %:h -drawer -reveal=%:p<CR>
  nno <silent> <Leader><c-e> :Fern . -drawer -reveal=%:p<CR>
  nno <silent> <Leader>n :Fern<space>

  fun! s:init_fern() abort
    " Write custom code here

    IndentLinesDisable
    nno <silent> <buffer> q             :<C-u>close<CR>
    nmap     <silent> <buffer> <CR>          <Plug>(fern-action-open-or-enter)
    nmap     <silent> <buffer> <2-LeftMouse> <Plug>(fern-action-open-or-expand)
    nmap     <silent> <buffer> <2-RightMouse> <Plug>(fern-action-collapse)
    nmap     <silent> <buffer> <X2Mouse> <Plug>(fern-action-open-or-enter)
    nmap     <silent> <buffer> <X1Mouse> <Plug>(fern-action-leave)
    nmap     <silent> <buffer> I             <Plug>(fern-action-hidden:toggle)
    nmap     <silent> <buffer> <C-l>         <Plug>(fern-action-reload:all)
    nmap     <silent> <buffer> o             <Plug>(fern-action-open-or-expand)
    nmap     <silent> <buffer> O             <Plug>(fern-action-open:split)
    nmap     <silent> <buffer> S             <Plug>(fern-action-open:vsplit)
    nmap     <silent> <buffer> x             <Plug>(fern-action-collapse)
    nmap     <silent> <buffer> X             <Plug>(fern-action-open:system)
    nmap     <silent> <buffer> F             <Plug>(fern-action-new-file)
    nmap     <silent> <buffer> u             <Plug>(fern-action-leave)
    nmap     <silent> <buffer> A             <Plug>(fern-action-zoom:full)

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
    fun! s:fern_settings() abort
      nmap <silent> <buffer> p     <Plug>(fern-action-preview:toggle)
      nmap <silent> <buffer> <C-p> <Plug>(fern-action-preview:auto:toggle)
      "Preview通常のFernウィンドウでエラーが発生してしまうため一旦コメントアウト
      "nmap <silent> <buffer> <C-d> <Plug>(fern-action-preview:scroll:down:half)
      "nmap <silent> <buffer> <C-u> <Plug>(fern-action-preview:scroll:up:half)
      nmap <silent> <buffer> <expr> <Plug>(fern-quit-or-close-preview) fern_preview#smart_preview("\<Plug>(fern-action-preview:close)", ":q\<CR>")
      nmap <silent> <buffer> q <Plug>(fern-quit-or-close-preview)
    endf

    aug fern-settings
      au!
      au FileType fern call s:fern_settings()
    aug END
  endif

  let g:fern#renderer = 'nerdfont'
endf
