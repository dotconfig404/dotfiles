#!/usr/bin/env bash
source jichu.sh

custom_install_command() {
	curl -sS https://starship.rs/install.sh | sh
}
custom_install_check() {
	command -v starship &> /dev/null
}

packages[ubuntu]="curl wget less unzip zip python3 python3-venv silversearcher-ag cowsay"
packages[arch]="curl wget less unzip zip python the_silver_searcher cowsay"
config_dirs="zsh"
install

#packages[ubuntu]="starship"
#packages[arch]="starship"
custom_install_command() {
	curl -sS https://starship.rs/install.sh | sh
}
custom_install_check() {
	command -v starship &> /dev/null
}
config_dirs="starship"
install

config_dirs="testing"
install

name=i3
packages[arch]="xorg-server i3-wm i3lock jgmenu nitrogen xcape i3blocks network-manager-applet dmenu xorg-xinit autorandr ttf-font-awesome arandr tk python xorg-xrandr picom blueman"
# not sure about network manager apple
packages[ubuntu]="i3 i3lock jgmenu nitrogen xcape i3blocks network-manager-gnome suckless-tools xinit autorandr fonts-font-awesome arandr python3-tk python3 x11-xserver-utils picom blueman" 
install

name=fish
packages[arch]="fish"
packages[ubuntu]="fish"
install
