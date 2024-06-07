not functions -q tide; and return

# prompt config
set -U tide_prompt_add_newline_before false
set -U tide_prompt_color_frame_and_connection 6C6C6C
set -U tide_prompt_color_separator_same_color 949494
set -U tide_prompt_min_cols 50
set -U tide_prompt_pad_items false

# prompt left
set -U tide_left_prompt_items pwd git character

# character
set -U tide_character_color green
set -U tide_character_color_failure red
set -U tide_character_icon ➜
set -U tide_character_vi_icon_default $tide_character_icon
set -U tide_character_vi_icon_replace R
set -U tide_character_vi_icon_visual V

# context
set -U tide_context_always_display false
set -U tide_context_hostname_parts 1

# cmd_duration
set -U tide_cmd_duration_color 87875F
set -U tide_cmd_duration_decimals 1
set -U tide_cmd_duration_threshold 100

# git
set -U tide_git_color_branch brwhite
set -U tide_git_color_conflicted brred
set -U tide_git_color_added magenta
set -U tide_git_color_deleted brred
set -U tide_git_color_modified yellow
set -U tide_git_color_renamed cyan
set -U tide_git_color_operation brmagenta
set -U tide_git_color_staged green
set -U tide_git_color_stash white
set -U tide_git_color_untracked brwhite
set -U tide_git_color_upstream brmagenta
