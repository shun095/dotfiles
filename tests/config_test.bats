#!/usr/bin/env bats

load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'

setup() {
    source ./config.sh
}

@test "config.sh defines expected environment variables" {
run echo "$DOTFILES_VERSION"
    assert_success
    assert_output "0.1.0"
}

@test "config.sh sets MYVIMRUNTIME based on OS" {
run echo "$MYVIMRUNTIME"
    assert_success
    # On macOS, expect $HOME/.vim
    expected="$HOME/.vim"
    assert_output "$expected"
}

@test "config.sh sets VADER_OUTPUT_FILE" {
run echo "$VADER_OUTPUT_FILE"
    assert_success
    assert_output "./test_result.log"
}


@test "config.sh defines MYDOTFILES_LITERAL as literal placeholder" {
    run echo "$MYDOTFILES_LITERAL"
    assert_success
    assert_output "\${SCRIPT_DIR}"
}

