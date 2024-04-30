#!/bin/sh
# Set custom keycodes
#
# This file is sourced by Xsession(5), not executed.
# The "|| true" is to ensure that the Xsession script does not terminate on error

USRMODMAP="$HOME/.Xmodmap"

if [ -x /usr/bin/xmodmap ]; then
        if [ -f "$USRMODMAP" ]; then
                /usr/bin/xmodmap "$USRMODMAP" || true
        fi
fi

touch $HOME/test
