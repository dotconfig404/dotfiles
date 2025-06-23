#!/usr/bin/env bash
source /etc/os-release

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



# Native commands
declare -A NATIVE_INSTALL_CHECK=(
  [arch]="pacman -Q"
  [ubuntu]="dpkg -s"
)
declare -A NATIVE_INSTALL=(
  [arch]="sudo pacman -S --noconfirm"
  [ubuntu]="sudo apt-get install -y"
)

_install() {
    local name="$1"
    local install_command="$2"
    local install_check="$3"
	if [[ ! -n $install_command || ! -n $install_check ]]; then
		return 0
	fi

    echo_in blue "Installing: $name"
    if eval "$install_check" &>/dev/null; then
        echo_in green "Already installed: $name"
    else
        if eval "$install_command"; then
            echo_in green "Installed: $name"
        else
            echo_in red "Failed installing: $name"
            exit 1
        fi
    fi
}



_link_configs-WIP() {
    local source_dir="$1"
	echo_in red $source_dir
	if [ ! -d $source_dir ]; then
		return 0
	fi
	local target_dir="${2:-$HOME}"

    echo_in blue "Linking files in: $source_dir"
    source_dir="$(realpath "$source_dir")"
    echo_in blue "Linking files in: $source_dir"

    dirs=($(find "$source_dir" -mindepth 1 -maxdepth 1 -type d))
    echo_in blue "Found dirs: ${dirs[@]}"

    for dir in "${dirs[@]}"; do
		if [[ -e $target && ! -L $target ]]; then
			echo_in yellow "$target exists. Overwrite? (y/n"
			read -p " " response
			case $response in
				[yY]) rm $target && ln -s $dir $target ;;
				*) continue ;;
			esac
		elif [[ ! -e $target ]]; then
			echo_in yellow "$target does not exist. Link or create dir? (l/d)"
			read -p " " response
			case $response in
				[lL]) ln -s $dir $target ;;
				*) mkdir $target ;;
			esac
		fi
	done
}

_link_configs() {
	if [ ! -d $1 ]; then
		return 0
	fi
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

install() {
    local native_install_command="${NATIVE_INSTALL[$ID]} ${packages[$ID]}"
    local native_install_check="${NATIVE_INSTALL_CHECK[$ID]} ${packages[$ID]}"

	local commands=(
        "_install $name $custom_install_command $custom_install_check"
        "_install $name \"$native_install_command\" \"$native_install_check\""
        "_link_configs $config_dir"
        "$post_link_command"
    )

    install_func="$(IFS=';'; echo "${commands[*]}")"
	eval $install_func

	unset name
	unset config_dir
	unset packages[$ID]
	unset custom_check
	unset custom_install_command
	unset post_link_command
}


declare -A packages

name=basics
packages[ubuntu]="curl wget less unzip zip python3 python3-venv silversearcher-ag cowsay"
packages[arch]="curl wget less unzip zip python the_silver_searcher cowsay"
config_dir=$name
install

name=zsh
packages[ubuntu]="zsh"
packages[arch]="zsh"
custom_install_command() {
	curl -sS https://starship.rs/install.sh | sh
}
custom_install_check() {
	! command -v starship &> /dev/null
}
config_dir=$name
install

#name=basics
config_dir=testing_parent
install
