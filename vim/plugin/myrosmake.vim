let s:save_cpo = &cpo
set cpo&vim

function! s:rosmake(filename)
    " Save current settings
    let l:save_makeprg = &makeprg
    let l:save_errorformat = &errorformat
    let l:save_cd = getcwd()

    set makeprg=rosmake
    let &errorformat .= ","
                \ . "%+G[ rosmake ] Built %.%#,"
                \ . "%I[ rosmake ] %m output to directory %.%#,"
                \ . "%Z[ rosmake ] %f %.%#,"
                " \ . "%+G%.%#%*[eE]rror%.%#,"
                " \ . "%+G%.%#%*[wW]arning%.%#,"
                " \ . "%+G[rosmake-%*[0-9]] Finished <<< %m,"
                " \ . "%-G%.%#,"
                " \ . "%-G[rosmake-%*[0-9]] Starting >>> %m,"
    echom "errorformat is : " . &errorformat

    " init
    let l:package_dir = ""

    " ----Reference of help----
    " finddir()
    " 最初に見つかったディレクトリのパスを返す。そのディレクトリがカレントディレクトリの
    " 下にある場合は相対パスを返す。そうでなければ絶対パスを返す。
    " findfile() is same as finddir()
    let l:rosxmlfile = findfile(a:filename,expand("%:p").";")

    if l:rosxmlfile != "" && l:rosxmlfile[0] != "/"
        " ファイルが存在し、絶対パス表記でなかったら
        let l:package_dir = getcwd() . "/" . l:rosxmlfile

    else
        " ファイルが存在しないか、絶対パス表記だったら
        let l:package_dir = l:rosxmlfile
    endif

    if l:package_dir != ""
        " ファイル名をパスから削除
        let l:package_dir = substitute(l:package_dir,a:filename,"","gc")
        " echom "[beforemake] : cd to " . l:package_dir
        execute "cd ". l:package_dir
        make
        " echom "[aftermake] : cd to " . l:save_cd
    else
        echom "Appropriate directory couldn't be found!!"
    endif

    " Restore saved settings
    execute "cd " . l:save_cd
    let &makeprg = l:save_makeprg
    let &errorformat = l:save_errorformat
endfunction

if executable("rosmake")
    command! RosmakePackage call s:rosmake("manifest.xml")
    command! RosmakeWorkspace call s:rosmake("stack.xml")
endif

let &cpo = s:save_cpo
unlet s:save_cpo
