function! myrosmake#rosmake(filename)
    if !executable("rosmake")
        echohl WarningMsg
        echomsg "Command 'rosmake' is not executable. Please source setup.bash/sh/zsh first."
        echohl none
    else
        " Save current settings
        let l:save_makeprg = &makeprg
        let l:save_errorformat = &errorformat
        let l:save_cd = getcwd()

        " init variable
        let l:package_dir = ""

        " ----Reference from help about finddir()---- {{{
        " finddir()
        " 最初に見つかったディレクトリのパスを返す。そのディレクトリがカレントディレクトリの
        " 下にある場合は相対パスを返す。そうでなければ絶対パスを返す。
        " findfile() is same as finddir()
        " }}}
        let l:rosxmlfile = findfile(a:filename, expand("%:p").";")

        if l:rosxmlfile != "" && (l:rosxmlfile[0] != "/") " ファイルが存在し、絶対パス表記でなかったら
            let l:package_dir = getcwd() . "/" . l:rosxmlfile
        else " ファイルが存在しないか、絶対パス表記だったら
            let l:package_dir = l:rosxmlfile
        endif

        if l:package_dir == ""
            echohl WarningMsg
            echom "Appropriate directory couldn't be found!! (There is no stack/manifest.xml file.)"
            echohl none
        else
            " ファイル名をパスから削除
            let l:package_dir = substitute(l:package_dir, a:filename, "", "g")
            " cdして実行
            execute "cd ". l:package_dir
            set makeprg=rosmake
            let &errorformat .= ","
                        \ . "%+G[ rosmake ] Built %.%#,"
                        \ . "%I[ rosmake ] %m output to directory %.%#,"
                        \ . "%Z[ rosmake ] %f %.%#,"
            if exists(":Dispatch") == 2
                Dispatch
            else
                make
            endif
        endif

        " Restore saved settings
        execute "cd " . l:save_cd
        let &makeprg = l:save_makeprg
        let &errorformat = l:save_errorformat
    endif
endfunction
