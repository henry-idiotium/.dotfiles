## settings
unset HISTSIZE
export LESSHISTFILE='-' # disable Less history file

force_color_prompt=yes
color_prompt=yes

shopt -s histappend   # append to the history file, don't overwrite it
shopt -s checkwinsize # check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s globstar     # If set, the pattern "**" used in a pathname expansion context will match all files and zero or more directories and subdirectories.

## aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# NOTE: for .bash_logout when leaving the console clear the screen to increase privacy
# if [ "$SHLVL" = 1 ] && [ -x /usr/bin/clear_console ]; then /usr/bin/clear_console -q; fi
