#!/bin/bash
##############
# stow
##############
packages[arch]="stow"
packages[debian]="stow"
packages[ubuntu]=${packages[debian]}
install ${packages[$ID]}

##############
# starship and curl
##############
packages[arch]="curl"
packages[debian]="curl"
packages[ubuntu]=${packages[debian]}
install ${packages[$ID]}
if ! command -v starship &> /dev/null; then
    curl -sS https://starship.rs/install.sh | sh
fi
dot starship

##############
# basics 
##############
packages[arch]="less unzip 7zip"
packages[debian]="less unzip 7zip"z
packages[ubuntu]=${packages[debian]}
install ${packages[$ID]}


##############
# bash (needs starship)
##############
dot bash

##############
# zsh (needs starship)
##############
packages[arch]="zsh"
packages[debian]="zsh"
packages[ubuntu]=${packages[debian]}
install ${packages[$ID]}
dot zsh

##############
# konsole
##############
packages[arch]="konsole kconfig"
packages[debian]="konsole libkf5config-bin"
packages[ubuntu]=${packages[debian]}
install ${packages[$ID]}
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
dot konsole

###############
## awesomewm (needs lots of testing)
###############
#packages[arch]="awesome"
#packages[debian]="awesome"
#packages[ubuntu]=${packages[debian]}
#install ${packages[$ID]}
#dot $software
#
###############
## openbox (needs lots of testing)
###############
#packages[arch]="openbox"
#packages[debian]="openbox"
#packages[ubuntu]=${packages[debian]}
#install ${packages[$ID]}
#dot $software

##############
# gtk
##############
dot gtk

##############
# python dev
##############
packages[arch]="python"
packages[debian]="python3 python3-venv"
packages[ubuntu]=${packages[debian]}
install ${packages[$ID]}

##############
# silversearcher
##############
packages[arch]="the_silver_searcher"
packages[debian]="silversearcher-ag"
packages[ubuntu]=${packages[debian]}
install ${packages[$ID]}


##############
# vim
##############
packages[arch]="vim"
packages[debian]="vim"
packages[ubuntu]=${packages[debian]}
install ${packages[$ID]} #--debian_ppas=ppa:jonathonf/vim --ubuntu_ppas=ppa:jonathonf/vim
dot vim 
vim -c 'PlugInstall' -c 'qa!'
vim -c 'CocInstall coc-pyright' -c 'qa!'
vim -c 'CocInstall coc-rust-analyzer' -c 'qa!'

##############
# tmux
##############
packages[arch]="tmux"
packages[debian]="tmux"
packages[ubuntu]=${packages[debian]}
install ${packages[$ID]}
dot tmux

##############
# i3
##############
# python3-tk, xrandr, arandr, python3 for monitor manager script (i3blocks), fontsawesome as well and needed by other scripts
# transparency using picom (fork of compton)
packages[arch]="xorg-server i3-wm i3lock jgmenu nitrogen xcape i3blocks network-manager-applet dmenu xorg-xinit autorandr ttf-font-awesome arandr tk python xorg-xrandr picom blueman"
# not sure about network manager applet
packages[debian]="i3 i3lock jgmenu nitrogen xcape i3blocks network-manager-applet suckless-tools xinit autorandr fonts-font-awesome arandr python3-tk python3 x11-xserver-utils picom blueman"
packages[ubuntu]="i3 i3lock jgmenu nitrogen xcape i3blocks network-manager-gnome suckless-tools xinit autorandr fonts-font-awesome arandr python3-tk python3 x11-xserver-utils picom blueman" 
install ${packages[$ID]}
dot i3
dot i3blocks
dot fonts
dot xinit
dot autorandr
dot picom
if [ "$HOSTNAME" == "noxy" ];then
    dot xresources
    xrdb ~/.Xresources

fi
#echo_in yellow "rebuilding font cache"
#fc-cache -f
#echo_in green "font cache rebuilt"

##############
# emacs (needs testing)
##############
packages[arch]="emacs"
packages[debian]="emacs"
packages[ubuntu]=${packages[debian]}
install ${packages[$ID]}
dot emacs

##############
# gtk
##############
dot gtk

##############
# neovim
##############
packages[arch]="neovim"
packages[debian]="neovim"
packages[ubuntu]=${packages[debian]}
install ${packages[$ID]} #--debian_ppas=ppa:neovim-ppa/unstable --ubuntu_ppas=ppa:neovim-ppa/unstable

##############
# dolphin
##############
# briefly considered making custom config, but this is terrible with kdes configs. 
# konsole was bad enough. at some point i gotta decide what to just leave 
# as it is. it is not worth it trying to dotify all software. 
packages[arch]="dolphin"
packages[debian]="dolphin"
packages[ubuntu]=${packages[debian]}
install ${packages[$ID]} 

##############
# nomacs
##############
#packages[arch]="nomacs"
#packages[debian]="nomacs"
#packages[ubuntu]=${packages[debian]}
#install ${packages[$ID]}

##############
# misc
##############
packages[arch]="numlockx tree thunar wireshark-qt sshuttle spectacle gthumb flameshot nodejs thunar-archive-plugin mplayer wqy-zenhei"
packages[debian]="numlockx tree thunar wireshark sshuttle kde-spectacle gthumb flameshot nodejs thunar-archive-plugin mplayer ttf-wqy-zenhei"
packages[ubuntu]=${packages[debian]}
install ${packages[$ID]} 

##############
# fcitx5
##############
# keyboard setup (under X so far): eurkey and pinyin
# also added environment variables to zprofile
# more or less followed this: https://medium.com/@brightoning/cozy-ubuntu-24-04-install-fcitx5-for-chinese-input-f4278b14cf6f
echo "run_im fcitx5" > ~/.xinputrc
# this is prolly wrong
packages[arch]="fcitx5 fcitx5-qt fcitx5-gtk fcitx5-chinese-addons noto-fonts-cjk"
packages[debian]="fcitx5 fcitx5-chinese-addons fonts-noto-cjk fonts-noto-cjk-extra im-config"
packages[ubuntu]=${packages[debian]}
install ${packages[$ID]} 
dot fcitx5

##############
# kde
##############
# for lack of a better place to put this, ill add some random config files of kde here
dot kde


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
packages[arch]="wget"
packages[debian]="wget"
packages[ubuntu]=${packages[debian]}
install ${packages[$ID]} 

# ANKI
#install [anki,any] --nix-env

if [ ! -d ~/.trash ]; then
    mkdir ~/.trash
fi

##############
# irc
##############
packages[arch]="irssi"
packages[debian]="irssi"
packages[ubuntu]=${packages[debian]}
install ${packages[$ID]} 

##############
# ftp
##############
packages[arch]="lftp filezilla"
packages[debian]="lftp filezilla"
packages[ubuntu]=${packages[debian]}
install ${packages[$ID]} 

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

##############
# rust
##############
#curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

##############
# code
##############
packages[arch]="code"
packages[debian]="code"
packages[ubuntu]=${packages[debian]}
install ${packages[$ID]} 

##############
# chromium
##############
packages[arch]="chromium"
packages[debian]="chromium"
packages[ubuntu]=${packages[debian]}
install ${packages[$ID]} 

##############
# pavucontrol
##############
packages[arch]="pavucontrol"
packages[debian]="pavucontrol"
packages[ubuntu]=${packages[debian]}
install ${packages[$ID]} 

