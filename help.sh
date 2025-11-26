#!/usr/bin/env bash
# Help function extracted from install-invoke.sh
help() {
    cat <<'EOF'

usage: $0 [arg]

    --help      Show this message
    install     Install
    buildtools  Build tools from newest codes
    reinstall   Refetch zsh-plugins from repository and reinstall.
    redeploy    Delete symbolic link and link again.
    runtest     Run test.
    update      Update plugins
    undeploy    Delete symbolic link
    uninstall   Uninstall

EOF
}
