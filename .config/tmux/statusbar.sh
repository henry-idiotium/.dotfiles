#!/usr/bin/env bash
# vim:ft=sh

## helpers
set() { tmux set-option -gq "$1" "$2"; }
setw() { tmux set-window-option -gq "$1" "$2"; }

## display                   
d_left=' マフル' # ノラ
d_right='%a %d %b %H:%M'
d_sep_left_fill=
d_sep_right_fill=
d_set_left_tail_fill=
d_sep_left=
d_sep_right=

## color palette
c_bg="default"
c_fg="#cdd6f4"
c_fg1="##7f849c"
c_violet="#945eff"
c_teal="#31ebb8"
c_null="#0c0c0c"
c_black="#26272e"
c_gray="#343540"
c_gray1="#494952"
c_gray2="#51585e"

## look up `Internal Field Separator`
IFS_OLD="$IFS"
IFS=''

## modes (also includes selection style)
setw mode-style "fg=$c_teal bg=$c_gray"

## messages
set message-style "fg=$c_teal bg=$c_bg align=centre"
set message-command-style "fg=$c_teal bg=$c_bg align=centre"

## clock
setw clock-mode-colour "$c_teal"

## status
set status "on"
set status-style "bg=$c_bg fg=$c_fg"
set status-justify "left"
set status-left-length "100"
set status-right-length "100"
set status-left-style ""
set status-right-style ""

status_left=(
	"#[bg=$c_black bold]#{?client_prefix,"
	"#[fg=$c_violet]$d_left" ","
	"#[fg=$c_teal]$d_left}"
	"#[fg=$c_black bg=$c_gray none]$d_sep_left_fill"
	"#[fg=$c_gray bg=$c_gray1]$d_sep_left_fill"
	"#[fg=$c_gray1 bg=$c_bg]$d_sep_left_fill"
)
set status-left "${status_left[*]}"

status_right=(
	"#[fg=$c_fg1 italics] $d_right "
	"#[none]"
	"#[fg=$c_gray1 bg=$c_bg]$d_sep_right_fill"
	"#[fg=$c_gray bg=$c_gray1]$d_sep_right_fill"
	"#[fg=$c_black bg=$c_gray]$d_sep_right_fill"
	"#[fg=$c_teal bg=$c_black bold] #S " # %a %b %H:%M
)
set status-right "${status_right[*]}"

## windows
setw window-status-activity-style "fg=$c_fg bg=$c_bg none"
setw window-status-separator ""
setw window-status-style "fg=$c_fg bg=$c_bg none"

setw window-status-activity-style "underscore fg=$c_gray1 bg=$c_bg"
setw window-status-separator ""
setw window-status-style "NONE fg=$c_gray1 bg=$c_bg"

# IDLE state
setw window-status-format " #[default fg=$c_fg1] #I $d_sep_left #{b:pane_current_path}  "

# ACTIVE state
window_status_current_format=(
	"#[fg=$c_gray1]$d_set_left_tail_fill"
	"#[bg=$c_gray1 fg=$c_teal bold] #I "
	"#[fg=$c_gray1 bg=$c_black]$d_sep_left_fill "
	"#[fg=$c_teal noitalics nobold]#{b:pane_current_path} "
	"#[fg=$c_black bg=$c_bg nobold]$d_sep_left_fill"
)
setw window-status-current-format "${window_status_current_format[*]}"

IFS="$IFS_OLD"
