#!/usr/bin/env bash
# Moved from install-invoke.sh – validates CLI arguments and handles unknown commands
# CLI dispatcher extracted from install-invoke.sh
# Provides a single entry point that validates arguments and runs the requested command.


dispatch_command() {
    # Determine the command (default: install)
    if [[ $# -eq 0 ]]; then
        local arg="install"
    else
        local arg=$1
    fi

    # Validate the argument using the existing function
    check_arguments "${arg}"

    # Show banner and echo the chosen argument
    ascii_art
    echo "Argument: ${arg}"

    # Run the command (skip backup for debug)
    if [[ ${arg} != "debug" ]]; then
        backup
        ${arg}
    fi

    echo -e "\nDone.\n"
}

# validates CLI arguments and handles unknown commands
check_arguments() {
    case $1 in
        --help)
            help
            exit 0
            ;;
        install)   ;;
        reinstall) ;;
        redeploy)  ;;
        update)    ;;
        undeploy)  ;;
        uninstall) ;;
        debug)     ;;
        buildtools)
            # case $2 in
            #     vim|neovim|tig|tmux|all)
            #         ;;
            #     *)
            #         buildtools_help
            #         ;;
            # esac
            ;;
        runtest)   ;;
        *)
            echo "Unknown argument: ${arg}"
            help
            exit 1
            ;;
    esac
}

