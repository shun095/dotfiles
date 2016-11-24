function! myvimrc#ImInActivate() abort
    call system('fcitx-remote -c')
endfunction

function! myvimrc#confirm_do_dein_install() abort
    if !exists("g:my_dein_install_confirmed")
        let s:confirm_plugins_install = confirm(
                    \"Some plugins are not installed yet. Install now?",
                    \"&yes\n&no",2
                    \)
        if s:confirm_plugins_install == 1
            call dein#install()
        else
            echomsg "Plugins were not installed. Please install after."
        endif
        let g:my_dein_install_confirmed = 1
    endif
endfunction

function! myvimrc#NiceLexplore(open_on_bufferdir)
    " 常に幅35で開く
    let g:netrw_winsize = float2nr(round(30.0 / winwidth(0) * 100))
    if a:open_on_bufferdir == 1
        Lexplore %:p:h
    else
        Lexplore
    endif
    let g:netrw_winsize = 50
endfunction
