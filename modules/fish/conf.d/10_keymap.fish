# unbind keys
bind \cd true
bind -M insert \cd true
bind -M visual \cd true

# alt escapse
bind -M insert jj "
	if commandline -P
		commandline -f cancel
	else
		set fish_bind_mode default
		commandline -f backward-char repaint-mode
	end
"

# Move cursor to eol/sol
bind L end-of-line
bind H beginning-of-line
bind -M visual L end-of-line
bind -M visual H beginning-of-line
bind -M default \cq exit # close session
