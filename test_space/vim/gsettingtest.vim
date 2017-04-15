augroup test
  autocmd!
  let s:curshape_str = 'profile=$(gsettings get org.gnome.Terminal.ProfilesList default); '
  let s:curshape_str .= 'profile=${profile:1:-1}; '
  let s:curshape_str .= 'gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" '
  let s:curshape_str .= 'cursor-shape '
  autocmd InsertEnter * silent call job_start(['/bin/bash', '-c', s:curshape_str . 'ibeam'])
  autocmd InsertLeave * silent call job_start(['/bin/bash', '-c', s:curshape_str . 'block'])
  autocmd VimLeave * silent job_start(['/bin/bash', '-c', s:curshape_str . 'block'])
augroup END

let s:count = 0
" job で実行された外部コマンドの結果を読みこむときに呼ばれる
function! Disp(ch, msg)
  let s:count += 1
  echom s:count a:msg
endfunction

" 第一引数に実行するコマンド（とオプション）を渡す
" 第二引数にオプションを辞書で渡す（今回はコールバック関数を指定）
" 戻り値に Job object が返ってくる

" let s:job = job_start(['/bin/bash','-c','profile=$(gsettings get org.gnome.Terminal.ProfilesList default);profile=${profile:1:-1};gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" cursor-shape ibeam'] ,  { "callback" : "Disp"})
let s:job = job_start(['/bin/bash','-c',s:curshape_str] ,  { "callback" : "Disp"})

" 外部コマンドの実行をブロックせずにすぐに呼ばれる
echom "start"
