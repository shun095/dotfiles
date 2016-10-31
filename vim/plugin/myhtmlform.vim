" scriptencoding utf-8
" " 自作コマンド HtmlFormat(挙動は保証しない）
" autocmd  FileType html command! HtmlFormat call myhtmlform#format()
"
" function! myhtmlform#format() abort
" 	if &filetype == "html" || &filetype == "xml"
" 		%s/>\s*</></g 
" 		%s/\v\<(.*).*\>\zs\s*\n*\s*\ze\<\/\1\>//g
" 		%s/\zs<br>\s*\ze[^$]/<br>/g
" 		normal gg=G
" 	else 
" 		echo "HTMLファイルではありません"
" 	endif
" endfunction
"
