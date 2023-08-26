function _tide_item_custom_git
    function _get_str
        test -z "$argv[1]" \
            && echo (test -n $argv[3] && echo $argv[3] || echo '') \
            || echo $argv[2]
    end
    function _get_icon
        echo (_get_str $argv[1] $argv[1] $argv[2])
    end


    set _tide_location_color (set_color (
        _get_str $tide_custom_git_color_branch \
            $tide_custom_git_color_branch \
            FFFFFF
    ))

    # Location
    if git branch --show-current 2>/dev/null | string replace -r ".+(.{$tide_custom_git_truncation_length})" '…$1' | read -l location
        git rev-parse --git-dir --is-inside-git-dir | read -fL gdir in_gdir
        set location $_tide_location_color$location
    else if test $pipestatus[1] != 0
        return
    else if git tag --points-at HEAD | string replace -r ".+(.{$tide_custom_git_truncation_length})" '…$1' | read location
        git rev-parse --git-dir --is-inside-git-dir | read -fL gdir in_gdir
        set location '#'$_tide_location_color$location
    else
        git rev-parse --git-dir --is-inside-git-dir --short HEAD | read -fL gdir in_gdir location
        set location @$_tide_location_color$location
    end

    # Operation
    set operation (
        if test -d $gdir/rebase-merge
            read -f step <$gdir/rebase-merge/msgnum
            read -f total_steps <$gdir/rebase-merge/end

            test -f $gdir/rebase-merge/interactive \
                && echo rebase-i \
                || echo rebase-m
        else if test -d $gdir/rebase-apply
            read -f step <$gdir/rebase-apply/next
            read -f total_steps <$gdir/rebase-apply/last

            if test -f $gdir/rebase-apply/rebasing
                echo rebase
            else if test -f $gdir/rebase-apply/applying
                echo am
            else
                echo am/rebase
            end
        else if test -f $gdir/MERGE_HEAD
            echo merge
        else if test -f $gdir/CHERRY_PICK_HEAD
            echo cherry-pick
        else if test -f $gdir/REVERT_HEAD
            echo revert
        else if test -f $gdir/BISECT_LOG
            echo bisect
        end
    )

    # Git status/stash + Upstream behind/ahead
    test $in_gdir = true && set -l _set_dir_opt -C $gdir/..
    # Suppress errors in case we are in a bare repo or there is no upstream
    stat=(git $_set_dir_opt status --porcelain 2>/dev/null) \
        string match -qr '(0|(?<stash>.*))\n(0|(?<conflicted>.*))
(0|(?<staged>.*))\n(0|(?<added>.*))\n(0|(?<deleted>.*))\n(0|(?<modified>.*))
(0|(?<renamed>.*))\n(0|(?<untracked>.*))(\n(0|(?<behind>.*))\t(0|(?<ahead>.*)))?' \
        "$(git $_set_dir_opt stash list 2>/dev/null | count # stash
        string match -r ^UU $stat | count # conflicted
        string match -r ^[ADMR]. $stat | count # staged
        string match -r ^.[A] $stat | count # added
        string match -r ^.[D] $stat | count # deleted
        string match -r ^.[M] $stat | count # modified
        string match -r ^.[R] $stat | count # renamed
        string match -r '^\?\?' $stat | count # untracked
        git rev-list --count --left-right @{upstream}...HEAD 2>/dev/null)" # beind & ahead

    set -g tide_custom_git_bg_color (
        _get_str "$operation$conflicted" \
            $tide_custom_git_bg_color_urgent \
            $tide_custom_git_bg_color_unstable
    )

    # status icons
    set _i_behind      (_get_icon $tide_custom_git_status_icon_behind     '⇣')
    set _i_ahead       (_get_icon $tide_custom_git_status_icon_ahead      '⇡')
    set _i_stash       (_get_icon $tide_custom_git_status_icon_stash      '$')
    set _i_conflicted  (_get_icon $tide_custom_git_status_icon_conflicted '=')
    set _i_staged      (_get_icon $tide_custom_git_status_icon_staged     '++')
    set _i_added       (_get_icon $tide_custom_git_status_icon_added      '+')
    set _i_deleted     (_get_icon $tide_custom_git_status_icon_deleted    '✘')
    set _i_modified    (_get_icon $tide_custom_git_status_icon_modified   '!')
    set _i_renamed     (_get_icon $tide_custom_git_status_icon_renamed    '»')
    set _i_untracked   (_get_icon $tide_custom_git_status_icon_untracked  '?')

    set status_str "$stash$conflicted$staged$added$deleted$modified$renamed$untracked"
    set spacing    ' '
    set sep        ' │'

    _tide_print_item custom_git $_tide_location_color$tide_custom_git_icon (
        set_color white; echo -ns ' '$location

        set_color brblack;                            echo -ns (_get_str $status_str $sep)
        set_color $tide_custom_git_color_operation;   echo -ns $spacing$operation $spacing$step/$total_steps
        set_color $tide_custom_git_color_stash;       echo -ns $spacing$_i_stash$stash
        set_color $tide_custom_git_color_conflicted;  echo -ns $spacing$_i_conflicted$conflicted
        set_color $tide_custom_git_color_staged;      echo -ns $spacing$_i_staged$staged
        set_color $tide_custom_git_color_untracked;   echo -ns $spacing$_i_untracked$untracked
        set_color $tide_custom_git_color_added;       echo -ns $spacing$_i_added$added
        set_color $tide_custom_git_color_modified;    echo -ns $spacing$_i_modified$modified
        set_color $tide_custom_git_color_deleted;     echo -ns $spacing$_i_deleted$deleted
        set_color $tide_custom_git_color_renamed;     echo -ns $spacing$_i_renamed$renamed

        set_color brblack;                            echo -ns (_get_str "$behind$ahead" $sep)
        set_color $tide_custom_git_color_upstream;    echo -ns $spacing$_i_behind$behind $spacing$_i_ahead$ahead
    )
end

