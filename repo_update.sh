# Repository update logic – extracted for SRP compliance

update_repositories() {
    echo_section "Upgrading plugin repositories"

    local old_cwd=$(pwd)

    echo "Upgrading dotfiles repository"
    git --git-dir=${MYDOTFILES}/.git --work-tree=${MYDOTFILES} pull

    echo "Upgrading fzf repository"
    git --git-dir=${FZFDIR}/.git --work-tree=${FZFDIR} pull

    echo "Upgrading oh-my-zsh repository"
    cd ${OHMYZSHDIR}
set +e
    ./tools/upgrade.sh
    upgrade_status=$?
    set -e

    # if not newest (80) or upgraded (0), exit as error
    if [[ ! ($upgrade_status == 80 || $upgrade_status == 0) ]];then
        exit $upgrade_status
    fi

    echo "Upgrading oh-my-zsh plugins"
    echo "  Upgrading zsh-syntax-highlighting"
    git --git-dir=${OHMYZSHDIR}/custom/plugins/zsh-syntax-highlighting/.git \
        --work-tree=${OHMYZSHDIR}/custom/plugins/zsh-syntax-highlighting/ \
        pull &

    echo "  Upgrading zsh-autosuggestions"
    git --git-dir=${OHMYZSHDIR}/custom/plugins/zsh-autosuggestions/.git \
        --work-tree=${OHMYZSHDIR}/custom/plugins/zsh-autosuggestions/ \
        pull &

    echo "  Upgrading zsh-completions"
    git --git-dir=${OHMYZSHDIR}/custom/plugins/zsh-completions/.git \
        --work-tree=${OHMYZSHDIR}/custom/plugins/zsh-completions/ \
        pull &

    echo "  Upgrading zsh-defer"
    git --git-dir=${OHMYZSHDIR}/custom/plugins/zsh-defer/.git \
        --work-tree=${OHMYZSHDIR}/custom/plugins/zsh-defer/ \
        pull &

    echo "  Upgrading pyenv-lazy"
    git --git-dir=${OHMYZSHDIR}/custom/plugins/pyenv-lazy/.git \
        --work-tree=${OHMYZSHDIR}/custom/plugins/pyenv-lazy/ \
        pull &

    wait

    echo "Upgrading tmux tpm repository"
    git --git-dir=${TMUXTPMDIR}/.git --work-tree=${TMUXTPMDIR} pull

    cd ${old_cwd}
}
