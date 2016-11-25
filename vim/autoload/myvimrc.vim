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

" function! s:move_cursor_pos_mapping(str, ...)
"     let left = get(a:, 1, "<Left>")
"     let lefts = join(map(split(matchstr(a:str, '.*<Cursor>\zs.*\ze'), '.\zs'), 'left'), "")
"     return substitute(a:str, '<Cursor>', '', '') . lefts
" endfunction

" function! s:count_serch_number(str)
"     return s:move_cursor_pos_mapping(a:str, "\<Left>")
" endfunction



" function! s:set_statusline() abort
"     if !exists("g:loaded_lightline")
"         " statusline settings
"         set statusline=%F%m%r%h%w%q%=
"         set statusline+=[%{&fileformat}]
"         set statusline+=[%{has('multi_byte')&&\&fileencoding!=''?&fileencoding:&encoding}]
"         set statusline+=%y
"         set statusline+=%4p%%%5l:%-3c
"     endif
" endfunction