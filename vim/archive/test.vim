function! TestErrFmt(errfmt,lines)
  let temp_errorfomat = &errorformat
  try
    let &errorformat = a:errfmt
    cexpr join(a:lines,"\n")
    copen
  catch
    echo v:exception
    echo v:throwpoint
  finally
    let &errorformat = temp_errorfomat
  endtry
endfunction
|| [rosmake-3] Starting >>> sensor_msgs [ make ]                                                                                                                                                 
|| [rosmake-3] Finished <<< sensor_msgs ROS_NOBUILD in package sensor_msgs
%G-[rosmake-%c] %f >>> %s
%G-[rosmake-%c] %f <<< %s

%*[^"]"%f"%*\D%l: %m,
"%f"%*\D%l: %m,
%-G%f:%l: (Each undeclared identifier is reported only once,
%-G%f:%l: for each function it appears in.),
%-GIn file included from %f:%l:%c:,
%-GIn file included from %f:%l:%c\,
,
%-GIn file included from %f:%l:%c,
%-GIn file included from %f:%l,
%-G%*[ ]from %f:%l:%c,
%-G%*[ ]from %f:%l:,
%-G%*[ ]from %f:%l\,
,
%-G%*[ ]from %f:%l,
%f:%l:%c:%m,
%f(%l):%m,
%f:%l:%m,
"%f"\,
 line %l%*\D%c%*[^ ] %m,
%D%*\a[%*\d]: Entering directory %*[`']%f',
%X%*\a[%*\d]: Leaving directory %*[`']%f',
%D%*\a: Entering directory %*[`']%f',
%X%*\a: Leaving directory %*[`']%f',
%DMaking %*\a in %f,
%f|%l| %m
