function fzf-git-status-widget --description "Git browse status"
    set -f preview_cmd '__fzf_preview_changed_file {} | delta --syntax-theme Catppuccin-mocha --paging=never --width=20'

    set -lx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS
		--prompt 'Git Status > '
		--marker * --no-sort --tiebreak index --no-multi --ansi
		--preview \"$preview_cmd\"
	"
    git -c color.status=always status --short | eval (__fzf_cmd)
end
