#!/usr/bin/env bats

# Test suite for cli.sh

load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'

setup() {
    # Stub dependencies used by cli.sh
    ascii_art() { :; }
    backup() { echo "backup called"; }
    help() { echo "help called"; }
    install() { echo "install called"; }
    reinstall() { echo "reinstall called"; }
    redeploy() { echo "redeploy called"; }
    update() { echo "update called"; }
    undeploy() { echo "undeploy called"; }
    uninstall() { echo "uninstall called"; }
    debug() { echo "debug called"; }
    buildtools() { echo "buildtools called"; }
    runtest() { echo "runtest called"; }

    # Source the script under test after stubs are defined
    source ./cli.sh
}

teardown() {
    # Unset all stub functions to avoid leakage between tests
    unset -f ascii_art backup help install reinstall redeploy update undeploy uninstall debug buildtools runtest
}

@test "dispatch_command defaults to install when no arguments are given" {
    run dispatch_command
    assert_success
    assert_output --partial "Argument: install"
    assert_output --partial "backup called"
    assert_output --partial "install called"
}

@test "dispatch_command runs provided known command" {
    run dispatch_command reinstall
    assert_success
    assert_output --partial "Argument: reinstall"
    assert_output --partial "backup called"
    assert_output --partial "reinstall called"
}

@test "dispatch_command with unknown argument exits with error" {
    run dispatch_command unknowncmd
    assert_failure
    assert_output --partial "Unknown argument:"
    assert_output --partial "help called"
}

@test "check_arguments --help calls help and exits 0" {
    run check_arguments --help
    assert_success
    assert_output "help called"
}
