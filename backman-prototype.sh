#!/usr/bin/env bash

# Echo with color
echo_in() {
    local color="$1"
    local message="${2:-}"
    local no_color="\033[0m"
    local color_code

    case $color in
        green)  color_code="\033[38;2;0;255;0;48;2;0;0;0m" ;;
        red)    color_code="\033[38;2;255;30;30;48;2;0;0;0m" ;;
        blue)   color_code="\033[38;2;0;100;255;48;2;0;0;0m" ;;
        yellow) color_code="\033[38;2;255;255;0;48;2;0;0;0m" ;;
        *)      color_code="\033[0m" ;;
    esac

    if [[ -n "$message" ]]; then
        echo -e "${color_code}${message}${no_color}"
    else
        while IFS= read -r line; do
            echo -e "${color_code}${line}${no_color}"
        done
    fi
}


source /etc/os-release 2>/dev/null || true

# Native commands
declare -A NATIVE_INSTALL_CHECK=(
  [arch]="pacman -Q"
  [ubuntu]="dpkg -s"
)
declare -A NATIVE_INSTALL=(
  [arch]="pacman -S --noconfirm"
  [ubuntu]="apt-get install -y"
)

# Install wrappers
generic_install() {
    local name="$1"
    local install_command="$2"
    local install_check="$3"
    if eval "$install_check" &>/dev/null; then
        echo_in green "Already installed: $name"
    else
        echo_in yellow "Installing: $name"
        if eval "$install_command"; then
            echo_in green "Installed: $name"
        else
            echo_in red "Failed installing: $name"
            return 1
        fi
    fi
}


native_install() {
    local name="$1"
    local pkgs="$2"

    local install_command="${NATIVE_INSTALL[$ID]} $pkgs"
    local install_check="${NATIVE_INSTALL_CHECK[$ID]} $pkgs"

    generic_install "$name" "$install_command" "$install_check"
}


# Dynamic definition
new_package() {
    local name
    declare -A args

    for arg in "$@"; do
        case "$arg" in
            name=*) name="${arg#name=}" ;;
            config_dir=*) args[config_dir]="${arg#config_dir=}" ;;
            native_pkgs=*)
                args[native_pkgs]="${arg#native_pkgs=}"
                ;;
            custom_install_func=*) args[custom_install_func]="${arg#custom_install_func=}" ;;
            custom_check_func=*) args[custom_check_func]="${arg#custom_check_func=}" ;;
        esac
    done

    if [[ ! "$name" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
        echo_in red "Invalid package name: $name"
        return 1
    fi


    pkgs="${args[native_pkgs]}"
    pkgs="${args[native_pkgs]}"
    eval "
    ${name}_native_install() {
        $install_func_body
        native_install $name \"${args[native_pkgs]}\"
    }"
}
install() {
    name=$1
}

declare -A pkgs=(
  [ubuntu]="curl less unzip"
  [arch]="curl less unzip"
)

new_package name=mypkg native_pkgs="${pkgs[$ID]}"
mypkg_native_install

starship_install() {
  echo "Downloading starship..."
  curl -sS https://starship.rs/install.sh | sh
}
starship_check() {
  command -v starship
}
new_package \
  name=starship \
  custom_install_func=starship_install \
  custom_check_func=starship_check
starship_native_install
