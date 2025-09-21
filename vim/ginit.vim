" GuiFont! JetBrainsMono Nerd Font Mono:h13
" GuiFont! BlexMono Nerd Font
" GuiAdaptiveColor 1
" GuiAdaptiveFont 0
" GuiScrollBar 1
" GuiTabline 0
" GuiPopupmenu 0
" set title
" nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
" inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
" vnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
set guifont=BlexMono\ Nerd\ Font
" let g:neovide_cursor_vfx_mode = "pixiedust"
let g:neovide_opacity = 0.8
let g:neovide_normal_opacity = 0.8
if v:false
  let g:neovide_opacity = 1.0
  let g:neovide_normal_opacity = 1.0
endif
let g:neovide_window_blurred = v:true
" let g:neovide_floating_blur_amount_x = 0
" let g:neovide_floating_blur_amount_y = 0
let g:neovide_floating_shadow = v:true
let g:neovide_floating_corner_radius = 0.25

let g:neovide_refresh_rate = 10
