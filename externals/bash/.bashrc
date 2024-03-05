#TODO: consider to get self dir more dynamic
readonly CONF_DIR=${XDG_CONFIG_HOME:="$HOME/.config"}
readonly SELF_DIR="$CONF_DIR/dotfiles/externals/bash"
import() { source "$SELF_DIR/$1"; }

import init.sh   # stuffs to run first
import config.sh # config stuffs?
import env.sh    # env vars
import color-prompt.sh

# ## Init fish
# if [ -t 1 ] && command -v fish &> /dev/null; then exec fish; fi

#NOTE: for .bash_logout
# when leaving the console clear the screen to increase privacy
if [ "$SHLVL" = 1 ] && [ -x /usr/bin/clear_console ]; then /usr/bin/clear_console -q; fi
