#!/usr/bin/env bash
# vim:ft=sh

## helpers
set() { tmux set-option -gq "$1" "$2"; }
setw() { tmux set-window-option -gq "$1" "$2"; }

## data/info display ---                    
d_left=' マフル'            #'  ノラ'
d_right='%a %d %b %H:%M' #  マフル
d_sep_right_fill=''
d_sep_left_fill=''
d_sep_right=''
d_sep_left=''

## palette
t_bg="default"
t_fg="#cdd6f4"
t_fg1="##7f849c"
t_violet="#945eff"
t_teal="#31ebb8"
t_null="#0c0c0c"
t_black="#26272e"
t_gray="#343540"
t_gray1="#494952"
t_gray2="#51585e"

# look up `Internal Field Separator`
IFS_OLD="$IFS"
IFS=''

## modes (also includes selection style)
setw mode-style "fg=$t_teal bg=$t_gray"

## messages
set message-style "fg=$t_teal bg=$t_bg align=centre"
set message-command-style "fg=$t_teal bg=$t_bg align=centre"

## clock
setw clock-mode-colour "$t_teal"

## status
set status "on"
set status-style "bg=${t_bg} fg=${t_fg}"
set status-justify "left"
set status-left-length "100"
set status-right-length "100"
set status-left-style ""
set status-right-style ""

status_left=(
	"#[bg=$t_black bold]#{?client_prefix,"
	"#[fg=$t_violet]$d_left,#[fg=$t_teal]$d_left}"
	"#[fg=$t_black bg=$t_gray none]$d_sep_right_fill"
	"#[fg=$t_gray bg=$t_gray1]$d_sep_right_fill"
	"#[fg=$t_gray1 bg=$t_bg]$d_sep_right_fill"
)
set status-left "${status_left[*]}"

status_right=(
	"#[fg=$t_fg1 italics] #S "
	"#[none]"
	"#[fg=$t_gray1 bg=$t_bg]$d_sep_left_fill"
	"#[fg=$t_gray bg=$t_gray1]$d_sep_left_fill"
	"#[fg=$t_black bg=$t_gray]$d_sep_left_fill"
	"#[fg=$t_teal bg=$t_black bold] $d_right " # %a %b %H:%M
)
set status-right "${status_right[*]}"

## windows
setw window-status-activity-style "fg=${t_fg} bg=${t_bg} none"
setw window-status-separator ""
setw window-status-style "fg=${t_fg} bg=${t_bg} none"

setw window-status-activity-style "underscore fg=$t_gray1 bg=$t_bg"
setw window-status-separator ""
setw window-status-style "NONE fg=$t_gray1 bg=$t_bg"

# IDLE state
setw window-status-format " #[default fg=$t_fg1] #I $d_sep_right #{b:pane_current_path}  "

# ACTIVE state
window_status_current_format=(
	"#[bg=$t_gray1 fg=#000000]$d_sep_right_fill"
	# "#[fg=$t_gray1 bg=$t_bg]"
	"#[bg=$t_gray1 fg=$t_teal bold] #I "
	"#[fg=$t_gray1 bg=$t_black]$d_sep_right_fill "
	"#[fg=$t_teal noitalics nobold]#{b:pane_current_path} "
	"#[fg=$t_black bg=$t_bg nobold]$d_sep_right_fill"
)
setw window-status-current-format "${window_status_current_format[*]}"

IFS="$IFS_OLD"
