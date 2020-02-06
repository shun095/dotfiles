scriptencoding utf-8

function! mymisc#config#denite#setup() abort
  let g:neomru#file_mru_ignore_pattern = '^vaffle\|^quickrun\|'.
        \ '\~$\|\.\%(o\|exe\|dll\|bak\|zwc\|pyc\|sw[po]\)$'.
        \ '\|\%(^\|/\)\.\%(hg\|git\|bzr\|svn\)\%($\|/\)'.
        \ '\|^\%(\\\\\|/mnt/\|/media/\|/temp/\|/tmp/\|\%(/private\)\=/var/folders/\)'.
        \ '\|\%(^\%(fugitive\)://\)'.
        \ '\|\%(^\%(term\)://\)'

  call denite#custom#option('default', 'auto_resize',             '1')
  call denite#custom#option('default', 'reversed',                '1')
  call denite#custom#option('default', 'highlight_matched_char',  'Special')
  call denite#custom#option('default', 'highlight_matched_range', 'Normal')
  call denite#custom#option('default', 'updatetime',              '10')

  if !exists('g:ctrlp_match_func')
    let g:ctrlp_match_func = {}
  endif

  if g:ctrlp_match_func != {} && g:ctrlp_match_func['match'] ==# 'cpsm#CtrlPMatch'
    let s:denite_matchers = ['matcher_cpsm']
  else
    let s:denite_matchers = ['matcher_fuzzy']
  endif

  call denite#custom#source('file_mru', 'matchers', s:denite_matchers)
  call denite#custom#source('file_rec', 'matchers', s:denite_matchers)
  call denite#custom#source('line',     'matchers', s:denite_matchers)
  call denite#custom#source('file_mru', 'sorters',  [])
  call denite#custom#source('buffer',   'sorters',  [])

  " Change mappings.
  call denite#custom#map('insert', '<C-j>',  '<denite:move_to_next_line>',     'noremap')
  call denite#custom#map('insert', '<C-k>',  '<denite:move_to_previous_line>', 'noremap')
  call denite#custom#map('insert', '<Down>', '<denite:move_to_next_line>',     'noremap')
  call denite#custom#map('insert', '<Up>',   '<denite:move_to_previous_line>', 'noremap')
  call denite#custom#map('insert', '<C-t>',  '<denite:do_action:tabopen>',     'noremap')
  call denite#custom#map('insert', '<C-v>',  '<denite:do_action:vsplit>',      'noremap')
  call denite#custom#map('insert', '<C-s>',  '<denite:do_action:split>',       'noremap')
  call denite#custom#map('insert', '<C-CR>', '<denite:do_action:split>',       'noremap')
  call denite#custom#map('insert', '<C-x>',  '<denite:do_action:split>',       'noremap')
  call denite#custom#map('insert', '<C-g>',  '<denite:leave_mode>',            'noremap')

  if exists("g:ctrlp_user_command") && g:ctrlp_user_command !=# ''
    call denite#custom#var('file_rec', 'command', split(substitute(g:ctrlp_user_command,'%s',':directory','g'),' '))
  endif

  " rg command on grep source
  if g:mymisc_rg_is_available
    call denite#custom#var('grep', 'command',        ['rg'])
    call denite#custom#var('grep', 'default_opts',   ['--vimgrep'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt',    ['--regexp'])
    call denite#custom#var('grep', 'separator',      ['--'])
    call denite#custom#var('grep', 'final_opts',     [])
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
  " ` Marks
endfunction
