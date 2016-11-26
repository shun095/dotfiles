let s:count = 0

function! Disp(ch, msg)
    let s:count += 1
    echom s:count a:msg
endfunction

let s:job = job_start("vim --version",  { "callback" : "Disp"})

echom "start"
