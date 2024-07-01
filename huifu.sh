#!/bin/bash

# #############################################################################
# -----------------------------------------------------------------------------
# #############################################################################
# some checks and basic utilities

# get those pretty print functions and the like
source ./utils.sh

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
    error "Setup _private first. "
fi
#

# .local may not exist, we will need it (lest it gets symlinked)
if [ ! -d ~/.local ];then
   mkdir ~/.local
fi 

# #############################################################################
# -----------------------------------------------------------------------------
# #############################################################################
# installer functions

# arch based installer function
arch_install() {

    # check if already installed
    if ! pacman -Q $1 &> /dev/null; then

        # we might want to use yay for some AUR packages
        echo_in yellow "Installing:$1"
        if yay_flag;then
            if ! yay -S --noconfirm $1; then
                error "Couldnt install $1 using yay. "
            fi
        else
            if ! sudo pacman -S --noconfirm $1; then
                error "Couldnt install $1 using pacman. "
            fi
        fi
    fi
    echo_in green "Is installed:$1"
}

# debian based installer function
debian_install() {

    # check if already installed
    if ! dpkg -s $1 &> /dev/null; then

        # get all ppas if there are any and add them
        if [ $2 != "" ];then
            IFS=',' read -ra ppa_array <<< "$2"
            for ppa in "${ppa_array[@]}"; do
                
                # check if ppa already added
                if grep -q "^deb .*${ppa#ppa:}" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
                    continue
                fi
                
                # if not added, add it now
                echo_in yellow "Adding PPA: $ppa"
                if ! sudo add-apt-repository -y "$ppa"; then
                    error "Couldn't add PPA: $ppa"
                fi
                sudo apt update -y
                echo_in green "PPA is added: $ppa"
            done
        fi

        # attempt installation
        echo_in yellow "Installing:$1"
        if ! sudo apt install -y $1; then
            error "Couldnt install $1 using apt. "
        fi
    fi
    echo_in green "Is installed:$1"
}

# generic installer function, can add --yay to order yay usage on arch
install() {
    # parse all arguments into flags and package list
    local package_list
    local yay=1
    local ubuntu_ppas=""
    local debian_ppas=""
    for arg in "$@"; do
        case $arg in
            --yay)
                yay=0
                ;;
            --ubuntu_ppas=*)
                ubuntu_ppas=${arg#--ubuntu_ppas=}
                ;;
            --debian_ppas=*)
                debian_ppas=${arg#--debian_ppas=}
                ;;
            *)
                package_list="$package_list $arg"
                ;;
        esac
    done

    # depending on distro and flags use specific installer functions
    case $ID in
        "arch")
            arch_install "$package_list" $yay
        ;;
        "debian")
            debian_install "$package_list" $debian_ppas 
        ;;
        "ubuntu")
            debian_install "$package_list" $ubuntu_ppas 
        ;;
    esac
}

# #############################################################################
# -----------------------------------------------------------------------------
# #############################################################################
# stowing functions

# stowing for versioned packages
dot() {
    echo_in blue  "Stowing $1"
    if stow $1; then
        echo_in green "Is stowed: $1"
    else
        # the git hack: replaces files from repo by forcing the symlink and then restore the files from repo
        echo_in red "Can't stow, do you want to try the super git hack? Remember to git commit your dotfiles. y/N" >&2
        read -p " " response
        case "$response" in 
            [yY])
                stow --adopt $1
                git restore .
                ;;
            *)
                error "Aborting as requested. "
                ;;
        esac
        echo_in green "Should be good now. "
    fi
}

# stowing for _private
priv_stow() {
    echo_in blue  "Stowing $1"
    if ! stow -d _private -t ~ $1; then
        error "Cant stow $1, need manual intervention"
    fi
    echo_in green "Is stowed: $1"
}

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
# profile
##############
#dot profile

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
    ## wait, why? we are always calling this script from bash, noneed to check if using zsh
    ## https://stackoverflow.com/a/13864829 (check if var exists)
    #if [ ${ZSH_VERSION+x} ];then
    #    source ~/.zshrc.d/mise.zsh
    #elif [ ${BASH_VERSION+x} ];then
        source ~/.bashrc.d/mise.sh
    #else
    #    echo_in red "Could not activate mise, wrong shell?"
    #fi
    mise use --global node
fi

##############
# vim, for ubuntu and debian we'll use a ppa to get the latest...
##############
software=vim
packages[$software,arch]="vim"
packages[$software,debian]="vim"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]} --debian_ppas=ppa:jonathonf/vim --ubuntu_ppas=ppa:jonathonf/vim
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
packages[$software,arch]="i3-wm i3lock jgmenu nitrogen xcape i3blocks network-manager-applet dmenu xorg-xinit autorandr ttf-font-awesome arandr tk python xorg-xrandr"
# not sure about network manager applet
packages[$software,debian]="i3 i3lock jgmenu nitrogen xcape i3blocks network-manager-applet suckless-tools xinit autorandr fonts-font-awesome arandr python3-tk python3 x11-xserver-utils"
packages[$software,ubuntu]="i3 i3lock jgmenu nitrogen xcape i3blocks network-manager-gnome suckless-tools xinit autorandr fonts-font-awesome arandr python3-tk python3 x11-xserver-utils" 
install ${packages[$software,$ID]}
dot $software
dot i3blocks
dot fonts
dot xinit
dot autorandr
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
install ${packages[$software,$ID]} --debian_ppas=ppa:neovim-ppa/unstable --ubuntu_ppas=ppa:neovim-ppa/unstable

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
software=nomacs
packages[$software,arch]="nomacs"
packages[$software,debian]="nomacs"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]} 

# #############################################################################
# -----------------------------------------------------------------------------
# #############################################################################
# _private packages

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
            sudo apt update -y
    fi
fi
install ${packages[$software,$ID]} --yay
priv_stow $software 

##############
# git
##############
software=git
#packages[$software,arch]="git"
#packages[$software,debian]="git"
#packages[$software,ubuntu]=${packages[$software,debian]}
#install ${packages[$software,$ID]}
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
