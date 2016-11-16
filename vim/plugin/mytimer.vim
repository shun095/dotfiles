function! TimerAlert(timer)
    let alert_string = "JIKAN DAYO!!!!!!!!!!"
    1new
    execute ":normal a" . alert_string
    echo alert_string
endfunction

function! s:TimerStart() abort
    let time_min = input("How long? [min]: ")
    let time_milisec = time_min*60*1000 " converting min to milisec
    if !exists("g:timer")
        let g:timer = timer_start(time_milisec, 'TimerAlert',
                    \ {'repeat': 1})
    else
        echo " Error: Timer already exsists!!!!"
    endif
endfunction

function! s:TimerInfo() abort
    let timer_info = timer_info(g:timer)
    let timer_remain_milisec = timer_info[0]["remaining"]
    echo timer_remain_milisec / 60000 . " min " . timer_remain_milisec % 60000 / 1000 . " sec"
endfunction

function! s:TimerStop() abort
    call timer_stop(g:timer)
    unlet g:timer
endfunction

command! TimerStart call <SID>TimerStart()
command! TimerStop call <SID>TimerStop()
command! TimerRemaining call <SID>TimerInfo()

