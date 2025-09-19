# Specification for `install-invoke.sh`

## Overview
`install-invoke.sh` is a **bash installer script** for the author's dotfiles repository. It automates the setup of development environments by:
- Installing required system packages.
- Cloning the dotfiles repository.
- Deploying configuration files (symlinks, Vim/Neovim/Alacritty/Tmux/WezTerm configs).
- Installing and updating plugins for Zsh, Vim/Neovim, and Tmux.
- Building tools (Vim, Neovim, Tmux, Tig) from source when requested.
- Providing commands for install, reinstall, redeploy, update, uninstall, and test execution.

The script is designed to be **idempotent**; repeated runs should not duplicate work and will backup existing files before overwriting.

## Environment Variables
| Variable | Description | Default |
|----------|-------------|---------|
| `DOTFILES_VERSION` | Version string written to `deployed-version.txt`. | `0.1.0` |
| `MYDOTFILES` | Absolute path to the dotfiles repository (determined at runtime). | `${SCRIPT_DIR}` |
| `MYDOTFILES_LITERAL` | Literal string `${SCRIPT_DIR}` for use in generated files. |
| `MYVIMRUNTIME` | Vim runtime directory (`$HOME/vimfiles` on Cygwin, otherwise `$HOME/.vim`). |
| `VADER_OUTPUT_FILE` | Path for Vader test output. | `./test_result.log` |
| `FZFDIR` | Path to `$HOME/.fzf`. |
| `OHMYZSHDIR` | Path to `$HOME/.oh-my-zsh`. |
| `TMUXPLUGINSDIR` | Path to `$HOME/.tmux/plugins`. |
| `TMUXTPMDIR` | Path to Tmux TPM (`$TMUXPLUGINSDIR/tpm`). |
| `SYMLINKS` | Array of target config files to be symlinked (flake8, vintrc, spacemacs, nvim init, gvimrc, tigrc, alacritty, wezterm). |
| `SYMTARGET` | Corresponding source files inside the repository. |
| `LOCALRCSDIR` | Directory for local rc overrides (`$HOME/localrcs`). |
| `LOCALRCS` | List of local rc files (tmux-local, vim-local.vim, zsh-local.zsh). |
| `TRASH` | Path to `$HOME/.trash` for temporary storage. |

## Core Functions
### `help`
Displays usage information.

### `ascii_art`
Prints a colored ASCII banner.

### `echo_section`
Prints a formatted log line with a description surrounded by `=` characters, using terminal width.

### `update_repositories`
Pulls latest changes for the dotfiles repo, fzf, Oh‑My‑Zsh, and Tmux TPM. Handles Zsh plugin updates in parallel.

### `backup_file`
Creates a rotating backup (`.bak0` → `.bak1` → `.bak2` → `.bak3`) for an existing file before it is overwritten.

### `remove_rcfiles_symlink`
Removes a symlink or regular file at a given path.

### `remove_rcfiles`
Deletes lines added by the script from user rc files (e.g., `.zshrc`, `.zshenv`, vimrc) using `delete_line`.

### `uninstall_plugins`
Removes fzf, Oh‑My‑Zsh, and Tmux plugin directories.

### `git_configulation`
Sets a global Git alias `graph` for pretty graph logs.

### `download_plugin_repositories`
Clones fzf, Oh‑My‑Zsh, and Tmux TPM if missing, then clones several Zsh plugins in parallel.

### `append_line`, `delete_line`, `insert_line`
Utility helpers to modify files safely (add, remove, or insert a line if not already present). They handle GNU/BSD `sed` differences.

### `deploy_ohmyzsh_files`
Creates a symlink for a custom Zsh theme and ensures required lines are present in `.zshrc`/`.zshenv`.

### `deploy_selfmade_rcfiles`
Creates symlinks for user‑defined config files, removes any existing symlinks, and appends appropriate `source` lines to Vim/Neovim/Tmux config files (handles Cygwin path conversion).

### `deploy_fzf`
Runs the fzf installer with completion and key‑bindings, without updating rc files.

### `backup`
Iterates over `SYMLINKS` and backs up existing files using `backup_file`.

### `compile_zshfiles`
Runs a Zsh compilation helper script if the current shell is Zsh or Zsh is available.

### `clone_dotfiles_repository`
Clones the dotfiles repo from GitHub if not already present.

### `install_essential_dependencies`
Detects missing essential binaries (`git`, `vim`, `tmux`, `zsh`, `gawk` on Ubuntu) and installs them via the appropriate package manager (`apt`, `dnf`, `yum`, `brew`).

### `install_vim_plugins`
Runs Vim/Neovim plugin installation (`PlugInstall`, `Lazy update`) in headless mode, with a test flag `g:is_test`.

### `install_tmux_plugins`
Starts a temporary Tmux session to source `~/.tmux.conf` and run TPM's `install_plugins` script.

### `update_vim_plugins` / `update_tmux_plugins`
Similar to install functions but invoke update commands (`PlugUpgrade`, `PlugUpdate`).

### `install_deps`
General purpose dependency installer that supports Ubuntu (various releases), Debian, Fedora, RHEL, and macOS. Handles optional `curl`‑based installers.

### `build_*_install_deps`
Determine missing build‑time packages for Vim, Neovim, and Tmux based on OS and install them.

### `make_install`
Generic helper to:
1. Ensure `$MYDOTFILES/build` exists.
2. Symlink the appropriate configure script.
3. Clone the target repository if absent.
4. Execute the configure script.

### `build_vim_make_install`, `build_tmux_make_install`, `build_tig_make_install`, `build_neovim_make_install`
Wrap `make_install` for each respective tool.

### `build_vim`, `build_neovim`, `build_tmux`
Run dependency installation followed by the corresponding `make_install`.

### `uninstall_built_tools`
Removes the built tool scripts and directories from `$MYDOTFILES/build` and `$HOME/build`.

### `buildtools`
Convenient entry point to build Vim, Tmux, Tig, and Neovim.

### `create_localrc_dir`
Creates `$HOME/localrcs` and ensures placeholder files exist.

### `create_trash_dir`
Creates `$HOME/.trash` if missing.

### `deploy`
Runs the full deployment pipeline:
- Deploy Oh‑My‑Zsh files.
- Deploy self‑made rc files.
- Install fzf.
- Compile Zsh files.
- Install Vim plugins.
- Configure Git.
- Create localrc and trash directories.
- Write version file.

### `undeploy`
Calls `remove_rcfiles` to clean up deployed symlinks and inserted lines.

### `redeploy`
Runs `undeploy` then `deploy`.

### `update`
If not already updating, pulls latest dotfiles repo, then runs:
- `update_repositories`
- `deploy`
- `update_vim_plugins`
(Optionally updates Tmux plugins – currently commented out.)

### `install`
Runs `install_essential_dependencies`, `download_plugin_repositories`, and `deploy`.

### `uninstall`
Runs `uninstall_plugins`, `uninstall_built_tools`, and `undeploy`.

### `reinstall`
Convenient wrapper that calls `uninstall` then `install`.

### `runtest`
Performs a series of diagnostic `ls` commands, sets up `deno` and Neovim paths, and runs a head‑less Neovim test suite via Plenary. Returns the test exit code.

### `check_arguments`
Dispatches the first CLI argument to the appropriate function, handling `--help` and unknown arguments.

## Command‑Line Interface
The script accepts a **single positional argument** (default `install`):
```
install          # Install dependencies, clone repos, and deploy configs
reinstall        # Uninstall then install
redeploy         # Undeploy then deploy (preserves backups)
update           # Pull latest dotfiles and update plugins
undeploy         # Remove deployed rc files and symlinks
uninstall        # Remove plugins, built tools, and deployed files
debug            # Reserved (no operation)
buildtools       # Build Vim, Tmux, Tig, and Neovim from source
runtest          # Execute test suite
--help           # Show usage information
```
Any other argument prints an error and shows the help message.

## Idempotency & Safety
- **Backups**: Existing files are backed up before being overwritten (`.bak0`‑`.bak3`).
- **Conditional cloning**: Repositories are cloned only if the target directory does not exist.
- **Append/Insert guards**: `append_line`/`insert_line` only modify files when the line does not already exist.
- **Parallel operations**: Plugin clones and some updates run in background (`&`) followed by `wait`.
- **Root detection**: Uses `sudo` when not run as root for package installation.

## Expected Directory Layout
```
$HOME/.dotfiles/        # Repository root (MYDOTFILES)
├─ install-invoke.sh   # This script
├─ tools/              # Helper scripts (zsh_compile.zsh, myconfigure_setup.sh, etc.)
├─ zsh/                # Zsh theme and rc files
├─ vim/                # Vim/Neovim init files
├─ tmux/               # tmux config files
├─ alacritty/          # alacritty config
├─ wezterm/            # wezterm config
└─ ...                 # Other config directories
```
Symlinks are created from the files listed in `SYMLINKS` to the corresponding source files in `SYMTARGET`.

## Logging & Output
All major steps emit descriptive messages prefixed with the function name (e.g., `Installing dependencies for: essential softwares`). Sections are highlighted in green via `echo_section`. Errors from missing commands cause the script to exit due to `set -e` (except where explicitly disabled).

---
*Generated based on the source code of `install-invoke.sh`.*