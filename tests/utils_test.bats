#!/usr/bin/env bats

load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'

setup() {
    # Create a temporary file for testing
    TMPFILE=$(mktemp)
}

teardown() {
    rm -f "$TMPFILE"
}

@test "append_line adds line when missing" {
    source ./utils.sh
    append_line 1 "test line" "$TMPFILE"
    run grep -F "test line" "$TMPFILE"
    assert_success
    assert_output "test line"
}

@test "append_line skips when line already exists" {
    source ./utils.sh
    echo "already there" > "$TMPFILE"
    append_line 0 "already there" "$TMPFILE"
    # Should not add another line
    run bash -c "wc -l < \"$TMPFILE\" | tr -d ' '"
    assert_output "1"
}
