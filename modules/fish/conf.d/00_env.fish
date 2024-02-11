set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx EDITOR nvim

# Local
fish_add_path -g ~/.local/bin

# Cargo
fish_add_path -g ~/.cargo/bin

# PNPM
fish_add_path -g ~/.local/share/pnpm

# Bun
fish_add_path -g ~/.bun/bin

# Fast Node Manager
fish_add_path -g ~/.local/share/fnm
fnm env \
    --use-on-cd \
    --shell=fish \
    --version-file-strategy=recursive \
    | source

# bat
if type -q bat
    set -gx BAT_CONFIG_PATH "$XDG_CONFIG_HOME/bat/bat.conf" # custom `bat` config path
end
