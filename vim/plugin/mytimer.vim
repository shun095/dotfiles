function! s:MyHandler(timer)
    let alert_string = "JIKAN DAYO!!!!!!!!!!"
    echo alert_string 
    new
    execute ":normal a" . alert_string
endfunction

function! s:TimerStart() abort
    let time_min = input("How long? [min]: ")
    let time_milisec = time_min*60*1000 " converting min to milisec
    let g:timer = timer_start(time_milisec, 'MyHandler',
                \ {'repeat': 1})
endfunction

function! s:TimerInfo() abort
    let timer_info = timer_info(g:timer)
    let timer_remain_milisec = timer_info[0]["remaining"]
    echo  timer_remain_milisec / 60000 . " min " . timer_remain_milisec % 60000 / 1000 . " sec"
endfunction

function! s:TimerStop() abort
    call timer_stop(g:timer)
endfunction

command! TimerStart call <SID>TimerStart()
command! TimerStop call <SID>TimerStop()
command! TimerInfo call <SID>TimerInfo()

