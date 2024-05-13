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

    echo_in blue "Installing $software. "
    case $NAME in 
        "Arch Linux")
            local key="${software}[arch]"
            local packages="${!key}" 
            sudo pacman -S $packages --noconfirm
        ;;
        "Debian"|"Ubuntu")
            local key="${software}[debian]"
            local packages="${!key}"  
            
            # for the rare case of using ubuntu specific packages...
            local ubuntu_key="${software}[ubuntu]"
            local ubuntu_packages="${!ubuntu_key}"
            if [[ "$NAME" == "Ubuntu" && ! -z "$ubuntu_packages" ]]; then
                packages="$ubuntu_packages"
            fi

            sudo apt install $packages -y
        ;;
        *)
            echo_in red "Could not find distro name. " >&2
            echo "-----------------------------"
            return 1
        ;;
    esac
    echo_in green "$software is installed. "
}


dot() {
    echo_in blue  "Stowing $1"
    if stow $1; then
        echo_in green "$1 is stowed. "
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


# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# init and essentials:



# finnicky distro-specific setup, e.g. yay for arch
#distro_specific_software() { #    source /etc/os-release
#    echo_in blue "Installing distro-specific software."
#    case $NAME in 
#        "Arch Linux")
#            echo_in blue "Installing yay. "
#            if ! command -v yay &> /dev/null; then
#                pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si && cd .. && rm -rf yay-bin
#            fi
#            echo_in green "yay is installed. "
#        ;;
#        "Debian"|"Ubuntu")
#            echo "Nothing to do for deb based distros."
#        ;;
#        *)
#            echo_in red "Could not find distro name..." >&2
#            echo "-----------------------------"
#            return 1
#        ;;
#    esac
#    echo_in green "Distro-specific software is good to go."
#}
#if [ "$1" == "_essentials" ] || [ "$1" == "" ]; then
#    distro_specific_software
#fi

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

# ---------------------------------------- not version controlled stuff/ private
# make sure we have the _private directory:
if [ ! -d "_private" ]; then
    echo_in red "Setup _private first. "
    exit 1
fi

# firefox
if [ "$1" == "firefox" ] || [ "$1" == "" ];  then
    declare -A firefox=(
        [arch]="firefox"
        [debian]="firefox"
    )
    install firefox
    echo_in blue "Stowing firefox. "
    stow -d _private -t ~ firefox
    echo_in green "Firefox is stowed. "
fi

# thunderbird
if [ "$1" == "thunderbird" ] || [ "$1" == "" ];  then
    declare -A thunderbird=(
        [arch]="thunderbird"
        [debian]="thunderbird"
    )
    install thunderbird
    echo_in blue "Stowing thunderbird. "
    stow -d _private -t ~ thunderbird
    echo_in green "Thunderbird is stowed. "
fi

# chromium
if [ "$1" == "chromium" ] || [ "$1" == "" ];  then
    declare -A chromium=(
        [arch]="chromium"
        [debian]="chromium"
        # as of ubuntu 22.04, snap version is broken (aka the version that is
        # in the official ubuntu repository) is broken. see more:
        # https://askubuntu.com/questions/1412097/chrome-or-chromium-can-not-use-ibus
        # screw that though, just not gonna use it then. 
        [ubuntu]="firefox"
    )
    install chromium
    echo_in blue "Stowing chromium. "
    stow -d _private -t ~ chromium
    echo_in green "Chromium is stowed. "
fi

# brave
# getting a bit messier now
# install instructions from https://brave.com/linux/ and  https://github.com/Jguer/yay?tab=readme-ov-file#installation
if [ "$1" == "brave" ] || [ "$1" == "" ];  then
    source /etc/os-release

    echo_in blue "Installing brave. "
    case $NAME in 
        "Arch Linux")
            echo_in blue "First, installing yay. "
            if ! command -v yay &> /dev/null; then
                pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si && cd .. && rm -rf yay-bin
            fi
            echo_in green "yay is installed. "
            # --noconfirm flag needs confirmation (of existence)
            yay -S --noconfirm brave-bin
        ;;
        "Debian"|"Ubuntu")
            sudo apt install curl -y
            sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
            echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
            sudo apt update -y
            sudo apt install brave-browser -y
        ;;
        *)
            echo_in red "Could not find distro name. " >&2
            echo "-----------------------------"
            return 1
        ;;
    esac
    echo_in green "$software is installed. "
    echo_in blue "Stowing brave. "
    stow -d _private -t ~ brave 
    echo_in green "Brave is stowed. "
fi
