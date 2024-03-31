[ -n "$TMUX" ]; and exit 69

set -l tmux_session_names \
    ノラ \
    そら \
    アイドリング \
    ヘンリー \
    ロキ \
    ロプトル \
    ピカピカ \
    キラキラ \
    モテる \
    カワイイ \
    ゲンキ \
    ワクワク \
    ニコニコ \
    ハッピー \
    サクサク \
    ドキドキ

bind -M insert \e\; __tmux_starter
function __tmux_starter -d 'Custom Tmux session starter.'
    set -f name (random choice $tmux_session_names)

    # redo if session name exists
    while tmux has-session -t $name 2>/dev/null
        set name (random choice $tmux_session_names)
    end

    tmux new-session -s "$name"
end
