" if exists('g:loaded_mymisc')
"   finish
" endif
let g:loaded_mymisc = 1

let s:save_cpo = &cpo
set cpo&vim

" let s:Promise = vital#mymisc#import('Async.Promise')

" function! s:callback_resolve(res, rej) abort
"   echom "qwer"
"   cal a:rej(1)
" endfunction


" function! mymisc#resolve() abort
"   echomsg "Hello"
"   let p = s:Promise.new({res,rej -> res(1)})
"         \.then(funcref('s:callback1'))
"         \.then(funcref('s:callback4'))
"   cal s:Promise.wait(p)
"   echomsg "!"
" endfunction


" fun! s:callback1(val)
"   echom "1start: " . string(a:val)

"   let p1 = s:Promise.new({res, rej -> res(2)})
"         \.then(funcref('s:callback2'))
"   let p2 = s:Promise.new({res, rej -> res(3)})
"         \.then(funcref('s:callback2'))

"   let pall = s:Promise.all([
"         \p1,
"         \p2
"         \])
"         \.then(funcref('s:callback3'))

"   echom "1end  : " . string(a:val)
"   return pall
" endf


" fun! s:callback2(val)
"   echom "2start: " . string(a:val)

"   echom "2end: " . string(a:val)
"   return a:val
" endf

" fun! s:callback3(val)
"   echom "3start: " . string(a:val)

"   echom "3end: " . string(a:val)
"   return a:val
" endf

" fun! s:callback4(val)
"   echom "4start: " . string(a:val)

"   echom "4end: " . string(a:val)
"   return a:val
" endf

" com! Resolve call mymisc#resolve()

" " Resolve
"
function! s:cb(ch, msg) abort
    echom a:msg
endfunction

function! mymisc#jobstart() abort
    cal job_start(["bash", "-c", "ls -la " . $HOME . "/.vimrc | awk '{ print $3 \":\" $4 }'" ], #{ out_cb: funcref('s:cb')})
endfunction

com! JobStart call mymisc#jobstart()

let &cpo = s:save_cpo
unlet s:save_cpo
