#!/usr/bin/env bats

# Test that config.sh defines expected environment variables

test_config_exports {
    run bash -c 'source ./config.sh; echo "$DOTFILES_VERSION"'
    [ "$status" -eq 0 ]
    [ "$output" = "0.1.0" ]
}
