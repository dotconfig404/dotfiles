# functions that havent found a home yet go here
# often too insignificant to matter to anyone and thus they just gather around here.
# sitting by the pretty lights of this terminal window and tell each other stories 
# to surpress the unquenchable desire to belong. some day, echo_in, some day.
#
# beware, there also some uncommented functions... they live in the shadows, discarded
# and deemed unworthy by their owners, one should not linger there too long...

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
