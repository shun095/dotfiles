scriptencoding utf-8

fun! mymisc#config#ddc#setup() abort
  cal ddc#custom#patch_global('ui', 'native')
  cal ddc#custom#patch_global('autoCompleteDelay', 200)
  cal ddc#custom#patch_global('backspaceCompletion', g:true)
  cal ddc#custom#patch_global('sources', [
        \ 'neosnippet',
        \ 'ultisnips',
        \ 'vsnip',
        \ 'vim-lsp',
        \ 'file',
        \ 'around',
        \ ])

  cal ddc#custom#patch_global('sourceOptions', {
        \   '_': {
        \     'matchers': ['matcher_head'],
        \     'sorters': ['sorter_rank'],
        \     'minAutoCompleteLength': 1,
        \     'dup': g:true
        \   },
        \   'around': {
        \     'mark': 'around',
        \     'maxItems': 5,
        \   },
        \   'file': {
        \     'mark': 'path',
        \     'isVolatile': v:true,
        \     'forceCompletionPattern': '\S/\S*',
        \   },
        \   'vsnip': {
        \     'mark': 'vsnip',
        \   },
        \   'vim-lsp': {
        \     'mark': 'lsp',
        \     'maxItems': 20,
        \   },
        \   'ultisnips': {
        \     'mark': 'ultisnips',
        \     'maxItems': 3,
        \   },
        \   'neosnippet': {
        \     'mark': 'neosnippet',
        \     'maxItems': 3,
        \   }
        \ })

  cal ddc#enable()
endf
