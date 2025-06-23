source backman-prototype.sh

declare -A pkgs

name=basics
pkgs[ubuntu]="curl wget less unzip zip python3 python3-venv silversearcher-ag"
pkgs[arch]="curl wget less unzip zip python the_silver_searcher"
construct_installer name=$name native_packages="${pkgs[$ID]}"
eval "${installer[$name]}"

name=vim
pkgs[ubuntu]="vim-gtk3"
pkgs[arch]="gvim"
vim_post_link() {
	vim -c 'PlugInstall' -c 'qa!'
	vim -c 'CocInstall coc-pyright' -c 'qa!'
	vim -c 'CocInstall coc-rust-analyzer' -c 'qa!'
}
construct_installer name=$name native_packages="${pkgs[$ID]}" post_link_command=vim_post_link config_dir=$name
eval "${installer[$name]}"

name=starship
starship_install() {
  echo "Downloading starship..."
  curl -sS https://starship.rs/install.sh | sh
}
starship_check() {
  command -v starship
}
construct_installer name=$name custom_install_command=starship_install custom_install_check=starship_check config_dir=$name
eval "${installer[$name]}"

name=bash
construct_installer name=$name config_dir=$name
eval "${installer[$name]}"

name=zsh
construct_installer name=$name config_dir=$name native_packages=$name
eval "${installer[$name]}"


name=konsole
konsole_post_link() {
    if ! command -v kwriteconfig6 &> /dev/null;then
        kconfigcmd=kwriteconfig5
    fi
    $kconfigcmd --file konsolerc --group "Desktop Entry" --key "DefaultProfile" "dotconfig.profile"
    $kconfigcmd --file konsolerc --group "MainWindow" --group "Toolbar sessionToolbar" --key "IconSize" "16"
    $kconfigcmd --file konsolerc --group "Toolbar sessionToolbar" --key "IconSize" "16"
    $kconfigcmd --file konsolerc --group "UiSettings" --key "ColorScheme" "Breeze Dark"
    $kconfigcmd --file konsolerc --group "UiSettings" --key "WindowColorScheme" "Breeze Dark"
    $kconfigcmd --file konsolerc --group "TabBar" --key "CloseTabButton" "None"
    $kconfigcmd --file konsolerc --group "TabBar" --key "TabBarVisibility" "AlwaysHideTabBar"
}
construct_installer name=$name config_dir=$name native_packages=$name post_link_command=konsole_post_link
eval "${installer[$name]}"


name=gtk
construct_installer name=$name config_dir=$name
eval "${installer[$name]}"

name=tmux
construct_installer name=$name config_dir=$name native_packages=$name
eval "${installer[$name]}"

name=emacs
construct_installer name=$name config_dir=$name native_packages=$name
eval "${installer[$name]}"
