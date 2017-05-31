" let s:count = 0

" function! Disp(ch, msg)
    " let s:count += 1
    " echom s:count a:msg
" endfunction

" let s:job = job_start("vim --version",  { "callback" : "Disp"})

" echom "start"
      let s:cpsmbuild_python_dir = input('Cpsm Python3 directory:', '', 'file')
      let s:cpsmbuild_boost_dir = input('Cpsm Boost directory:', '', 'file')
      let s:cpsmbuild_python_dir = substitute(s:cpsmbuild_python_dir,'\\$','','g')
      let s:cpsmbuild_boost_dir = substitute(s:cpsmbuild_boost_dir,'\\$','','g')

      call system($MYDOTFILES . '/tools/cpsm_winmake.bat ' . s:cpsmbuild_python_dir . ' ' . s:cpsmbuild_boost_dir)
      if v:shell_error == 0
        let s:ctrlp_my_match_func = { 'match' : 'cpsm#CtrlPMatch' }
      else
        echomsg 'Couldn''t build cpsm correctry'
      endif
