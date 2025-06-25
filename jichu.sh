#!/usr/bin/env bash
source /etc/os-release

echo_in() {
  local color="$1"
  local message="${2:-}"
  local no_color="\033[0m"
  local color_code

  case $color in
    #green)  color_code="\033[38;2;0;255;0;48;2;0;0;0m" ;;
    #red)    color_code="\033[38;2;255;30;30;48;2;0;0;0m" ;;
    #blue)   color_code="\033[38;2;0;100;255;48;2;0;0;0m" ;;
    #yellow) color_code="\033[38;2;255;255;0;48;2;0;0;0m" ;;
    #*)      color_code="\033[0m" ;;
    green)  color_code=$(tput setaf 2) ;;
    red)    color_code=$(tput setaf 1) ;;
    blue)   color_code=$(tput setaf 4) ;;
    yellow) color_code=$(tput setaf 3) ;;
    *)      color_code=$(tput sgr0) ;;
  esac

  if [[ -n "$message" ]]; then
    echo -e "${color_code}${message}${no_color}"
  else
    while IFS= read -r line; do
      echo -e "${color_code}${line}${no_color}"
    done
  fi
}

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
_prompt_overwrite() {
  local source="$1"
  local target="$2"

  echo_in yellow "Target already exists and is not linked to source:"
  echo_in yellow "  Target: $target"
  echo_in yellow "  Source: $source"
  read -p "Do you want to overwrite it? [y/N]: " response
  case "$response" in
    [yY][eE][sS]|[yY])
      rm -rf "$target"
      ln -s "$source" "$target"
      echo_in green "Overwritten and linked: $target → $source"
      ;;
    *)
      echo_in red "Skipped linking $target"
      ;;
  esac
}

_prompt_create_dir_or_link_dir() {
  local source="$1"
  local target="$2"

  echo_in yellow "Target does not exist and source is a directory:"
  echo_in yellow "  Source: $source"
  echo_in yellow "  Target: $target"
  echo_in yellow "How would you like to proceed?"
  echo "  [1] Link entire directory (symlink $target → $source)"
  echo "  [2] Create target directory and link contents"
  echo "  [3] Skip"

  read -p "Choose an option [1/2/3]: " choice
  case "$choice" in
    1)
      # we still want to force the linking, as dangling links count as non-existent files
      ln -sf "$source" "$target"
      echo_in green "Linked directory: $target → $source"
      ;;
    2)
      mkdir "$target"
      _link_files_in_dir "$source" "$target"
      ;;
    *)
      echo_in red "Skipped linking $target"
      ;;
  esac
}

_link_file_or_dir() {
  local source="$1"
  local target="$2"

  # target does not exist and source is regular file
  if [ ! -e "$target" ] && [ -f "$source" ]; then
    # we still want to force the linking, as dangling links count as non-existent files
    ln -sf "$source" "$target"
    # target does not exist and source is a directory
  elif [ ! -e "$target" ] && [ -d "$source" ]; then
    _prompt_create_dir_or_link_dir "$source" "$target"
    # target already points to source
  elif [ "$(realpath "$target")" == "$(realpath "$source")" ]; then
    return 0
    # target is a dir and source is a dir 
  elif [ -d "$target" ] && [ -d "$source" ]; then
    _link_files_in_dir "$source" "$target"
    # target is a file regular file
  elif [ -f "$target" ]; then 
    _prompt_overwrite "$source" "$target"
  else
    echo_in red "Something went horribly wrong while linking."
    echo_in red "target: $target"
    echo_in red "source: $source"
    exit 1
  fi
}

_link_files_in_dir() {
  local source_dir="$1"
  local target_dir="${2:-$HOME}"

  if [ ! -d "$source_dir" ]; then
    echo_in red "Error: $source_dir does not exist."
    return 1
  fi

  source_dir="$(realpath "$source_dir")"

  mapfile -t source_children < <(find "$source_dir" -mindepth 1 -maxdepth 1)

  for source_child in "${source_children[@]}"; do
    local target_child="$target_dir/$(basename "$source_child")"
    _link_file_or_dir "$source_child" "$target_child"
  done
}

_link_config_dirs() {
  local config_dirs="$1"

  for dir in $config_dirs; do
    echo_in blue "Linking: $dir"
    _link_files_in_dir "$dir"
    echo_in green "Done linking: $dir"
  done
}

_is_set() {
  [ "$(type -t $1)" == function ]
}

install() {
  # pre install command
   _is_set pre_install_command && pre_install_command

  # native packages
  local native_install_command="${NATIVE_INSTALL[$ID]} ${packages[$ID]}"
  local native_install_check="${NATIVE_INSTALL_CHECK[$ID]} ${packages[$ID]}"
  if [ -n "${packages[$ID]}" ]; then
    _install ${name:-"${packages[$ID]}"} "$native_install_command" "$native_install_check"
  fi

  # custom installation
  if _is_set custom_install_check && _is_set custom_install_command; then
    _install ${name:-undefined} custom_install_command custom_install_check
  fi

  # linking dotfiles
  _link_config_dirs "$config_dirs"

  # post install command
  _is_set post_setup_command && post_setup_command

  unset name
  unset config_dirs
  unset packages[$ID]
  unset -f post_install_command
  unset -f pre_install_command
  unset -f custom_install_command
  unset -f custom_install_check
}


declare -A packages
