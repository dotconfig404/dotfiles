

# install function
## 1) checks if command (arg 1) exists, if so skip installation 
## 2) checks for distro and then installs it using package name (arg 2) 
# $1 = command name
# $2 = package name
install() {
    if command -v $1 &> /dev/null; then
        echo "$2 ($1) is already installed. "
        return 0
    else
        source /etc/os-release
        case $NAME in 
            "Arch Linux")
                sudo pacman --noconfirm -S $2
            ;;
            "Debian"|"Ubuntu")
                sudo apt install -y $2
            ;;
            *)
                echo "Could not find distro name..."
                return 1
            ;;
        esac
    fi
}

# just symlink the appropiate dotfiles
dot() {
    echo "Attempting to stow package $1"
    if stow $1; then
        echo "Success!"
        return 0
    else
        read -p "Failure, do you want to try the super git hack? Y/n" response
        case "$response" in 
            [nN])
                return 1
                ;;
            *)
                stow --adopt $1
                git restore .
                ;;
        esac
        echo "Success (possibly. maybe. OK, probably.)"
    fi
}

