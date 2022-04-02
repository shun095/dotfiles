scriptencoding utf-8

fun! mymisc#config#dirvish_git#setup() abort
  let g:dirvish_git_indicators = {
        \ 'Modified'  : '!',
        \ 'Staged'    : '+',
        \ 'Untracked' : 'u',
        \ 'Renamed'   : '>',
        \ 'Unmerged'  : '=',
        \ 'Ignored'   : 'i',
        \ 'Unknown'   : '?'
        \ }
endf
