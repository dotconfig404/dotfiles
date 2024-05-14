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
    echo_in blue "Installing: $1. "
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
    echo_in green "Is installed: $1. "
}

# debian based specific installation
debian_install() {
    echo_in blue "Installing: $1. "
    if ! dpkg -s $1 &> /dev/null; then
        if ! sudo apt install -y $1; then
            error "Couldnt install $1 using apt. "
        fi
    fi
    echo_in green "Is installed: $1. "
}

# generic installer function, might have second argument (currently only for 
# arch) if second parameter == yay, then arch installer will use yay instead
install() {
    local software=$1
    local package_list=${packages[$software,$ID]}

    case $ID in
        "arch")
            arch_install $package_list $2
        ;;
        "debian"|"ubuntu")
            debian_install $package_list
        ;;
    esac
}

# yay installer function
install_yay() {
    echo_in blue "Installing yay. "

    # Yay dependencies 
    sudo pacman -Sy --needed git base-devel --noconfirm
    if [ $? -ne 0 ]; then
        error "Failed to install necessary dependencies for yay."
    fi

    # Clone yay repo
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    if [ $? -ne 0 ]; then
        error "Failed to clone yay repository."
    fi

    # Change to the temporary directory and build yay
    pushd /tmp/yay-bin
    if ! makepkg -si --noconfirm; then
        popd  # Go back to the original directory if makepkg fails
        error "Failed to build and install yay."
    fi
    popd  # Go back to the original directory on success

    # Clean up the yay build directory
    rm -rf /tmp/yay-bin

    echo_in green "yay is installed successfully."
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
    # setup this later
    echo "hi"
}

# -----------------------------------------------------------------------------
# script setup, some checks and distro specific setup

# not entirely sure, but i think we need to check for if bash is at least 4.3
# associative arrays (which we use are available form 4.0 and nameref is 
# available from 4.3
if [ "${BASH_VERSINFO[0]}" -lt 4 ] || [ "${BASH_VERSINFO[0]}" -eq 4 -a "${BASH_VERSINFO[1]}" -lt 3 ]; then
    echo_in red "This script requires Bash version 4.3 or greater." >&2
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

# Declare packages array
# contains package list depending on software name and distro ID
declare -A packages

# We need stow to manage our symlinks
software=stow
packages[$software,arch]="stow"
packages[$software,debian]="stow"
packages[$software,ubuntu]=${packages[$software,ubuntu]}
install $software
dot $software

# -----------------------------------------------------------------------------
# package specific from here on

# bash
if ! command -v starship &> /dev/null; then
    curl -sS https://starship.rs/install.sh | sh
fi
dot starship
dot bash


# zsh
if ! command -v starship &> /dev/null; then
    curl -sS https://starship.rs/install.sh | sh
fi
dot starship
software=zsh
packages[$software,arch]="zsh"
packages[$software,debian]="zsh"
packages[$software,ubuntu]=${packages[$software,ubuntu]}
install $software
dot $software


# vim
software=vim
packages[$software,arch]="vim"
packages[$software,debian]="vim"
packages[$software,ubuntu]=${packages[$software,ubuntu]}
install $software
dot $software


# tmux
software=tmux
packages[$software,arch]="tmux"
packages[$software,debian]="tmux"
packages[$software,ubuntu]=${packages[$software,ubuntu]}
install $software
dot $software


# i3
software=i3
packages[$software,arch]="i3-wm i3lock jgmenu nitrogen xcape i3blocks"
packages[$software,debian]="i3 i3lock jgmenu nitrogen xcape i3blocks"
packages[$software,ubuntu]=${packages[$software,ubuntu]}
install $software
dot $software
dot fonts

# konsole
software=konsole
packages[$software,arch]="konsole kconfig"
packages[$software,debian]="konsole libkf5config-bin"
packages[$software,ubuntu]=${packages[$software,ubuntu]}
# need to write ~/.config/konsolerc using kwriteconfig5, not suitable for version controlling
# as it changes contents frequently (although not so bad if we wanna do it anyways)
kwriteconfig5 --file konsolerc --group "MainWindow" --group "Toolbar sessionToolbar" --key "IconSize" "16"
kwriteconfig5 --file konsolerc --group "Toolbar sessionToolbar" --key "IconSize" "16"
kwriteconfig5 --file konsolerc --group "UiSettings" --key "ColorScheme" "Breeze Dark"
kwriteconfig5 --file konsolerc --group "UiSettings" --key "WindowColorScheme" "Breeze Dark"
kwriteconfig5 --file konsolerc --group "TabBar" --key "CloseTabButton" "None"
kwriteconfig5 --file konsolerc --group "TabBar" --key "TabBarVisibility" "AlwaysHideTabBar"
install $software
dot $software
