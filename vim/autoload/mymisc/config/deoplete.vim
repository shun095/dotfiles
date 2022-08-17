scriptencoding utf-8

fun! mymisc#config#deoplete#setup() abort
  " For debugging
  " call deoplete#custom#option('profile', v:true)
  " call deoplete#enable_logging('DEBUG', $MYVIMRUNTIME.'/deoplete.log')
  " call deoplete#custom#source("_",'is_debug_enabled',1)

  if has('win32') && !exists('g:python3_host_prog')
    let g:python3_host_prog = 'python'
  endif

  let g:deoplete#enable_at_startup = 1

  ino <expr><C-Space> deoplete#mappings#manual_complete()

  call deoplete#custom#var('omni', 'input_patterns', {
        \ 'html':       ['\w+'],
        \ 'css':        ['\w+|\w[ \t]*:[ \t]*\w*'],
        \ 'sass':       ['\w+|\w[ \t]*:[ \t]*\w*'],
        \ 'scss':       ['\w+|\w[ \t]*:[ \t]*\w*'],
        \})

  call deoplete#custom#var('omni', 'functions', {
        \ 'html':       ['LanguageClient#complete'],
        \ 'css':        ['csscomplete#CompleteCSS'],
        \ 'sass':       ['csscomplete#CompleteCSS'],
        \ 'scss':       ['csscomplete#CompleteCSS'],
        \})

  call deoplete#custom#source('_','max_menu_width',0)
  call deoplete#custom#source('_','min_pattern_length', 1)

  call deoplete#custom#option({
        \ 'auto_complete_delay': 20,
        \ 'smart_case': v:false,
        \ 'ignore_sources': {
        \   'c':   ['clang_complete'],
        \   'h':   ['clang_complete'],
        \   'cpp': ['clang_complete'],
        \   'hpp': ['clang_complete'],
        \   }
        \ })
endf
