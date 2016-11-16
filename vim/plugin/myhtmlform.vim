scriptencoding utf-8
" 自作コマンド HtmlFormat(挙動は保証しない）
augroup MyHtmlForm
    autocmd  FileType html,xml command! HtmlFormat call <SID>myhtmlformat()
augroup END

function! s:myhtmlformat() abort
    if &filetype == "html" || &filetype == "xml"
        " タグの間の空白を消す
        %s/>\s*</></g
        " タグの終わりを改行に変換
        %s/></>\r</g
        " 内容が無いタグでは改行しないがそれ以外はそのまま
        %s/\v\<(.*).*\>\zs\s*\n*\s*\ze\<\/\1\>//g
        " <br>のあとのスペースを削除?
        %s/\zs<br>\s*\ze[^$]/<br>/g
        normal gg=G
    else 
        echo "HTML/XMLファイルではありません"
    endif
endfunction

