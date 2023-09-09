# for setting history length
HISTSIZE=1000
HISTFILESIZE=2000
HISTCONTROL=ignoreboth # don't put duplicate lines or lines starting with space in the history.

shopt -s histappend # append to the history file, don't overwrite it
shopt -s checkwinsize # check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s globstar # If set, the pattern "**" used in a pathname expansion context will match all files and zero or more directories and subdirectories.

