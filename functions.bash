# #############################################################################
# -----------------------------------------------------------------------------
# #############################################################################
# echo wrappers

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
        yellow)
            color_code="\033[38;2;255;255;0;48;2;0;0;0m"
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

# #############################################################################
# -----------------------------------------------------------------------------
# #############################################################################
# installer functions

# arch based installer function
arch_install() {

    # check if already installed
    if ! pacman -Q $1 &> /dev/null; then

        # we might want to use yay for some AUR packages
        echo_in yellow "Installing: $1 "
        if [[ $2 == 0 ]];then
            if ! yay -S --noconfirm $1; then
                error "Couldn't install $1 with yay. "
            fi
        else
            if ! sudo pacman -S --noconfirm $1; then
                error "Couldn't install $1 with pacman. "
            fi
        fi
    fi
    echo_in green "Is installed: $1 "
}

# debian based installer function
debian_install() {

    # check if already installed
    if ! dpkg -s $1 &> /dev/null; then

        # get all ppas if there are any and add them
        # != "" doesnt work
        if [ -n $2 ];then
            IFS=',' read -ra ppa_array <<< "$2"
            for ppa in "${ppa_array[@]}"; do
                
                # check if ppa already added
                if grep -q "^deb .*${ppa#ppa:}" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
                    continue
                fi
                
                # if not added, add it now
                echo_in yellow "Adding PPA: $ppa "
                if ! sudo add-apt-repository -y "$ppa"; then
                    error "Couldn't add PPA: $ppa "
                fi
                sudo apt update -y
                echo_in green "PPA is added: $ppa "
            done
        fi

        # attempt installation
        echo_in yellow "Installing: $1 "
        if ! sudo apt install -y $1; then
            error "Couldn't install $1 with apt. "
        fi
    fi
    echo_in green "Is installed: $1 "
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
    
    # get rid of leading space :)
    package_list=${package_list:1}

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
    echo_in blue  "Stowing $1 "
    if stow $1 --ignore=swp; then
        echo_in green "Is stowed: $1 "
    else
        # the git hack: replaces files from repo by forcing the symlink and then restore the files from repo
        echo_in red "Can't stow, do you want to try the super git hack? Remember to git commit your dotfiles. y/N " >&2
        read -p " " response
        case "$response" in 
            [yY])
                stow --adopt $1 --ignore=swp
                git restore .
                ;;
            *)
                error "Aborting, as requested. "
                ;;
        esac
        echo_in green "Should be good now. "
    fi
}

# stowing for _private
priv_stow() {
    echo_in blue  "Stowing $1 "
    if ! stow -d  _private -t ~ $1 --ignore=swp; then
        error "Can't stow $1, need manual intervention "
    fi
    echo_in green "Is stowed: $1 "
}


# #############################################################################
# -----------------------------------------------------------------------------
# #############################################################################
# deceased and disappeared

# yay installer function
#install_yay() {
#    echo_in yellow "Installing yay. "
#
#    # Yay dependencies 
#    sudo pacman -Sy --needed git base-devel --noconfirm
#    if [ $? -ne 0 ]; then
#        error "Failed to install necessary dependencies for yay. "
#    fi
#
#    # Clone yay repo
#    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
#    if [ $? -ne 0 ]; then
#        error "Failed to clone yay repository. "
#    fi
#
#    # Change to the temporary directory and build yay
#    pushd /tmp/yay-bin
#    if ! makepkg -si --noconfirm; then
#        popd  
#        error "Failed to build and install yay. "
#    fi
#    popd  
#
#    # Clean up the yay build directory
#    rm -rf /tmp/yay-bin
#
#    echo_in green "yay is installed. "
#}

## nvim installer function
## somehow the print messages are not printed in order
## almost as if this whole function is async
#install_nvim() {
#    echo_in yellow "Installing nvim. "
#
#    # Clone nvim repo
#    git clone https://github.com/neovim/neovim /tmp/nvim
#    if [ $? -ne 0 ]; then
#        error "Failed to clone nvim repository. "
#    fi
#
#    # Change to the temporary directory and build yay
#    pushd /tmp/nvim
#    make CMAKE_BUILD_TYPE=Release
#    if ! sudo make install; then
#        popd  
#        error "Failed to build and install nvim. "
#    fi
#    popd  
#
#    # Clean up the yay build directory
#    rm -rf /tmp/nvim
#
#    echo_in green "nvim is installed. "
#}
