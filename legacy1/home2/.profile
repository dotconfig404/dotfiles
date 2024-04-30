#
# .profile
#
# Suitable for any bourne compatible shell
#

export EDITOR=${VISUAL:=vim}
export PAGER=less
export XDG_CONFIG_HOME=$HOME/.config


# initialize bash if we're running bash
if [ -n "$BASH" ]; then
  [ -r "$HOME/.bashrc" ] && . ~/.bashrc
fi


# allow host-specific overrides to override anything
[ -r "$HOME/.profile.$HOSTNAME" ] && . ~/.profile."$HOSTNAME"

: ignore errors
