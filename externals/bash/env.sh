export EDITOR='nvim'
export XDG_CONFIG_HOME="$HOME/.config" # config dir
export BAT_CONFIG_PATH="$XDG_CONFIG_HOME/bat/bat.conf" # custom `bat` config path

export LESSHISTFILE='-' # disable Less history file

# set PATH so it includes user's private bin if it exists
BIN_DIR="$HOME/bin"              && [ -d "$BIN_DIR" ]       && PATH="$BIN_DIR:$PATH"
LOCAL_BIN_DIR="$HOME/.local/bin" && [ -d "$LOCAL_BIN_DIR" ] && PATH="$LOCAL_BIN_DIR:$PATH"

# PNPM
PNPM_HOME="$HOME/.local/share/pnpm"
if [ -d "$PNPM_HOME" ]; then
	export PNPM_HOME
	PATH="$PNPM_HOME:$PATH"
fi

# Cargo/Rust
CARGO_HOME="$HOME/.cargo"
[ -d "$CARGO_HOME" ] && source "$CARGO_HOME/env"

# bun
BUN_INSTALL="$HOME/.bun"
if [ -d "$BUN_INSTALL" ]; then
	export BUN_INSTALL
	PATH="$BUN_INSTALL/bin:$PATH"
fi

