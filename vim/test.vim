function! ShowCurrentTime()
	let tempTimer = timer_start(1000, 'CheckTemp', {'repeat' : -1})
	function! CheckTemp(tempTimer)
		let &statusline = strftime("%H:%M:%S")
	endfunction 
endfunction
call ShowCurrentTime()
