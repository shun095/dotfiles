scriptencoding utf-8

function! mymisc#config#nerdcommenter#setup() abort
  let g:NERDSpaceDelims = 1
  let g:NERDCustomDelimiters = {
        \ 'python': { 'left': '#', 'leftAlt': '# ' },
        \ }

  let s:nc_tmp_ft = ''
  function! NERDCommenter_before()
    if &ft == 'vue'
      let s:nc_tmp_ft = 'vue'
      let stack = synstack(line('.'), col('.'))
      if len(stack) > 0
        let syn = synIDattr((stack)[0], 'name')
        if len(syn) > 0
          exe 'setf ' . substitute(tolower(syn), '^vue_', '', '')
        endif
      endif
    endif
  endfunction

  function! NERDCommenter_after()
    if s:nc_tmp_ft == 'vue'
      setf vue
      let s:nc_tmp_ft = ''
    endif
  endfunction

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
endfunction
