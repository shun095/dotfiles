scriptencoding utf-8

function! mymisc#config#ale#setup() abort
  " tsserverはeslintを呼ばないので別でlinterを定義する必要あり
  let g:ale_fixers = {
        \ 'javascript': ['eslint'],
        \ 'typescript': ['eslint'],
        \ 'vue': ['eslint'],
        \ }
  let g:ale_fix_on_save = 0
  let g:ale_linters = {
        \ 'javascript': ['eslint'],
        \ 'typescript': ['eslint'],
        \ }
  " NOTE: Default ale linters:
  " {
  " \   'csh': ['shell'],
  " \   'elixir': ['credo', 'dialyxir', 'dogma'],
  " \   'go': ['gofmt', 'golint', 'go vet'],
  " \   'hack': ['hack'],
  " \   'help': [],
  " \   'perl': ['perlcritic'],
  " \   'perl6': [],
  " \   'python': ['flake8', 'mypy', 'pylint'],
  " \   'rust': ['cargo'],
  " \   'spec': [],
  " \   'text': [],
  " \   'vue': ['eslint', 'vls'],
  " \   'zsh': ['shell'],
  " \}
  let g:ale_echo_msg_format = 'ALE: (%linter%) %[code] %%s'
  let g:ale_sign_error = 'E'
  let g:ale_sign_warning = 'W'
  let g:ale_sign_info = 'I'
  let g:ale_sign_style_error = 'e'
  let g:ale_sign_style_warning = 'w'
endfunction
