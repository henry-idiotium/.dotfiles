if not functions -q fundle
    eval (curl -sfL https://git.io/fundle-install)
    return
end

fundle plugin IlanCosman/tide@v6
fundle plugin ankitsumitg/docker-fish-completions

fundle init
