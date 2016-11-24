function! mytimer#TimerAlert(timer)
    let alert_string = "JIKAN DAYO!! "
    execute ":new"
    execute ":normal 20a" . alert_string
    execute ":normal Vy20gp"
    echohl WarningMsg
    echo alert_string
    echohl none
    call mytimer#TimerStop()
endfunction

function! mytimer#TimerStart() abort
    let time_min = input("How long? [min]: ")
    "converting min to milisec.
    let time_milisec = time_min*60*1000
    if !exists("g:timer")
        let g:timer = timer_start(time_milisec, 'mytimer#TimerAlert',
                    \ {'repeat': 1})
    else
        echohl WarningMsg
        echo " Error: Timer already exsists!!!! Please run 'TimerStop' first."
        echohl none
    endif
endfunction

function! mytimer#TimerInfo() abort
    if !exists("g:timer")
        echohl WarningMsg
        echo " Error: There is no running timer!!!! Please run 'TimerStart' first."
        echohl none
    else
        let timer_info = timer_info(g:timer)
        let timer_remain_milisec = timer_info[0]["remaining"]
        echo timer_remain_milisec / 60000 . " min " . timer_remain_milisec % 60000 / 1000 . " sec"
    endif
endfunction

function! mytimer#TimerStop() abort
    if !exists("g:timer")
        echohl WarningMsg
        echo " Error: There is no running timer!!!! Please run 'TimerStart' first."
        echohl none
    else
        call timer_stop(g:timer)
        unlet g:timer
    endif
endfunction
