set -U fish_greeting
set -U fish_vi_force_cursor     true
set -U fish_cursor_default      block
set -U fish_cursor_insert       line
set -U fish_cursor_replace_one  underscore
set -U fish_cursor_visual       block

function fish_mode_prompt; end
fish_vi_key_bindings # use vi mode key binding

# type -q nitch && nitch
if type -q zoxide
	zoxide init fish --cmd j | source
end

