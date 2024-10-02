# How to use this repo
This is a dotfiles repo streamlined primarily for Arch and Ubuntu. Should work for Debian as well. 

It also includes some system setup that is usually not in dotfiles repos. 

- arch\_prechroot.sh is a guiding file for arch installations
- arch\_chrooted.sh is meant for the chrooted environemnt you use during arch installation
- ubuntu\_postinstall.sh should be run when you have a freshly installed system,  this will probably be removed later and moved to huifu
- huifu.bash is the script that actually setups the whole dotfiles repo, it sources functions.bash to get some 

# Wishlist and Personal Notes
Minimal huifu for servers - exclude Anki, X, etc

Not updating font cache on every huifu run, potentially version-check font directory using git?

Convienent WM/ DE switching 

Other terminal emulator with simpler/ more transparent config file than konsole. Need scrollbar and find function, might also just use any+tmux?

Move vim config to nvim

Theme and darmode switching, mayeb red shift as well. Should this be constrained to WM?

Nix for software which has greatly varying versions in different distros repos or has no package at all in the repo. This includes lazygit and Anki. Maybe move most, if not all, of software installations to nix-based huifu using home-manager?

Syncthing or similar syncing agent for phone and other stuff like \_private.

Smart monitor detection and configuration using xrandr, maybe arandr and nitrogen or feh. Goes to i3 config?

Fix special keys on some keyboards (e.g. volume wheel).

Fancy screensaver.

i3 gaps for home computer. 

Fix freezing nm-applet. May has to do with spotify lag and notification system, so setting up dunst or similar might fix it.

Fix pipewire i3 bar plugin not working properly at home PC

Show only wallpaper behind terminals, not other windows.

Move environment variables, aliases and functions in a dedicated file and source that from zhsrc and bashrc, keep only strictly bash/zsh specific stuff in rc/profile. 

Do not output "Stowing X" if already stowed
