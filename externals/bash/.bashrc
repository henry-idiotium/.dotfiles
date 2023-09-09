#NOTE: consider to get self dir more dynamic
readonly SELF_DIR="$HOME/.config/dotfiles/externals/bash"
import() { source "$SELF_DIR/$1"; }

import init.sh # stuffs to run first
import config.sh # config stuffs?
import env.sh # env vars

# Init fish
if [ -t 1 ] && command -v fish &> /dev/null; then exec fish; fi

import color-prompt.sh

#NOTE: for .bash_logout
## when leaving the console clear the screen to increase privacy
#if [ "$SHLVL" = 1 ] && [ -x /usr/bin/clear_console ]; then /usr/bin/clear_console -q; fi

