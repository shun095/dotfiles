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

## AI Agent Rules

### MUST Follow

1. **Do NOT modify**: `.gitignore`, `.gitattributes`, `Dockerfile` without explicit approval
2. **Do NOT modify**: `install-invoke.sh`, `utils.sh`, `config.sh` without thorough testing
3. **Do NOT modify**: Test files (`tests/*.bats`) without adding corresponding tests
4. **Do NOT modify**: Plugin configuration files without understanding dependencies
5. **Do NOT modify**: `vim/init.lua`, `zsh/zshrc.zsh` without testing in actual environment

### SHOULD Follow

1. **Test changes**: Always run `./install-invoke.sh runtest` before committing
2. **Backup first**: Use `backup_file()` function before modifying critical files
3. **Document changes**: Update README.md or relevant documentation
4. **Check dependencies**: Verify plugin compatibility before adding new plugins
5. **Use absolute paths**: For symlinks and file operations

### MUST NOT Do

1. **Do NOT commit**: Generated files (`.zwc`, compiled zsh files)
2. **Do NOT commit**: Build artifacts (contents of `build/` directory)
3. **Do NOT commit**: Local configuration files (contents of `localrcs/`)
4. **Do NOT commit**: Sensitive data (passwords, API keys)
5. **Do NOT modify**: File permissions unnecessarily

### File Structure Rules

1. **Symlinks**: Must point to files in the repository
2. **Configuration**: Separate global and local configurations
3. **Plugins**: Manage via plugin managers (lazy.nvim, vim-plug, tpm)
4. **Templates**: Store in `template/` directories
5. **Scripts**: Store in `scripts/` or `tools/` directories

### Vim/Neovim Specific Rules

1. **Plugin management**: Use lazy.nvim for Neovim, vim-plug for Vim
2. **Configuration separation**: Global in `init.lua`, local in `ginit.vim`
3. **After plugin**: Use `after/plugin/` for plugin-specific configurations
4. **Autoload**: Use `autoload/` for custom functions
5. **Lua modules**: Organize in `lua/` directory structure

### Shell Specific Rules

1. **zsh**: Use oh-my-zsh framework with custom plugins
2. **Plugin management**: Use zsh plugin system with `custom/plugins/`
3. **Compilation**: Compile zsh files with `zsh_compile.zsh`
4. **Completion**: Store in `zsh/completions/` directory
5. **Theme**: Custom theme in `zsh/ishitaku.zsh-theme`

### Build System Rules

1. **Source builds**: Use `build_src/` directory for source code
2. **Artifacts**: Store in `build/` directory
3. **Cache**: Respect cached builds in CI/CD pipelines
4. **Cross-platform**: Support both Linux and macOS
5. **Dependencies**: Document all build dependencies

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
