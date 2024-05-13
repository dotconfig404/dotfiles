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


install() {
    local software="$1"
    source /etc/os-release

    echo_in blue "Installing $software"
    case $NAME in 
        "Arch Linux")
            local key="${software}[arch]"
            local packages="${!key}" 
            sudo pacman -S $packages --noconfirm
        ;;
        "Debian"|"Ubuntu")
            local key="${software}[debian]"
            local packages="${!key}"  
            sudo apt install $packages -y
        ;;
        *)
            echo_in red "Could not find distro name..." >&2
            echo "-----------------------------"
            return 1
        ;;
    esac
    echo_in green "$software is installed"
}


dot() {
    echo_in blue  "Stowing $1"
    if stow $1; then
        echo_in green "$1 is stowed."
        return 0
    else
        echo_in blue "Can't stow, do you want to try the super git hack? Remember to git commit your dotfiles. Y/n" >&2
        read -p " " response
        case "$response" in 
            [nN])
                return 1
                ;;
            *)
                stow --adopt $1
                git restore .
                ;;
        esac
        echo_in green "Should be good now. "
    fi
}

# We are using associative arrays, which are only available from bash 4.0
# and we are using the nameref feature which is only available from bash
# version 4.3
if [ "${BASH_VERSINFO[0]}" -lt 4 ] || [ "${BASH_VERSINFO[0]}" -eq 4 -a "${BASH_VERSINFO[1]}" -lt 3 ]; then
    echo_in red "This script requires Bash version 4.3 or greater." >&2
    exit 1
fi


# bash
if [ "$1" == "bash" ] || [ "$1" == "" ]; then
    curl -sS https://starship.rs/install.sh | sh
    dot starship
    dot bash
fi

# zsh
if [ "$1" == "zsh" ] || [ "$1" == "" ]; then
    #curl -sS https://starship.rs/install.sh | sh
    #dot starship
    declare -A zsh=(
        [arch]="zsh"
        [debian]="zsh"
    )
    install zsh
    dot zsh
fi

# vim
if [ "$1" == "vim" ] || [ "$1" == "" ]; then
    declare -A vim=(
        [arch]="gvim"
        [debian]="vim"
    )
    install vim
    dot vim
fi

# tmux
if [ "$1" == "tmux" ] || [ "$1" == "" ]; then
    declare -A tmux=(
        [arch]="tmux"
        [debian]="tmux"
    )
    install tmux
    dot tmux
fi

# i3
if [ "$1" == "i3" ] || [ "$1" == "" ]; then
    declare -A i3=(
        [arch]="i3-wm i3lock jgmenu nitrogen xcape i3blocks"
        [debian]="i3 i3lock jgmenu nitrogen xcape i3blocks"
    )
    install i3
    dot i3
    #dot jgmenu
    #dot nitrogen
    dot fonts
fi


# konsole
if [ "$1" == "konsole" ] || [ "$1" == "" ]; then
    declare -A konsole=(
        # kconfig/libkf5config-bin for kwriteconfig5
        [arch]="konsole kconfig"
        [debian]="konsole libkf5config-bin"
    )
    install konsole
    kwriteconfig5 --file konsolerc --group "MainWindow" --group "Toolbar sessionToolbar" --key "IconSize" "16"
    kwriteconfig5 --file konsolerc --group "Toolbar sessionToolbar" --key "IconSize" "16"
    kwriteconfig5 --file konsolerc --group "UiSettings" --key "ColorScheme" "Breeze Dark"
    kwriteconfig5 --file konsolerc --group "UiSettings" --key "WindowColorScheme" "Breeze Dark"
    kwriteconfig5 --file konsolerc --group "TabBar" --key "CloseTabButton" "None"
    kwriteconfig5 --file konsolerc --group "TabBar" --key "TabBarVisibility" "AlwaysHideTabBar"
    dot konsole
fi
