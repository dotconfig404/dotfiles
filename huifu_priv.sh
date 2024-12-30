#!/bin/bash
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
packages[arch]="firefox"
packages[debian]="firefox"
packages[ubuntu]=${packages[debian]}
install ${packages[$ID]}
priv_stow firefox

##############
# thunderbird
##############
packages[arch]="thunderbird"
packages[debian]="thunderbird"
packages[ubuntu]=${packages[debian]}
install ${packages[$ID]}
priv_stow thunderbird

##############
# chromium
##############
packages[arch]="chromium"
packages[debian]="chromium"
# on ubuntu using i3 this seems to be broken. ubuntu package for chromium is 
# actually just a snap package and that has problems with ibus
packages[ubuntu]="chromium-browser"
install ${packages[$ID]}
priv_stow chromium

##############
# brave
##############
packages[arch]="brave-bin"
packages[debian]="brave-browser"
packages[ubuntu]="brave-browser"
# setup repo for debian and ubuntu (if brave-browser not installed)
if [ $ID == "ubuntu" ] || [ $ID == "debian" ];then
    if ! command -v brave-browser > /dev/null; then
            sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
            echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
            sudo apt update -y
    fi
fi
install ${packages[$ID]} --yay
priv_stow brave

##############
# git
##############
packages[arch]="git"
packages[debian]="git"
packages[ubuntu]=${packages[debian]}
install ${packages[$ID]}
priv_stow git

##############
# ssh
##############
packages[arch]="openssh"
packages[debian]="openssh-client openssh-server"
packages[ubuntu]=${packages[debian]}
install ${packages[$ID]}
priv_stow ssh

##############
# hippo
##############
source _private/hippo/.hippo/hippo.bash
priv_stow hippo

