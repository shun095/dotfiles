#!/usr/bin/env zsh

local MARK="%(?,%{$fg_bold[blue]%}>,%{$fg_bold[red]%}[%?]"$'\n'">)"
if [[ "$USER" == "root" ]]; then USERCOLOR="red"; else USERCOLOR="green"; fi
local SHELL_MARK=""

# Git sometimes goes into a detached head state. _omz_git_prompt_info doesn't
# return anything in this case. So wrap it in another function and check
# for an empty string.
function check_git_prompt_info() {
    # if git rev-parse --git-dir > /dev/null 2>&1; then
        echo -n " "
        if [[ -z $(_omz_git_prompt_info) ]]; then
            echo -n "(%{$fg_bold[blue]%}detached-head%{$reset_color%})"
        else
            echo -n "$(_omz_git_prompt_info) "
        fi
        echo -n "$(_omz_git_prompt_status)"
        # echo -n " $(git_prompt_short_sha)"
    # fi
    echo -n "%{$reset_color%}"
}

function get_datetime() {
    echo -n "%{$reset_color%}"
    echo -n "%D{%Y/%m/%d %H:%M:%S}"
    echo -n "%{$reset_color%}"
}

function get_pyenv_prompt() {
    if type pyenv > /dev/null; then
        if [ ! $(pyenv_prompt_info) = "system" ]; then
            echo -n " [pyenv|$(pyenv_prompt_info)]"
        fi
    fi
}

re-prompt() {
    zle .reset-prompt
    zle .accept-line
}

get_kube_ps1_prompt(){
    if type kube_ps1 > /dev/null; then
        echo -n " $(kube_ps1)"
    fi
}

zle -N accept-line re-prompt

_omz_register_handler get_pyenv_prompt
_omz_register_handler get_kube_ps1_prompt

function async_get_pyenv_prompt() {
    if [[ -n "${_OMZ_ASYNC_OUTPUT[get_pyenv_prompt]}" ]]
    then
        echo -n "${_OMZ_ASYNC_OUTPUT[get_pyenv_prompt]}"
    fi
}

function async_get_kube_ps1_prompt() {
    if [[ -n "${_OMZ_ASYNC_OUTPUT[get_kube_ps1_prompt]}" ]]
    then
        echo -n "${_OMZ_ASYNC_OUTPUT[get_kube_ps1_prompt]}"
    fi
}

PROMPT=$MARK' $(get_datetime)$(async_get_kube_ps1_prompt)%{$reset_color%}$(async_get_pyenv_prompt) $(git_prompt_info) $(git_prompt_status)
%{$fg_bold[$USERCOLOR]%}%n%{$reset_color%}@%{$fg_bold[blue]%}%m %{$reset_color%}%5~
%{$fg_bold[cyan]%}$ %{$reset_color%}'


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
