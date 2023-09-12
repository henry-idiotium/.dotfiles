# tabtab source for packages; uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish

# Disable greeting message
set -U fish_greeting

function fish_mode_prompt; end

set fish_vi_force_cursor     true
set fish_cursor_default      block
set fish_cursor_insert       line
set fish_cursor_replace_one  underscore
set fish_cursor_visual       block

# Set vi mode as default key binding
fish_vi_key_bindings

type -q nitch && nitch
