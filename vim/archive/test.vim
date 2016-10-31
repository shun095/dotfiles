command! Test call s:test()

function! s:test() abort
	let s:clientid = expand("<client>")
	call remote_send("GVIM", ":call server2client(" . s:clientid . ",'echo 'test'')")
	call remote_read(s:clientid)
endfunction
