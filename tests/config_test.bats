#!/usr/bin/env bats

load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'

@test "config.sh defines expected environment variables" {
    run bash -c 'source ./config.sh; echo "$DOTFILES_VERSION"'
    assert_success
    assert_output "0.1.0"
}
