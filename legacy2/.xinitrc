#!/bin/sh



if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

setxkbmap eu
#xmodmap $HOME/.Xmodmap
#xcape -e "Alt_L=Escape" &
#xcape -e "Super_L=Alt_L|F1" &
xrandr --output DisplayPort-0 --off --output DisplayPort-1 --off --output DisplayPort-2 --primary --mode 2560x1440 --pos 0x370 --rotate normal --output HDMI-A-0 --mode 2560x1440 --pos 2560x0 --rotate left &
nitrogen --restore &
exec awesome
