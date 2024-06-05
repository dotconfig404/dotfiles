#!/bin/bash
# -----------------------------------------------------------------------------
# helper functions

# pretty print with colors
echo_in() {
    local color="$1"
    local message="$2"
    local no_color="\033[0m" 
    local color_code

    case $color in
        green)
            color_code="\033[38;2;0;255;0;48;2;0;0;0m" 
            ;;
        red)
            color_code="\033[38;2;255;30;30;48;2;0;0;0m"  
            ;;
        blue)
            color_code="\033[38;2;0;100;255;48;2;0;0;0m" 
            ;;
    esac

    echo -e "${color_code}${message}${no_color}"
}

# error logging function, if argument given will print that as message
error() {
    if [ -z "$1" ];then
        echo_in red "Sth went wrong. " >&2
    else
        echo_in red "$1" >&2
    fi
    exit 1
}

# arch based specific installation
arch_install() {
    echo_in blue "Installing:$1"
    if ! pacman -Q $1 &> /dev/null; then
        if [ $2 == "yay" ];then
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

# debian based specific installation
debian_install() {
    echo_in blue "Installing:$1"
    if ! dpkg -s $1 &> /dev/null; then
        if ! sudo apt install -y $1; then
            error "Couldnt install $1 using apt. "
        fi
    fi
    echo_in green "Is installed:$1"
}

# generic installer function, can add --yay to order yay usage on arch
install() {
    # check flags and get package list
    local package_list
    local use_yay=1
    for arg in "$@"; do
        case $arg in
            --yay)
                use_yay=0
                ;;
            *)
                package_list="$package_list $arg"
                ;;
        esac
    done

    # depending on distro and flags use specific installer functions
    case $ID in
        "arch")
            if [ $use_yay ]; then
                arch_install "$package_list" "yay"
            else
                arch_install "$package_list"
            fi
        ;;
        "debian"|"ubuntu")
            debian_install "$package_list"
        ;;
    esac
}

# yay installer function
install_yay() {
    echo_in blue "Installing yay. "

    # Yay dependencies 
    sudo pacman -Sy --needed git base-devel --noconfirm
    if [ $? -ne 0 ]; then
        error "Failed to install necessary dependencies for yay. "
    fi

    # Clone yay repo
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    if [ $? -ne 0 ]; then
        error "Failed to clone yay repository. "
    fi

    # Change to the temporary directory and build yay
    pushd /tmp/yay-bin
    if ! makepkg -si --noconfirm; then
        popd  
        error "Failed to build and install yay. "
    fi
    popd  

    # Clean up the yay build directory
    rm -rf /tmp/yay-bin

    echo_in green "yay is installed. "
}

# stowing for versioned packages
dot() {
    echo_in blue  "Stowing $1"
    if stow $1; then
        echo_in green "$1 is stowed. "
    else
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
    echo_in green "$1 is stowed. "
}

# -----------------------------------------------------------------------------
# script setup, some checks and distro specific setup

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

# Declare packages array
# contains package list depending on software name and distro ID
declare -A packages

# We need stow to manage our symlinks
software=stow
packages[$software,arch]="stow"
packages[$software,debian]="stow"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]}

# git is also necessary for yay
software=git
packages[$software,arch]="git"
packages[$software,debian]="git"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]}

# Distro specific preparations
echo_in blue "Doing distro specific preparations. "
case $NAME in 
    "Arch Linux")
        if ! command -v yay &> /dev/null; then
            install_yay
        fi
    ;;
    *)
        echo_in green "No preparations to be done. "
esac

# -----------------------------------------------------------------------------
# -------------------------------------
# package specific from here on

# starship and curl
software=curl
packages[$software,arch]="curl"
packages[$software,debian]="curl"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]}
if ! command -v starship &> /dev/null; then
    curl -sS https://starship.rs/install.sh | sh
fi
dot starship


# profile
dot profile


# bash (needs starship)
dot bash


# zsh (needs starship)
software=zsh
packages[$software,arch]="zsh"
packages[$software,debian]="zsh"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]}
dot $software


# vim
software=vim
packages[$software,arch]="vim"
packages[$software,debian]="vim"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]}
dot $software
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim -c 'PluginInstall' -c 'qa!'


# tmux
software=tmux
packages[$software,arch]="tmux"
packages[$software,debian]="tmux"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]}
dot $software


# i3
software=i3
packages[$software,arch]="i3-wm i3lock jgmenu nitrogen xcape i3blocks"
packages[$software,debian]="i3 i3lock jgmenu nitrogen xcape i3blocks"
packages[$software,ubuntu]="i3 i3lock jgmenu nitrogen xcape i3blocks" #${packages[$software,debian]}
install ${packages[$software,$ID]}
dot $software
dot fonts
#echo_in blue "rebuilding font cache"
#fc-cache -f
#echo_in green "font cache rebuilt"


# konsole
software=konsole
packages[$software,arch]="konsole kconfig"
packages[$software,debian]="konsole libkf5config-bin"
packages[$software,ubuntu]=${packages[$software,debian]}
# need to write ~/.config/konsolerc using kwriteconfig5, not suitable for version controlling
# as it changes contents frequently (although not so bad if we wanna do it anyways)
kwriteconfig5 --file konsolerc --group "Desktop Entry" --key "DefaultProfile" "dotconfig.profile"
kwriteconfig5 --file konsolerc --group "MainWindow" --group "Toolbar sessionToolbar" --key "IconSize" "16"
kwriteconfig5 --file konsolerc --group "Toolbar sessionToolbar" --key "IconSize" "16"
kwriteconfig5 --file konsolerc --group "UiSettings" --key "ColorScheme" "Breeze Dark"
kwriteconfig5 --file konsolerc --group "UiSettings" --key "WindowColorScheme" "Breeze Dark"
kwriteconfig5 --file konsolerc --group "TabBar" --key "CloseTabButton" "None"
kwriteconfig5 --file konsolerc --group "TabBar" --key "TabBarVisibility" "AlwaysHideTabBar"
install ${packages[$software,$ID]}
dot $software


# awesomewm (needs lots of testing)
software=awesome
packages[$software,arch]="awesome"
packages[$software,debian]="awesome"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]}
dot $software


# openbox (needs lots of testing)
software=openbox
packages[$software,arch]="openbox"
packages[$software,debian]="openbox"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]}
dot $software


# emacs (needs testing)
software=emacs
packages[$software,arch]="emacs"
packages[$software,debian]="emacs"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]}
dot $software


# gtk
dot gtk

# python dev
software=python
packages[$software,arch]="python"
packages[$software,debian]="python3 python3-venv"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]}

# silversearcher
software=silversearcher-ag
packages[$software,arch]="the_silver_searcher"
packages[$software,debian]="silversearcher-ag"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]}

# mise, node
# zsh and bash configs added
if ! command -v mise &> /dev/null; then
    curl https://mise.run | sh
    mise activate > ~/.bashrc.d/mise.sh
    mise activate zsh > ~/.zshrc.d/mise.zsh
    mise use --global node
fi

# -------------------------------------
# _private packages

# firefox
software=firefox
packages[$software,arch]="firefox"
packages[$software,debian]="firefox"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]}
priv_stow $software 


# thunderbird
software=thunderbird
packages[$software,arch]="thunderbird"
packages[$software,debian]="thunderbird"
packages[$software,ubuntu]=${packages[$software,debian]}
install ${packages[$software,$ID]}
priv_stow $software 


# chromium
software=chromium
packages[$software,arch]="chromium"
packages[$software,debian]="chromium"
# on ubuntu using i3 this seems to be broken. ubuntu package for chromium is 
# actually just a snap package and that has problems with ibus
packages[$software,ubuntu]="chromium-browser"
install ${packages[$software,$ID]}
priv_stow $software 


# brave
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
