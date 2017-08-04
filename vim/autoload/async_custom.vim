scriptencoding utf-8

fun! async_custom#dein(...)
  call denite#custom#option('default','winheight','10')
  call denite#custom#option('default','reversed','1')
  call denite#custom#option('default','vertical_preview','1')
  call denite#custom#option('default','highlight_matched_char','Special')
  call denite#custom#option('default','auto_resize','1')
  call denite#custom#option('default','updatetime','10')
endf
