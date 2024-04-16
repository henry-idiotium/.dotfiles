type -q tmux && [ -n "$TMUX" ]; and exit 69

set -l session_names \
    何もない \
    ひきこもり \
    アイドリング \
    ヘンリク \
    ピプトル \
    ピカピカ \
    キラサク \
    モテる \
    カワイイ \
    ゲンキキ \
    イクドキ \
    ハッピー \
    ノラ

bind -M insert \e\; tmux_starter
function tmux_starter --inherit-variable session_names
    set -f name (random choice $session_names)
    while tmux has-session -t $name 2>/dev/null
        set name (random choice $session_names)
    end

    tmux new-session -s $name 2>/dev/null
    and commandline -f repaint
end
