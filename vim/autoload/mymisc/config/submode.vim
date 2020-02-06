scriptencoding utf-8

function! mymisc#config#submode#setup() abort
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
endfunction
