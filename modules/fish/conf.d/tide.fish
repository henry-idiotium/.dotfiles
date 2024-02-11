# use `normal` for transparent
set -l prompt_bg normal #1e1e24

## ----------------
## Prompt

set -U tide_prompt_add_newline_before false
set -U tide_prompt_color_frame_and_connection 6C6C6C
set -U tide_prompt_color_separator_same_color 949494
set -U tide_prompt_icon_connection ' '
set -U tide_prompt_min_cols 50
set -U tide_prompt_pad_items true

## prompt left
if test (la ~/.config/fish/functions/ | grep custom)
    set -U tide_left_prompt_items pwd custom_git newline character
else
    set -U tide_left_prompt_items pwd git newline character
end

set -U tide_left_prompt_frame_enabled false
set -U tide_left_prompt_prefix # 
set -U tide_left_prompt_separator_diff_color # 
set -U tide_left_prompt_separator_same_color 
set -U tide_left_prompt_suffix # 

## prompt righ
set -U tide_right_prompt_frame_enabled false
set -U tide_right_prompt_items status cmd_duration time jobs node rustc java php go kubectl toolbox terraform aws nix_shell crystal
# set -U tide_right_prompt_items                 cmd_duration time jobs
set -U tide_right_prompt_prefix #
set -U tide_right_prompt_separator_diff_color #
set -U tide_right_prompt_separator_same_color 
set -U tide_right_prompt_suffix #' '


## ----------------
## Main

## character
set -U tide_character_color green
set -U tide_character_color_failure red
set -U tide_character_icon ❯
set -U tide_character_vi_icon_default ❮
set -U tide_character_vi_icon_replace ▶
set -U tide_character_vi_icon_visual V

## pwd
set -U tide_pwd_bg_color $prompt_bg
set -U tide_pwd_color_anchors brblue
set -U tide_pwd_color_dirs blue
set -U tide_pwd_color_truncated_dirs BCBCBC
set -U tide_pwd_icon
set -U tide_pwd_icon_home
set -U tide_pwd_icon_unwritable 
set -U tide_pwd_markers .bzr .citc .git .hg .node-version .python-version .ruby-version .shorten_folder_marker .svn .terraform Cargo.toml composer.json CVS go.mod package.json
# set -U tide_pwd_markers               .git .shorten_folder_marker package.json

## context (username, hostname, etc.)
set -U tide_context_always_display false
set -U tide_context_bg_color $prompt_bg
set -U tide_context_color_default D7AF87
set -U tide_context_color_root $_tide_color_gold
set -U tide_context_color_ssh D7AF87
set -U tide_context_hostname_parts 1

## os
set -U tide_os_bg_color $prompt_bg
set -U tide_os_color EEEEEE
set -U tide_os_icon $os_branding_icon

## time
set -U tide_time_bg_color $prompt_bg
set -U tide_time_color 5F8787
set -U tide_time_format %T

## cmd_duration
set -U tide_cmd_duration_bg_color $prompt_bg
set -U tide_cmd_duration_color 87875F
set -U tide_cmd_duration_decimals 1
set -U tide_cmd_duration_icon
set -U tide_cmd_duration_threshold 100

## status
set -U tide_status_bg_color $prompt_bg
set -U tide_status_bg_color_failure $prompt_bg
set -U tide_status_color $_tide_color_dark_green
set -U tide_status_color_failure D70000
set -U tide_status_icon ✔
set -U tide_status_icon_failure ✘

## custom_git
if type -q _tide_item_custom_git
    set -U tide_custom_git_bg_color $prompt_bg
    set -U tide_custom_git_bg_color_unstable $prompt_bg
    set -U tide_custom_git_bg_color_urgent $prompt_bg
    set -U tide_custom_git_color_branch brwhite
    set -U tide_custom_git_color_conflicted brred
    set -U tide_custom_git_color_added magenta
    set -U tide_custom_git_color_deleted brred
    set -U tide_custom_git_color_modified yellow
    set -U tide_custom_git_color_renamed cyan
    set -U tide_custom_git_color_operation brmagenta
    set -U tide_custom_git_color_staged green
    set -U tide_custom_git_color_stash white
    set -U tide_custom_git_color_untracked brwhite
    set -U tide_custom_git_color_upstream brmagenta
    set -U tide_custom_git_icon 
    set -U tide_custom_git_truncation_length 24
    set -U tide_custom_git_status_icon_behind
    set -U tide_custom_git_status_icon_ahead
    set -U tide_custom_git_status_icon_stash ' '
    set -U tide_custom_git_status_icon_renamed ' '
    set -U tide_custom_git_status_icon_conflicted 'C'
    set -U tide_custom_git_status_icon_staged ' '
    set -U tide_custom_git_status_icon_added 'A'
    set -U tide_custom_git_status_icon_deleted 'D'
    set -U tide_custom_git_status_icon_modified 'M'
    set -U tide_custom_git_status_icon_untracked 'U'
end

## vi_mode
set -U tide_vi_mode_bg_color_default $prompt_bg
set -U tide_vi_mode_bg_color_insert $prompt_bg
set -U tide_vi_mode_bg_color_replace $prompt_bg
set -U tide_vi_mode_bg_color_visual $prompt_bg
set -U tide_vi_mode_color_default $prompt_bg
set -U tide_vi_mode_color_insert 87AFAF
set -U tide_vi_mode_color_replace 87AF87
set -U tide_vi_mode_color_visual FF8700
set -U tide_vi_mode_icon_default D
set -U tide_vi_mode_icon_insert I
set -U tide_vi_mode_icon_replace R
set -U tide_vi_mode_icon_visual V

## private mode
set -U tide_private_mode_bg_color $prompt_bg
set -U tide_private_mode_color FFFFFF
set -U tide_private_mode_icon 󰗹


## ----------------
## Environments
## ----

## docker
set -U tide_docker_bg_color $prompt_bg
set -U tide_docker_color 2496ED
set -U tide_docker_default_contexts default colima
set -U tide_docker_icon 

## go
set -U tide_go_bg_color $prompt_bg
set -U tide_go_color 00ACD7
set -U tide_go_icon 

## java
set -U tide_java_bg_color $prompt_bg
set -U tide_java_color ED8B00
set -U tide_java_icon 

## jobs
set -U tide_jobs_bg_color $prompt_bg
set -U tide_jobs_color $_tide_color_dark_green
set -U tide_jobs_icon 

## node
set -U tide_node_bg_color $prompt_bg
set -U tide_node_color 44883E
set -U tide_node_icon 󰎙
