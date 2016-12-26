pyfile <sfile>:h:h/src/hello.py
python import vim

function! hello#hello(name)
    python hello_hello(vim.eval('a:name'))
endfunction
