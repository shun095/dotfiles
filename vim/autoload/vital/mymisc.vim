let s:plugin_name = expand('<sfile>:t:r')
let s:vital_base_dir = expand('<sfile>:h')
let s:project_root = expand('<sfile>:h:h:h')
let s:is_vital_vim = s:plugin_name is# 'vital'

let s:loaded = {}
let s:cache_sid = {}

" function() wrapper
if v:version > 703 || v:version == 703 && has('patch1170')
  fun! s:_function(fstr) abort
    return function(a:fstr)
  endf
else
  fun! s:_SID() abort
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
  endf
  let s:_s = '<SNR>' . s:_SID() . '_'
  fun! s:_function(fstr) abort
    return function(substitute(a:fstr, 's:', s:_s, 'g'))
  endf
endif

fun! vital#{s:plugin_name}#new() abort
  return s:new(s:plugin_name)
endf

fun! vital#{s:plugin_name}#import(...) abort
  if !exists('s:V')
    let s:V = s:new(s:plugin_name)
  endif
  return call(s:V.import, a:000, s:V)
endf

let s:Vital = {}

fun! s:new(plugin_name) abort
  let base = deepcopy(s:Vital)
  let base._plugin_name = a:plugin_name
  return base
endf

fun! s:vital_files() abort
  if !exists('s:vital_files')
    let s:vital_files = map(
    \   s:is_vital_vim ? s:_global_vital_files() : s:_self_vital_files(),
    \   'fnamemodify(v:val, ":p:gs?[\\\\/]?/?")')
  endif
  return copy(s:vital_files)
endf
let s:Vital.vital_files = s:_function('s:vital_files')

fun! s:import(name, ...) abort dict
  let target = {}
  let functions = []
  for a in a:000
    if type(a) == type({})
      let target = a
    elseif type(a) == type([])
      let functions = a
    endif
    unlet a
  endfo
  let module = self._import(a:name)
  if empty(functions)
    call extend(target, module, 'keep')
  else
    for f in functions
      if has_key(module, f) && !has_key(target, f)
        let target[f] = module[f]
      endif
    endfo
  endif
  return target
endf
let s:Vital.import = s:_function('s:import')

fun! s:load(...) abort dict
  for arg in a:000
    let [name; as] = type(arg) == type([]) ? arg[: 1] : [arg, arg]
    let target = split(join(as, ''), '\W\+')
    let dict = self
    let dict_type = type({})
    while !empty(target)
      let ns = remove(target, 0)
      if !has_key(dict, ns)
        let dict[ns] = {}
      endif
      if type(dict[ns]) == dict_type
        let dict = dict[ns]
      else
        unlet dict
        break
      endif
    endwhile
    if exists('dict')
      call extend(dict, self._import(name))
    endif
    unlet arg
  endfo
  return self
endf
let s:Vital.load = s:_function('s:load')

fun! s:unload() abort dict
  let s:loaded = {}
  let s:cache_sid = {}
  unlet! s:vital_files
endf
let s:Vital.unload = s:_function('s:unload')

fun! s:exists(name) abort dict
  if a:name !~# '\v^\u\w*%(\.\u\w*)*$'
    throw 'vital: Invalid module name: ' . a:name
  endif
  return s:_module_path(a:name) isnot# ''
endf
let s:Vital.exists = s:_function('s:exists')

fun! s:search(pattern) abort dict
  let paths = s:_extract_files(a:pattern, self.vital_files())
  let modules = sort(map(paths, 's:_file2module(v:val)'))
  return s:_uniq(modules)
endf
let s:Vital.search = s:_function('s:search')

fun! s:plugin_name() abort dict
  return self._plugin_name
endf
let s:Vital.plugin_name = s:_function('s:plugin_name')

fun! s:_self_vital_files() abort
  let builtin = printf('%s/__%s__/', s:vital_base_dir, s:plugin_name)
  let installed = printf('%s/_%s/', s:vital_base_dir, s:plugin_name)
  let base = builtin . ',' . installed
  return split(globpath(base, '**/*.vim', 1), "\n")
endf

fun! s:_global_vital_files() abort
  let pattern = 'autoload/vital/__*__/**/*.vim'
  return split(globpath(&runtimepath, pattern, 1), "\n")
endf

fun! s:_extract_files(pattern, files) abort
  let tr = {'.': '/', '*': '[^/]*', '**': '.*'}
  let target = substitute(a:pattern, '\.\|\*\*\?', '\=tr[submatch(0)]', 'g')
  let regexp = printf('autoload/vital/[^/]\+/%s.vim$', target)
  return filter(a:files, 'v:val =~# regexp')
endf

fun! s:_file2module(file) abort
  let filename = fnamemodify(a:file, ':p:gs?[\\/]?/?')
  let tail = matchstr(filename, 'autoload/vital/_\w\+/\zs.*\ze\.vim$')
  return join(split(tail, '[\\/]\+'), '.')
endf

" @param {string} name e.g. Data.List
fun! s:_import(name) abort dict
  if has_key(s:loaded, a:name)
    return copy(s:loaded[a:name])
  endif
  let module = self._get_module(a:name)
  if has_key(module, '_vital_created')
    call module._vital_created(module)
  endif
  let export_module = filter(copy(module), 'v:key =~# "^\\a"')
  " Cache module before calling module.vital_loaded() to avoid cyclic
  " dependences but remove the cache if module._vital_loaded() fails.
  " let s:loaded[a:name] = export_module
  let s:loaded[a:name] = export_module
  if has_key(module, '_vital_loaded')
    try
      call module._vital_loaded(vital#{s:plugin_name}#new())
    catch
      unlet s:loaded[a:name]
      throw 'vital: fail to call ._vital_loaded(): ' . v:exception
    endt
  endif
  return copy(s:loaded[a:name])
endf
let s:Vital._import = s:_function('s:_import')

" s:_get_module() returns module object wihch has all script local functions.
fun! s:_get_module(name) abort dict
  let funcname = s:_import_func_name(self.plugin_name(), a:name)
  try
    return call(funcname, [])
  catch /^Vim\%((\a\+)\)\?:E117/
    return s:_get_builtin_module(a:name)
  endt
endf

fun! s:_get_builtin_module(name) abort
 return s:sid2sfuncs(s:_module_sid(a:name))
endf

if s:is_vital_vim
  " For vital.vim, we can use s:_get_builtin_module directly
  let s:Vital._get_module = s:_function('s:_get_builtin_module')
else
  let s:Vital._get_module = s:_function('s:_get_module')
endif

fun! s:_import_func_name(plugin_name, module_name) abort
  return printf('vital#_%s#%s#import', a:plugin_name, s:_dot_to_sharp(a:module_name))
endf

fun! s:_module_sid(name) abort
  let path = s:_module_path(a:name)
  if !filereadable(path)
    throw 'vital: module not found: ' . a:name
  endif
  let vital_dir = s:is_vital_vim ? '__\w\+__' : printf('_\{1,2}%s\%%(__\)\?', s:plugin_name)
  let base = join([vital_dir, ''], '[/\\]\+')
  let p = base . substitute('' . a:name, '\.', '[/\\\\]\\+', 'g')
  let sid = s:_sid(path, p)
  if !sid
    call s:_source(path)
    let sid = s:_sid(path, p)
    if !sid
      throw printf('vital: cannot get <SID> from path: %s', path)
    endif
  endif
  return sid
endf

fun! s:_module_path(name) abort
  return get(s:_extract_files(a:name, s:vital_files()), 0, '')
endf

fun! s:_module_sid_base_dir() abort
  return s:is_vital_vim ? &rtp : s:project_root
endf

fun! s:_dot_to_sharp(name) abort
  return substitute(a:name, '\.', '#', 'g')
endf

fun! s:_source(path) abort
  execute 'source' fnameescape(a:path)
endf

" @vimlint(EVL102, 1, l:_)
" @vimlint(EVL102, 1, l:__)
fun! s:_sid(path, filter_pattern) abort
  let unified_path = s:_unify_path(a:path)
  if has_key(s:cache_sid, unified_path)
    return s:cache_sid[unified_path]
  endif
  for line in filter(split(s:_execute(':scriptnames'), "\n"), 'v:val =~# a:filter_pattern')
    let [_, sid, path; __] = matchlist(line, '^\s*\(\d\+\):\s\+\(.\+\)\s*$')
    if s:_unify_path(path) is# unified_path
      let s:cache_sid[unified_path] = sid
      return s:cache_sid[unified_path]
    endif
  endfo
  return 0
endf

" We want to use a execute() builtin function instead of s:_execute(),
" however there is a bug in execute().
" execute() returns empty string when it is called in
" completion function of user defined ex command.
" https://github.com/vim-jp/issues/issues/1129
fun! s:_execute(cmd) abort
  let [save_verbose, save_verbosefile] = [&verbose, &verbosefile]
  set verbose=0 verbosefile=
  redir => res
    silent! execute a:cmd
  redir END
  let [&verbose, &verbosefile] = [save_verbose, save_verbosefile]
  return res
endf

if filereadable(expand('<sfile>:r') . '.VIM') " is case-insensitive or not
  let s:_unify_path_cache = {}
  " resolve() is slow, so we cache results.
  " Note: On windows, vim can't expand path names from 8.3 formats.
  " So if getting full path via <sfile> and $HOME was set as 8.3 format,
  " vital load duplicated scripts. Below's :~ avoid this issue.
  fun! s:_unify_path(path) abort
    if has_key(s:_unify_path_cache, a:path)
      return s:_unify_path_cache[a:path]
    endif
    let value = tolower(fnamemodify(resolve(fnamemodify(
    \                   a:path, ':p')), ':~:gs?[\\/]?/?'))
    let s:_unify_path_cache[a:path] = value
    return value
  endf
else
  fun! s:_unify_path(path) abort
    return resolve(fnamemodify(a:path, ':p:gs?[\\/]?/?'))
  endf
endif

" copied and modified from Vim.ScriptLocal
let s:SNR = join(map(range(len("\<SNR>")), '"[\\x" . printf("%0x", char2nr("\<SNR>"[v:val])) . "]"'), '')
fun! s:sid2sfuncs(sid) abort
  let fs = split(s:_execute(printf(':function /^%s%s_', s:SNR, a:sid)), "\n")
  let r = {}
  let pattern = printf('\m^function\s<SNR>%d_\zs\w\{-}\ze(', a:sid)
  for fname in map(fs, 'matchstr(v:val, pattern)')
    let r[fname] = function(s:_sfuncname(a:sid, fname))
  endfo
  return r
endf

"" Return funcname of script local functions with SID
fun! s:_sfuncname(sid, funcname) abort
  return printf('<SNR>%s_%s', a:sid, a:funcname)
endf

if exists('*uniq')
  fun! s:_uniq(list) abort
    return uniq(a:list)
  endf
else
  fun! s:_uniq(list) abort
    let i = len(a:list) - 1
    while 0 < i
      if a:list[i] ==# a:list[i - 1]
        call remove(a:list, i)
      endif
      let i -= 1
    endwhile
    return a:list
  endf
endif
