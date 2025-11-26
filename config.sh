# -------------------------------------------------
# Centralised configuration for the dotfiles installer.
# -------------------------------------------------

# Core version information
export DOTFILES_VERSION="0.1.0"

# Resolve script directory (absolute path)
SCRIPT_DIR="$(cd "$(dirname "$0")" >/dev/null 2>&1 && pwd -P)"

# Base repository location
export MYDOTFILES="${SCRIPT_DIR}"
export MYDOTFILES_LITERAL='${SCRIPT_DIR}'

# Platform‑specific vim runtime
if type cygpath > /dev/null 2>&1; then
    export MYVIMRUNTIME=$HOME/vimfiles
else
    export MYVIMRUNTIME=$HOME/.vim
fi
export VADER_OUTPUT_FILE=./test_result.log

# Directories
FZFDIR="$HOME/.fzf"
OHMYZSHDIR="$HOME/.oh-my-zsh"
TMUXPLUGINSDIR="$HOME/.tmux/plugins"
TMUXTPMDIR="$TMUXPLUGINSDIR/tpm"

# Symlink targets
ZSHRC="$HOME/.zshrc"
VIMRC="$HOME/.vimrc"
GVIMRC="$HOME/.gvimrc"
TMUXCONF="$HOME/.tmux.conf"
FLAKE8="$HOME/.config/flake8"
VINTRC="$HOME/.vintrc.yml"
EMACSINIT="$HOME/.spacemacs"
TIGRC="$HOME/.tigrc"
if [[ $OSTYPE == 'msys' ]]; then
    NVIMRC="$USERPROFILE/AppData/Local/nvim/init.lua"
    GNVIMRC="$USERPROFILE/AppData/Local/nvim/ginit.vim"
else
    NVIMRC="$HOME/.config/nvim/init.lua"
    GNVIMRC="$HOME/.config/nvim/ginit.vim"
fi
ALACRITTYRC=$HOME/.config/alacritty/alacritty.toml
WEZTERMRC=$HOME/.wezterm.lua
MCPHUB_SERVERS="$HOME/.config/mcphub/servers.json"

# Arrays mapping source → target for symlinks
SYMLINKS=(
    "${FLAKE8}"
    "${VINTRC}"
    "${EMACSINIT}"
    "${NVIMRC}"
    "${GNVIMRC}"
    "${TIGRC}"
    "${ALACRITTYRC}"
    "${WEZTERMRC}"
    "${MCPHUB_SERVERS}"
)

SYMTARGET=(
    "${MYDOTFILES}/python/lint/flake8"
    "${MYDOTFILES}/python/lint/vintrc.yml"
    "${MYDOTFILES}/emacs/spacemacs"
    "${MYDOTFILES}/vim/init.lua"
    "${MYDOTFILES}/vim/ginit.vim"
    "${MYDOTFILES}/tig/tigrc"
    "${MYDOTFILES}/alacritty/alacritty.toml"
    "${MYDOTFILES}/wezterm/.wezterm.lua"
    "${MYDOTFILES}/mcphub/servers.json"
)

# Local RC handling
LOCALRCSDIR="$HOME/localrcs"
LOCALRCS=(
    "$LOCALRCSDIR/tmux-local"
    "$LOCALRCSDIR/vim-local.vim"
    "$LOCALRCSDIR/zsh-local.zsh"
)
TRASH="$HOME/.trash"

# Prefer GNU sed on macOS if installed
if type gsed > /dev/null 2>&1; then
    alias sed="gsed"
fi
