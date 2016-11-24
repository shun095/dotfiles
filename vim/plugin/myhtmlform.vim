scriptencoding utf-8
" 自作コマンド HtmlFormat(挙動は保証しない）
augroup MyHtmlForm
    autocmd  FileType html,xml command! HtmlFormat call myhtmlform#myhtmlformat()
augroup END

