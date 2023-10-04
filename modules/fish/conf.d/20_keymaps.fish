## Unbind keys
bind \cd true
bind -M insert \cd true
bind -M visual \cd true

## Alt escapse
bind -M insert jj "
	if commandline -P
		commandline -f cancel
	else
		set fish_bind_mode default
		commandline -f backward-char repaint-mode
	end
"

## Move cursor to eol/bol
bind L end-of-line
bind H beginning-of-line
bind -M visual L end-of-line
bind -M visual H beginning-of-line

## Close session
bind -M default \cq exit

## FZF
bind -M insert \ce fzf-open-vim-widget
bind -M insert \cf fzf-file-widget
bind -M insert \ch fzf-history-widget
bind -M insert \cd fzf-cd-widget
bind -M insert \cg fzf-git-status-widget
