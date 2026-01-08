# AGENTS.md

## Project Overview

This repository contains dotfiles for configuring various development tools and environments. The project provides a unified installation system for:

- **Shell configurations**: zsh, bash
- **Editors**: Vim, Neovim, Emacs, Spacemacs
- **Terminal emulators**: Alacritty, WezTerm
- **Tools**: tmux, tig, fzf, git, mutt
- **Language support**: Python, Ruby, Node.js, Go, Deno

The installation system uses a centralized configuration approach with symlinks to manage dotfiles across multiple systems.

## Build and Test Commands

### Installation Commands

```bash
# Install (default)
./install-invoke.sh

# Build tools from source
./install-invoke.sh buildtools

# Reinstall (clean installation)
./install-invoke.sh reinstall

# Update plugins and repositories
./install-invoke.sh update

# Run tests
./install-invoke.sh runtest

# Show help
./install-invoke.sh --help
```

### Test Suite

The project uses `bats` (Bash Automated Testing System) for testing:

```bash
# Run all tests
./install-invoke.sh runtest

# Run specific test file
bats tests/cli_test.bats
```

Test files are located in the `tests/` directory:
- `cli_test.bats` - CLI argument handling tests
- `config_test.bats` - Configuration tests
- `repo_update_test.bats` - Repository update tests
- `utils_test.bats` - Utility function tests

## AI Agent Rules

### MUST Follow

1. **Do NOT modify**: `.gitignore`, `.gitattributes`, `Dockerfile` without explicit approval
2. **Do NOT modify**: `install-invoke.sh`, `utils.sh`, `config.sh` without thorough testing
3. **Do NOT modify**: Test files (`tests/*.bats`) without adding corresponding tests
4. **Do NOT modify**: Plugin configuration files without understanding dependencies
5. **Do NOT modify**: `vim/init.lua`, `zsh/zshrc.zsh` without testing in actual environment
6. **Keep codebase clean**: Create new directories, move/split files to organize. Update outdated documents
7. **Remove temporary files**: Always check and remove all task-specific documents, tests, or temporal implementations before finishing
8. **Use relative paths**: Always use relative paths for portability unless explicitly necessary
9. **Perform web research**: Always perform external web research when stuck in a bug
10. **Specify timeouts**: Always specify `timeout` parameter when using `bash` tool
11. **Use file tools first**: Always use `write_file`/`read_file`/`grep` tools prior to `bash` tool
12. **Use nohup for servers**: Always use `nohup` to launch servers in background
13. **Act professionally**: Always provide working code that follows best practices and is fully implemented and tested
14. **Use git safely**: Always use extreme caution with `git` commands. Avoid `git reset --hard` and `git checkout <filename>` unless absolutely necessary
15. **Use terminalcp for UI testing**: Always use `terminalcp_terminalcp` tool to execute terminal UI tests manually
16. **Use todo tool**: Always use todo tool to manage tasks. Read existing todos before starting
17. **Follow user instructions**: Always read user instructions carefully. Prioritize user instructions over existing codebase

### MUST NOT Do

1. **Do NOT commit**: Generated files (`.zwc`, compiled zsh files)
2. **Do NOT commit**: Build artifacts (contents of `build/` directory)
3. **Do NOT commit**: Local configuration files (contents of `localrcs/`)
4. **Do NOT commit**: Sensitive data (passwords, API keys)
5. **Do NOT modify**: File permissions unnecessarily
6. **Do NOT assume UI testing**: Strictly avoid assuming UI testing can be completed solely by scripts

### Terminalcp Tool Usage

When launching apps in terminalcp tool, you MUST use:
```bash
ENV1=... uv run <command> [options]
```

- The command MUST be found in `pyproject.toml`
- Environment variables MUST be retrieved by `env | grep -e OPENAI -e MISTRAL`

### Git Safety Rules

- **Never use**: `git reset --hard` or `git checkout <filename>` lightly
- **Use instead**: `git stash --all` to preserve changes
- **Always backup**: Before using dangerous git commands

## Code Style Guidelines

### Shell Scripts

- **Indentation**: 4 spaces (no tabs)
- **Line length**: Maximum 160 characters
- **Quoting**: Always quote variables (`"$var"`)
- **Shebang**: `#!/usr/bin/env bash`
- **Error handling**: Use `set -eu` for strict mode
- **Functions**: Use lowercase with underscores (`function_name()`)

### Vim/Neovim Configuration

- **Filetype**: Lua for Neovim, Vim script for Vim
- **Plugin management**: lazy.nvim for Neovim, vim-plug for Vim
- **Indentation**: 4 spaces for most files, 2 spaces for Python
- **Line length**: 160 characters (flake8 configuration)

### Python

- **Linter**: flake8
- **Line length**: 160 characters
- **Ignored rules**: E127, E128, E201, E202, E221, E225, E226, E231, E271, E302, E303, E402, W291, W293, W391
- **Formatting**: Follow PEP 8 with extended line length

### Vim Script

- **Linter**: vintr
- **Configuration**: `vintrc.yml` in `python/lint/`
- **Policy**: `ProhibitSetNoCompatible` disabled

## Testing Instructions

### Running Tests

```bash
# Run all tests
./install-invoke.sh runtest

# Run specific test
bats tests/cli_test.bats
```

### Test Structure

Tests follow the bats framework structure:
- `setup()` - Define stubs and source test files
- `teardown()` - Clean up stubs
- `@test "description"` - Individual test cases

### Writing Tests

1. Create test file in `tests/` directory
2. Use `bats-assert` for assertions
3. Stub external dependencies in `setup()`
4. Test one function or behavior per test case
5. Clean up in `teardown()`

## Security Considerations

### Installation Safety

- **Backup**: The installer creates backups with rotating history (`.bak0`, `.bak1`, etc.)
- **Symlinks**: Uses absolute paths for symlinks
- **Permissions**: Preserves file permissions during installation
- **Idempotent**: Safe to run multiple times

### Configuration Files

- **Sensitive data**: Store in localrcs directory (`$HOME/localrcs/`)
- **Git ignore**: Sensitive files should be in `.gitignore`
- **Passwords**: Never commit credentials to repository

### Build Process

- **Source builds**: Tools are built from source in `build_src/` directory
- **Cached builds**: Build artifacts cached in `build/` directory
- **Cleanup**: `apt-get clean` runs after installation

## Development Workflow

1. **Clone repository**: `git clone https://github.com/shun095/dotfiles.git`
2. **Install dependencies**: Run `./install-invoke.sh buildtools`
3. **Install dotfiles**: Run `./install-invoke.sh`
4. **Test changes**: Run `./install-invoke.sh runtest`
5. **Commit changes**: Follow conventional commits
6. **Push changes**: Push to feature branch, create PR

## CI/CD Pipeline

The project uses GitHub Actions for continuous integration:

- **Triggers**: Push to master, pull requests to master
- **Platforms**: Ubuntu, macOS
- **Tests**: Installation, build tools, runtime tests
- **Cache**: Build artifacts cached between runs
- **Timeout**: 20 minutes

## Troubleshooting

### Common Issues

1. **Permission errors**: Run with proper permissions or use sudo
2. **Missing dependencies**: Install build tools first
3. **Symlink conflicts**: Use `redeploy` to resolve
4. **Plugin errors**: Update plugins with `update` command
5. **Configuration conflicts**: Check `localrcs/` for overrides

### Debug Mode

```bash
# Run in debug mode (no backup)
./install-invoke.sh debug
```

## Support

- **Issues**: File on GitHub repository
- **Documentation**: README.md and AGENTS.md
- **Configuration**: config.sh for environment variables
- **Help**: `./install-invoke.sh --help`
