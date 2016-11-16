let s:save_cpo = &cpo
set cpo&vim

function! s:rosmake(filename)
    let s:save_makeprg = &makeprg
    set makeprg=rosmake
    let s:save_cd = getcwd()

    " init
    let l:package_dir = ""

    " let l:filename = "manifest.xml"
    let l:filename = a:filename
    " ----Reference of help----
    " finddir()
    " 最初に見つかったディレクトリのパスを返す。そのディレクトリがカレントディレクトリの
    " 下にある場合は相対パスを返す。そうでなければ絶対パスを返す。
    " findfile() is same as finddir()
    let l:manifestfile = findfile(l:filename,expand("%:p").";")

    " if l:manifestfile is relative path
    if l:manifestfile != "" && l:manifestfile[0] != "/"
        let l:package_dir = getcwd() . "/" . l:manifestfile
    else
        let l:package_dir = l:manifestfile
    endif

    if l:package_dir != ""
        let l:package_dir = substitute(l:package_dir,l:filename,"","gc")
        " echom "[beforemake] : cd to " . l:package_dir
        execute "cd ". l:package_dir
        make
        " echom "[aftermake] : cd to " . s:save_cd
    else
        echom "Appropriate directory couldn't be found!!"
    endif

    execute "cd " . s:save_cd
    let &makeprg = s:save_makeprg
    unlet s:save_cd
    unlet s:save_makeprg
endfunction

if executable("rosmake")
    command! RosmakePackage call s:rosmake("manifest.xml")
    command! RosmakeWorkspace call s:rosmake("stack.xml")
endif

let &cpo = s:save_cpo
unlet s:save_cpo
