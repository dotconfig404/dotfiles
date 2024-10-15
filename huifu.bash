#!/bin/bash
# #############################################################################
# -----------------------------------------------------------------------------
# #############################################################################
# some checks and basic utilities

# get those pretty print functions and the like
source ./functions.bash

# not entirely sure, but i think we need to check for if bash is at least 4.3
# associative arrays (which we use are available form 4.0 and nameref is 
# available from 4.3
if [ "${BASH_VERSINFO[0]}" -lt 4 ] || [ "${BASH_VERSINFO[0]}" -eq 4 -a "${BASH_VERSINFO[1]}" -lt 3 ]; then
    echo_in red "This script requires Bash version 4.3 or greater. " >&2
    exit 1
fi

# Source os-release for using ID and check if distro is supported
# currently arch, debian and ubuntu, but might add fedora eventually
source /etc/os-release
if [ $ID != "arch" ] && [ $ID != "debian" ] && [ $ID != "ubuntu" ]; then
    error "Unsupported distro. "
fi

# _private directory exists?
if [ ! -d "_private" ]; then
    error "Set up _private first. "
fi
#

# .local may not exist, we will need it (lest it gets symlinked)
if [ ! -d ~/.local ];then
   mkdir ~/.local
fi 

# #############################################################################
# -----------------------------------------------------------------------------
# #############################################################################
# generic software installation 

# Declare packages array
# contains package list depending on software name and distro ID
declare -A packages

##############
# stow
##############
software=stow
packages[$software,arch]="stow"
packages[$software,debian]="stow"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]}

##############
# starship and curl
##############
software=curl
packages[$software,arch]="curl"
packages[$software,debian]="curl"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]}
if ! command -v starship &> /dev/null; then
    curl -sS https://starship.rs/install.sh | sh
fi
dot starship

##############
# bash (needs starship)
##############
dot bash

##############
# zsh (needs starship)
##############
software=zsh
packages[$software,arch]="zsh"
packages[$software,debian]="zsh"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]}
dot $software

##############
# konsole
##############
software=konsole
packages[$software,arch]="konsole kconfig"
packages[$software,debian]="konsole libkf5config-bin"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]}
# need to write ~/.config/konsolerc using kwriteconfig5, not suitable for version controlling
# as it changes contents frequently (although not so bad if we wanna do it anyways)
kconfigcmd=kwriteconfig6
if ! command -v kwriteconfig6 &> /dev/null;then
    kconfigcmd=kwriteconfig5
fi
$kconfigcmd --file konsolerc --group "Desktop Entry" --key "DefaultProfile" "dotconfig.profile"
$kconfigcmd --file konsolerc --group "MainWindow" --group "Toolbar sessionToolbar" --key "IconSize" "16"
$kconfigcmd --file konsolerc --group "Toolbar sessionToolbar" --key "IconSize" "16"
$kconfigcmd --file konsolerc --group "UiSettings" --key "ColorScheme" "Breeze Dark"
$kconfigcmd --file konsolerc --group "UiSettings" --key "WindowColorScheme" "Breeze Dark"
$kconfigcmd --file konsolerc --group "TabBar" --key "CloseTabButton" "None"
$kconfigcmd --file konsolerc --group "TabBar" --key "TabBarVisibility" "AlwaysHideTabBar"
# we do not want to symlink the whole konsole dir
if [ ! -d ~/.local/share/konsole ];then
   mkdir -p ~/.local/share/konsole 
fi 
dot $software

###############
## awesomewm (needs lots of testing)
###############
#software=awesome
#packages[$software,arch]="awesome"
#packages[$software,debian]="awesome"
#packages[$software,ubuntu]=${packages[$software,debian]}
#install ${packages[$software,$ID]}
#dot $software
#
###############
## openbox (needs lots of testing)
###############
#software=openbox
#packages[$software,arch]="openbox"
#packages[$software,debian]="openbox"
#packages[$software,ubuntu]=${packages[$software,debian]}
#install ${packages[$software,$ID]}
#dot $software

##############
# gtk
##############
dot gtk

##############
# python dev
##############
software=python
packages[$software,arch]="python"
packages[$software,debian]="python3 python3-venv"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]}

##############
# silversearcher
##############
software=silversearcher-ag
packages[$software,arch]="the_silver_searcher"
packages[$software,debian]="silversearcher-ag"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]}

##############
# mise, node
##############
if ! command -v mise &> /dev/null; then
    curl https://mise.run | sh
    echo 'export PATH="$HOME/.local/share/mise/shims:$PATH"' > ~/.zprofile.d/mise.zsh
    echo 'export PATH="$HOME/.local/share/mise/shims:$PATH"' > ~/.bash_profile.d/mise.sh
    source ~/.bashrc.d/mise.sh
    mise use --global node
fi

##############
# vim
##############
software=vim
packages[$software,arch]="vim"
packages[$software,debian]="vim"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]} #--debian_ppas=ppa:jonathonf/vim --ubuntu_ppas=ppa:jonathonf/vim
dot $software
vim -c 'PlugInstall' -c 'qa!'
vim -c 'CocInstall coc-pyright' -c 'qa!'
echo_in red "check if cocinstall really worked"

##############
# tmux
##############
software=tmux
packages[$software,arch]="tmux"
packages[$software,debian]="tmux"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]}
dot $software

##############
# i3
##############
software=i3
# python3-tk, xrandr, arandr, python3 for monitor manager script (i3blocks), fontsawesome as well and needed by other scripts
# transparency using picom (fork of compton)
packages[$software,arch]="i3-wm i3lock jgmenu nitrogen xcape i3blocks network-manager-applet dmenu xorg-xinit autorandr ttf-font-awesome arandr tk python xorg-xrandr picom blueman"
# not sure about network manager applet
packages[$software,debian]="i3 i3lock jgmenu nitrogen xcape i3blocks network-manager-applet suckless-tools xinit autorandr fonts-font-awesome arandr python3-tk python3 x11-xserver-utils picom blueman"
packages[$software,ubuntu]="i3 i3lock jgmenu nitrogen xcape i3blocks network-manager-gnome suckless-tools xinit autorandr fonts-font-awesome arandr python3-tk python3 x11-xserver-utils picom blueman" 
install ${packages[$software,$ID]}
dot $software
dot i3blocks
dot fonts
dot xinit
dot autorandr
dot picom
#echo_in yellow "rebuilding font cache"
#fc-cache -f
#echo_in green "font cache rebuilt"

##############
# emacs (needs testing)
##############
software=emacs
packages[$software,arch]="emacs"
packages[$software,debian]="emacs"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]}
dot $software

##############
# gtk
##############
dot gtk

##############
# neovim
##############
software=neovim
packages[$software,arch]="neovim"
packages[$software,debian]="neovim"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]} #--debian_ppas=ppa:neovim-ppa/unstable --ubuntu_ppas=ppa:neovim-ppa/unstable

##############
# dolphin
##############
# briefly considered making custom config, but this is terrible with kdes configs. 
# konsole was bad enough. at some point i gotta decide what to just leave 
# as it is. it is not worth it trying to dotify all software. 
software=dolphin
packages[$software,arch]="dolphin"
packages[$software,debian]="dolphin"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]} 

##############
# flameshot
##############
software=flameshot
packages[$software,arch]="flameshot"
packages[$software,debian]="flameshot"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]} 

##############
# gthumb
##############
software=gthumb
packages[$software,arch]="gthumb"
packages[$software,debian]="gthumb"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]} 

##############
# nomacs
##############
#software=nomacs
#packages[$software,arch]="nomacs"
#packages[$software,debian]="nomacs"
#packages[$software,ubuntu]=${packages[$software,debian]}
#install ${packages[$software,$ID]}

##############
# numlockx
##############
software=numlockx
packages[$software,arch]="numlockx"
packages[$software,debian]="numlockx"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]} 

##############
# fcitx5
##############
# keyboard setup (under X so far): eurkey and pinyin
# also added environment variables to zprofile
# more or less followed this: https://medium.com/@brightoning/cozy-ubuntu-24-04-install-fcitx5-for-chinese-input-f4278b14cf6f
echo "run_im fcitx5" > ~/.xinputrc
software=fcitx5
# this is prolly wrong
packages[$software,arch]="fcitx5 fcitx5-chinese-addons noto-fonts-cjk"
packages[$software,debian]="fcitx5 fcitx5-chinese-addons fonts-noto-cjk fonts-noto-cjk-extra im-config"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]} 
dot $software

##############
# kde
##############
# for lack of a better place to put this, ill add some random config files of kde here
software=kde
dot $software

##############
# nix
##############
# getting it to work with the standard installer is not easy in enterprise environments, ultimately 
# i moved on to the determinate nix installer as soon as i found it. the issue with the following is
# that there seems to be some kind of timeout for the sudo prompt after creating or even checking if 
# a user/group exists or possibly the error message is related to something suddently complaining 
# "hey, this user needs a password", not sure. latest example error output:
#~~> Setting up the build user nixbld5
#            Exists:     Yes
#            Hidden:     Yes
#    Home Directory:     /var/empty
#              Note:     Nix build user 5
#sudo: PAM account management error: Unknown error -1
#sudo: a password is required
# it worked for the user creation to turn off networking to stop contacting NSS, but the installer 
# fails regardless of whether the group and users already exists 
# edit: no, its a timeout. when running the determinate installer and then also using sudo somewehre else
# i got the same error message, albeit with code -2 instead of -1

#if ! command -v nix-env > /dev/null; then
#    sudo nmcli networking off
#
#    echo_in blue "Adding nixbld group."
#    sudo groupadd -r -g 3000000 nixbld
#
#    for n in $(seq 1 32); do
#        echo_in blue "Adding nixbld$n user."
#        sudo useradd -c "Nix build user $n" \
#        -d /var/empty -g nixbld -G nixbld -M -N -r -s "$(which nologin)" \
#        -u $((3000000 + n)) nixbld$n
#    done
#
#    sudo nmcli networking on
#
#    echo_in blue "Waiting for network to be back online..."
#
#    while ! ping -c 1 8.8.8.8 &> /dev/null; do
#        echo_in blue "Waiting for network to be back online..."
#        sleep 1
#    done
#
#    NIX_FIRST_BUILD_UID=3000001 NIX_BUILD_GROUP_ID=3000000 sh <(curl -L https://nixos.org/nix/install) --daemon --yes
#fi
if ! command -v nix-env > /dev/null; then
    echo_in blue "installing nix"
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
    sh -s -- install --nix-build-group-id 3000000 --nix-build-user-id-base 3000000 --no-confirm

    # update the PATh
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

    # install home manager
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    nix-shell '<home-manager>' -A install
    if [ $ID == "ubuntu" ];then
	sudo mkdir /etc/bash.bashrc.d
        sudo cp _system/etc/bash.bashrc.d/nix.bash /etc/bash.bashrc.d/nix.bash
    fi
fi
echo_in green "Is installed: nix"


##############
# wget 
##############
software=wget
packages[$software,arch]="wget"
packages[$software,debian]="wget"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]} 

# ANKI
#software=anki
#install [anki,any] --nix-env

if [ ! -d ~/.trash ]; then
    mkdir ~/.trash
fi

##############
# lazygit
##############
if ! command -v lazygit > /dev/null;then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit.tar.gz
    rm -rf lazygit
fi


# #############################################################################
# -----------------------------------------------------------------------------
# #############################################################################
# _private packages

echo_in blue "Do you want to clean before stowing _private?"
read -p " " response
case "$response" in
    [yY])
        source _private/clean.bash
        ;;
    *)
	echo_in green "Skipping cleaning. "
	;;
esac

##############
# firefox
##############
software=firefox
packages[$software,arch]="firefox"
packages[$software,debian]="firefox"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]}
priv_stow $software 

##############
# thunderbird
##############
software=thunderbird
packages[$software,arch]="thunderbird"
packages[$software,debian]="thunderbird"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]}
priv_stow $software 

##############
# chromium
##############
software=chromium
packages[$software,arch]="chromium"
packages[$software,debian]="chromium"
# on ubuntu using i3 this seems to be broken. ubuntu package for chromium is 
# actually just a snap package and that has problems with ibus
packages[$software,ubuntu]="chromium-browser"
install ${packages[$software,$ID]}
priv_stow $software 

##############
# brave
##############
software=brave
packages[$software,arch]="brave-bin"
packages[$software,debian]="brave-browser"
packages[$software,ubuntu]="brave-browser"
# setup repo for debian and ubuntu (if brave-browser not installed)
if [ $ID == "ubuntu" ] || [ $ID == "debian" ];then
    if ! command -v brave-browser > /dev/null; then
            sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
            echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
            sudo apt update -y
    fi
fi
install ${packages[$software,$ID]} --yay
priv_stow $software 

##############
# git
##############
software=git
packages[$software,arch]="git"
packages[$software,debian]="git"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]}
priv_stow $software

##############
# ssh
##############
software=ssh
packages[$software,arch]="openssh"
packages[$software,debian]="openssh-client openssh-server"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]}
priv_stow $software

##############
# hippo
##############
software=hippo
source _private/hippo/.hippo/hippo.bash
priv_stow $software

