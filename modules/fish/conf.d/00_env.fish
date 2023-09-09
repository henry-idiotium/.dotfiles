set -gx LOG_DEBUG false

# Fish Fast Node Manager
fish_add_path -g $HOME/.fnm
eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"

