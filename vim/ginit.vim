" GuiFont! JetBrainsMono Nerd Font Mono:h13
GuiFont! BlexMono Nerd Font
GuiAdaptiveColor 1
GuiAdaptiveFont 0
GuiScrollBar 1
GuiTabline 0
GuiPopupmenu 0
set title
nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
vnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
