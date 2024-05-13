# -----------------------------------------------------------------------------
# helper functions

# pretty print
echo_in() {
    local color="$1"
    local message="$2"
    local no_color="\033[0m" 
    local color_code

    case $color in
        green)
            local color_code="\033[38;2;0;255;0;48;2;0;0;0m" 
            ;;
        red)
            local color_code="\033[38;2;255;30;30;48;2;0;0;0m"  
            ;;
        blue)
            local color_code="\033[38;2;0;100;255;48;2;0;0;0m" 
            ;;
    esac

    echo -e "${color_code}${message}${no_color}"
}
error() {
    echo_in red "Sth went wrong. " >&2
    exit 1
}

# arch based specific installation
arch_install() {
    echo_in blue "Installing: $1. "
    if ! pacman -Q $1 &> /dev/null; then
        if [ $2 == "yay" ];then
            if ! yay -S --noconfirm $1; then
                error
            fi
        else
            if ! sudo pacman -S --noconfirm $1; then
                error
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
            error
        fi
    fi
    echo_in green "Is installed: $1. "
}

# stowing for versioned packages
dot() {
    echo_in blue  "Stowing $1"
    if stow $1; then
        echo_in green "$1 is stowed. "
        return 0
    else
        echo_in red "Can't stow, do you want to try the super git hack? Remember to git commit your dotfiles. y/N" >&2
        read -p " " response
        case "$response" in 
            [yY])
                stow --adopt $1
                git restore .
                ;;
            *)
                error
                ;;
        esac
        echo_in green "Should be good now. "
    fi
}

# stowing for _private
priv_stow() {
    echo "hi"
}

# -----------------------------------------------------------------------------
# script setup, some checks and distro specific setup

# distro detection
source /etc/os-release
if [ $NAME != "Arch Linux" ] && [ $NAME != "Debian" ] && [ $NAME != "Ubuntu" ]; then
    echo_in red "Unsupported distro. " >&2
    exit 1
fi

# _private directory exists?
if [ ! -d "_private" ]; then
    echo_in red "Setup _private first. " >&2
    exit 1
fi

# distro specific preparations
echo_in blue "Doing distro specific preparations. "
case $NAME in 
    "Arch Linux")
        if ! command -v yay &> /dev/null; then
            echo_in blue "Installing yay. "
            pacman -S --needed git base-devel && \
                git clone https://aur.archlinux.org/yay-bin.git \
                && cd yay-bin && makepkg -si && cd .. && rm -rf yay-bin
        fi
        echo_in green "yay is installed. "
    ;;
    *)
        echo_in green "No preparations to be done. "
esac

# -----------------------------------------------------------------------------
# package specific from here on

# bash
software=bash
case $NAME in 
    "Arch Linux")
        packages="tmux" 
        arch_install $packages
    ;;
    "Debian"|"Ubuntu")
        packages="tmux" 
        debian_install $packages
    ;;
esac
dot tmux


# tmux
software=tmux
case $NAME in 
    "Arch Linux")
        packages="tmux" 
        arch_install $packages
    ;;
    "Debian"|"Ubuntu")
        packages="tmux" 
        debian_install $packages
    ;;
esac
dot tmux


# tmux
software=tmux
case $NAME in 
    "Arch Linux")
        packages="tmux" 
        arch_install $packages
    ;;
    "Debian"|"Ubuntu")
        packages="tmux" 
        debian_install $packages
    ;;
esac
dot tmux


# tmux
software=tmux
case $NAME in 
    "Arch Linux")
        packages="tmux" 
        arch_install $packages
    ;;
    "Debian"|"Ubuntu")
        packages="tmux" 
        debian_install $packages
    ;;
esac
dot tmux


# tmux
software=tmux
case $NAME in 
    "Arch Linux")
        packages="tmux" 
        arch_install $packages
    ;;
    "Debian"|"Ubuntu")
        packages="tmux" 
        debian_install $packages
    ;;
esac
dot tmux


# tmux
software=tmux
case $NAME in 
    "Arch Linux")
        packages="tmux" 
        arch_install $packages
    ;;
    "Debian"|"Ubuntu")
        packages="tmux" 
        debian_install $packages
    ;;
esac
dot tmux



