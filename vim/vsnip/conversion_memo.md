## How to convert UltiSnips to vscode snippets

```vimscript
" Escape double quote
%s/"/\\"/g

" 1. Escape \$ as \\$
%s/\\$/\\\\$/g
" OR
" 2. Escape $foo as \\$foo
%s/[^\]\(\$[a-zA-Z]\)/\\\\\1/g

" Escape backslash
%s/\\/\\\\/g
" Replace newline"
%s/\n/\\n/g
````

