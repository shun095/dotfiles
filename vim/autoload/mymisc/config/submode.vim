scriptencoding utf-8

fun! mymisc#config#submode#setup() abort
  fun! s:setup_submode(char)
    nunmap <c-w>-
    nunmap <c-w>+
    nunmap <c-w><
    nunmap <c-w>>
    let g:submode_timeoutlen = 3000
    call submode#enter_with('winsize',   'n', '', '<C-w>>', '5<C-w>>')
    call submode#enter_with('winsize',   'n', '', '<C-w><', '5<C-w><')
    call submode#enter_with('winsize',   'n', '', '<C-w>+', '5<C-w>+')
    call submode#enter_with('winsize',   'n', '', '<C-w>-', '5<C-w>-')
    call submode#leave_with('winsize',   'n', '', '<Esc>')
    call submode#map('winsize',          'n', '', '>',      '5<C-w>>')
    call submode#map('winsize',          'n', '', '<',      '5<C-w><')
    call submode#map('winsize',          'n', '', '+',      '5<C-w>+')
    call submode#map('winsize',          'n', '', '-',      '5<C-w>-')

    call submode#enter_with('timeundo/redo', 'n', '', 'g-',     'g-')
    call submode#enter_with('timeundo/redo', 'n', '', 'g+',     'g+')
    call submode#leave_with('timeundo/redo', 'n', '', '<Esc>')
    call submode#map('timeundo/redo',        'n', '', '-',      'g-')
    call submode#map('timeundo/redo',        'n', '', '+',      'g+')
    call feedkeys("\<C-w>" . a:char)
  endf

  nnoremap <C-w>- :<c-u>call <SID>setup_submode('-')<CR>
  nnoremap <C-w>+ :<c-u>call <SID>setup_submode('+')<CR>
  nnoremap <C-w>< :<c-u>call <SID>setup_submode('-')<CR>
  nnoremap <C-w>> :<c-u>call <SID>setup_submode('-')<CR>
endf
