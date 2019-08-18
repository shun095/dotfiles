# Gitのブランチ名が出るようになる
if [ -f /etc/bash_completion.d/git-prompt ]; then
    export PS1='$(__git_ps1) '$PS1
fi
# TABを連続で押すと次の候補に進む
bind 'TAB:menu-complete'
# Shift+TABで前の候補に戻る
bind '"\e[Z":menu-complete-backward'
# 1回目のTABでは一覧を表示する
bind "set show-all-if-ambiguous on"
# 1回目のTABで途中まで文字列が一緒だったらそこまでは補完する
bind "set menu-complete-display-prefix on"
