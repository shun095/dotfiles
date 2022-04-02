finish
scriptencoding utf-8
if &compatible
  set nocompatible
endif

let s:go = "\<c-g>U"
let s:left = s:go . "\<left>"
let s:right = s:go . "\<right>"

let s:debug = 0

let s:default_rules = [
      \   {
      \     'begin': '(',
      \     'end': ')',
      \   },
      \   {
      \     'begin': "'",
      \     'end': "'",
      \   },
      \   {
      \     'begin': '"',
      \     'end': '"',
      \   },
      \ ]

fun! closebraces#init() abort
  let g:closebraces#rules = s:default_rules
  let s:rules_begin_strs = []
  let s:rules_end_strs = []
  for rule in g:closebraces#rules
    call add(s:rules_begin_strs, rule['begin'])
    call add(s:rules_end_strs, rule['end'])
  endfo
endf

fun! s:begin_idx(str) abort
  return index(s:rules_begin_strs, a:str)
endf
  
fun! s:end_idx(str) abort
  return index(s:rules_end_strs, a:str)
endf

fun! s:brace_is_opening() abort
  let str_curline = getline('.')
  let str_before_cur = str_curline[:getcurpos()[2]-2]
  let str_after_cur = str_curline[getcurpos()[2]-1:]

  for i in range(len(s:rules_begin_strs))
    let begin_str = s:rules_begin_strs[i]
    let end_str = s:rules_end_strs[i]

    let match_begin = matchend(str_before_cur, begin_str . '\s*$')

    if match_begin >= 0
      return [i, begin_str]
    endif
  endfo
  return []
endf

fun! s:cursor_is_between_braces() abort
  let str_curline = getline('.')
  let str_before_cur = str_curline[:getcurpos()[2]-2]
  let str_after_cur = str_curline[getcurpos()[2]-1:]

  for i in range(len(s:rules_begin_strs))
    let begin_str = s:rules_begin_strs[i]
    let end_str = s:rules_end_strs[i]

    let match_begin = matchend(str_before_cur, begin_str . '\s*$')
    let match_end = match(str_after_cur, '^\s*' . end_str)

    if match_begin >= 0 && match_end >= 0 
      let match_begin = matchend(str_before_cur, begin_str)
      let match_end = match(str_after_cur, end_str)
      return [match_begin, match_end, begin_str, end_str]
    endif
  endfo

  return []
endf

fun! s:should_not_close(str_after_cur) abort
  return (match(a:str_after_cur, '\w') == 0)
endf

fun! closebraces#insert(str) abort
  let str_curline = getline('.')
  let str_before_cur = str_curline[:getcurpos()[2]-2]
  let str_after_cur = str_curline[getcurpos()[2]-1:]

  let str_type = []
  let input_str = a:str

  if s:begin_idx(input_str) >= 0
    call add(str_type,'begin')

    let begin_str = input_str
    let end_str = s:rules_end_strs[s:begin_idx(begin_str)]
    if s:debug
      echomsg "-- 1 --"
    endif
  endif

  if s:end_idx(input_str) >= 0
    call add(str_type,'end')

    let end_str = input_str
    let begin_str = s:rules_begin_strs[s:end_idx(end_str)]
    if s:debug
      echomsg "-- 2 --"
    endif
  endif

  if input_str ==? 'bs'
    call add(str_type,'bs')
    let input_str="\<bs>"
    if s:debug
      echomsg "-- 3 --"
    endif
  endif

  if input_str ==? 'cr'
    call add(str_type,'cr')
    let input_str="\<cr>"
    if s:debug
      echomsg "-- 4 --"
    endif
  endif

  if input_str ==? 'space'
    call add(str_type,'space')
    let input_str="\<space>"
    if s:debug
      echomsg "-- 5 --"
    endif
  endif

  if !len(str_type)
    return input_str
  endif

  if index(str_type, 'end') >= 0
    let is_between = s:cursor_is_between_braces()
    if len(is_between)
      let match_begin = is_between[0]
      let match_end = is_between[1]
      let begin_str = is_between[2]
      let end_str = is_between[3]

      let distance = match_end
      let ret = ''

      for i in range(distance+1)
        let ret .= s:right
      endfo

      return ret
    endif
  endif

  if index(str_type, 'begin') >= 0
    if s:should_not_close(str_after_cur)
      return input_str
    endif

    return input_str . end_str . s:left
  endif

  if index(str_type, 'cr') >= 0
    if len(s:cursor_is_between_braces())
      return "\<cr>\<esc>O"
    else
      let tmp = s:brace_is_opening()
      if len(tmp)
        let begin_idx = tmp[0]
        let begin_str = tmp[1]
        let end_str = s:rules_end_strs[begin_idx]
        return "\<cr>" . end_str . "\<esc>==O"
      else
        return input_str
      endif
    endif
  endif

  if index(str_type, 'bs') >= 0
    let is_between = s:cursor_is_between_braces()
    if len(is_between)
      let match_begin = is_between[0]
      let match_end = is_between[1]
      let begin_str = is_between[2]
      let end_str = is_between[3]
      let ret = ''
      if len(str_before_cur) == match_begin
        let end_distance = match(str_after_cur, end_str)
        for i in range(end_distance+1)
          let ret .= s:right . "\<bs>"
        endfo
        let ret .= "\<bs>"
        return ret
      else
        return input_str
      endif
    else
      return input_str
    endif
  endif

  if index(str_type, 'space') >= 0
    let is_between = s:cursor_is_between_braces()
    if len(is_between)
      return "\<space>\<space>" . s:left
    else
      return input_str
    endif
  endif

  return input_str
endf
