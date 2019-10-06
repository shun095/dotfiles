#!/usr/bin/env zsh

local MARK="%(?,%{$fg_bold[blue]%}>,%{$fg_bold[red]%}[%?]"$'\n'">)"
if [[ "$USER" == "root" ]]; then USERCOLOR="red"; else USERCOLOR="green"; fi

# Git sometimes goes into a detached head state. git_prompt_info doesn't
# return anything in this case. So wrap it in another function and check
# for an empty string.
function check_git_prompt_info() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        echo -n " "
        if [[ -z $(git_prompt_info) ]]; then
            echo -n "%{$fg_bold[blue]%}detached-head%{$reset_color%})"
        else
            echo -n "$(git_prompt_info) "
        fi
        echo -n "$(git_prompt_status)"
        # echo -n " $(git_prompt_short_sha)"
    fi
    echo -n "%{$reset_color%}"
}

function get_right_prompt() {
    echo -n "%{$reset_color%}["
    # echo -n "%{$fg_no_bold[cyan]%}%D{%Y-%m-%d %H:%M:%S}"
    echo -n "%D{%Y-%m-%d %H:%M:%S}"
    echo -n "%{$reset_color%}]"
}

function get_pyenv_prompt() {
    if type pyenv > /dev/null; then
        echo " (pyenv:$(pyenv_prompt_info))"
    fi
}

re-prompt() {
    zle .reset-prompt
    zle .accept-line
}

zle -N accept-line re-prompt

PROMPT='
'$MARK' $(get_right_prompt)%{$reset_color%}$(get_pyenv_prompt)$(check_git_prompt_info)
%{$fg_bold[$USERCOLOR]%}%n%{$reset_color%}@%{$fg_bold[blue]%}%m %{$reset_color%}%5~
%{$fg_bold[cyan]%}$ %{$reset_color%}'

# RPROMPT='$(get_right_prompt)'

# Format for git_prompt_info()
ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg_bold[blue]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%} CLEAN"

# Format for git_prompt_status()
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[green]%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[blue]%}!"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%}-"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg_bold[magenta]%}>"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[yellow]%}#"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[cyan]%}?"

# Format for git_prompt_ahead()
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[white]%}^"

# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE="%{$reset_color%}[%{$fg_no_bold[blue]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%}]"
