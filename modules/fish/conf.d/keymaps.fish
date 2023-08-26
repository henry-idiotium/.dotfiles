#: Alt escapse
bind -s -M insert jj 'if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char repaint-mode; end'

#: Move cursor to eol/bol
bind -s L end-of-line
bind -s H beginning-of-line
bind -s -M visual L end-of-line
bind -s -M visual H beginning-of-line

