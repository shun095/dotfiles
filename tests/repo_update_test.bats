#!/usr/bin/env bats

load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'

setup() {
    # Temporary repository directories
    export MYDOTFILES=$(mktemp -d)
    export FZFDIR=$(mktemp -d)
    export OHMYZSHDIR=$(mktemp -d)
    export TMUXTPMDIR=$(mktemp -d)

    # Stub echo_section to avoid noisy output
    echo_section() { :; }

    # Create a mock git that records full command line arguments
    MOCK_BIN=$(mktemp -d)
    cat > "$MOCK_BIN/git" <<'EOF'
#!/usr/bin/env bash
# Append the full command line to a temporary log file
printf '%s\n' "$*" >> "${TMPDIR:-/tmp}/git_calls.log"
exit 0
EOF
    chmod +x "$MOCK_BIN/git"
    export PATH="$MOCK_BIN:$PATH"

    # Ensure a successful upgrade script exists by default
    mkdir -p "$OHMYZSHDIR/tools"
    cat > "$OHMYZSHDIR/tools/upgrade.sh" <<'EOF'
#!/usr/bin/env bash
exit 0
EOF
    chmod +x "$OHMYZSHDIR/tools/upgrade.sh"

    # Source the module under test
    source ./repo_update.sh
}

teardown() {
    rm -rf "$MYDOTFILES" "$FZFDIR" "$OHMYZSHDIR" "$TMUXTPMDIR" "$MOCK_BIN"
    rm -f "${TMPDIR:-/tmp}/git_calls.log"
}

@test "update_repositories runs git with all expected arguments" {
    run update_repositories
    assert_success

    # Load recorded git calls
    mapfile -t GIT_CALLS < "${TMPDIR:-/tmp}/git_calls.log"

    expected=(
        "--git-dir=${MYDOTFILES}/.git --work-tree=${MYDOTFILES} pull"
        "--git-dir=${FZFDIR}/.git --work-tree=${FZFDIR} pull"
        "--git-dir=${OHMYZSHDIR}/custom/plugins/zsh-syntax-highlighting/.git --work-tree=${OHMYZSHDIR}/custom/plugins/zsh-syntax-highlighting/ pull"
        "--git-dir=${OHMYZSHDIR}/custom/plugins/zsh-autosuggestions/.git --work-tree=${OHMYZSHDIR}/custom/plugins/zsh-autosuggestions/ pull"
        "--git-dir=${OHMYZSHDIR}/custom/plugins/zsh-completions/.git --work-tree=${OHMYZSHDIR}/custom/plugins/zsh-completions/ pull"
        "--git-dir=${OHMYZSHDIR}/custom/plugins/zsh-defer/.git --work-tree=${OHMYZSHDIR}/custom/plugins/zsh-defer/ pull"
        "--git-dir=${OHMYZSHDIR}/custom/plugins/pyenv-lazy/.git --work-tree=${OHMYZSHDIR}/custom/plugins/pyenv-lazy/ pull"
        "--git-dir=${TMUXTPMDIR}/.git --work-tree=${TMUXTPMDIR} pull"
    )

    for pattern in "${expected[@]}"; do
        found=0
        for call in "${GIT_CALLS[@]}"; do
            if [[ "$call" == *"$pattern"* ]]; then
                found=1
                break
            fi
        done
        assert_equal "$found" 1 "Expected git call containing: $pattern"
    done
}

@test "update_repositories exits non‑zero when upgrade script fails" {
    # Make the upgrade script return failure
    cat > "$OHMYZSHDIR/tools/upgrade.sh" <<'EOF'
#!/usr/bin/env bash
exit 1
EOF
    chmod +x "$OHMYZSHDIR/tools/upgrade.sh"

    run update_repositories
    assert_failure
}
