#!/usr/bin/env bash
source jichu.sh

name=basics
packages[ubuntu]="curl wget less unzip zip python3 python3-venv silversearcher-ag python3 python3-venv dolphin"
packages[arch]="curl wget less unzip zip python the_silver_searcher python dolphin"
install

name=basics2
packages[arch]="numlockx tree thunar wireshark-qt sshuttle spectacle gthumb flameshot nodejs thunar-archive-plugin mplayer wqy-zenhei irssi filezilla"
packages[ubuntu]="numlockx tree thunar wireshark sshuttle kde-spectacle gthumb flameshot nodejs thunar-archive-plugin mplayer fonts-wqy-zenhei irssi filezilla"
install

name=basics3
packages[arch]="code chromium pavucontrol keychain gnome sshfs"
packages[ubuntu]="code chromium-browser pavucontrol keychain gnome sshfs"
install

name=starship
custom_install_command() {
	curl -sS https://starship.rs/install.sh | sh
}
custom_install_check() {
	command -v starship &> /dev/null
}
config_dirs="starship"
install

name=shell
packages[arch]="bash-completion pinentry-curses"
packages[ubuntu]="bash-completion pinentry-curses"
custom_install_command() {
  [ -d $HOME/gitclones ] || mkdir ~/gitclones
  [ -d $HOME/.local/bin ] || mkdir ~/.local/bin
  git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/gitclones/fzf
  ~/gitclones/fzf/install --bin
  ln -s $HOME/gitclones/fzf/bin/fzf $HOME/.local/bin/
}
custom_install_check() {
  command -v fzf &> /dev/null
}
post_install_command() {
  update-alternatives --set pinentry /usr/bin/pinentry-curses
}
# fzf has custom entry in 
config_dirs="bash zsh fzf"
install

name=git
packages[arch]=git
packages[ubuntu]=git
config_dirs="_private/git"
install

name=nvim
custom_install_command() {
  [ -d $HOME/gitclones ] || mkdir ~/gitclones
  [ -d $HOME/.local/bin ] || mkdir ~/.local/bin
  git clone https://github.com/neovim/neovim $HOME/gitclones/neovim
  cd $HOME/gitclones/neovim
  make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALLL_PREFIX=$HOME/.local/bin
  sudo make install
  cd -
}
custom_install_check() {
  command -v nvim &> /dev/null
}
config_dirs=nvim
install

name=konsole
packages[arch]="konsole kconfig"
packages[ubuntu]="konsole libkf5config-bin"
post_install_command() {
  kconfigcmd=kwriteconfig6
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
config_dirs=konsole
install

name=vim
config_dirs=vim
packages[ubuntu]=vim
packages[arch]=vim
#post_install_comand(){
#  vim -c 'PlugInstall' -c 'qa!'
#  vim -c 'CocInstall coc-pyright' -c 'qa!'
#  vim -c 'CocInstall coc-rust-analyzer' -c 'qa!'
#}
install

name=tmux
config_dirs=$name
packages[ubuntu]=$name
packages[arch]=$name
install


name=i3
packages[arch]="xorg-server i3-wm i3lock jgmenu nitrogen xcape i3blocks network-manager-applet dmenu xorg-xinit autorandr ttf-font-awesome arandr tk python xorg-xrandr picom blueman"
packages[ubuntu]="i3 i3lock jgmenu nitrogen xcape i3blocks network-manager-gnome suckless-tools xinit autorandr fonts-font-awesome arandr python3-tk python3 x11-xserver-utils picom blueman" 
config_dirs="i3 i3blocks fonts xinit autorandr picom"
install

name=emacs
config_dirs=$name
packages[ubuntu]=$name
packages[arch]=$name
install

name=themes
config_dirs=gtk
install

name=fcitx5
packages[arch]="fcitx5 fcitx5-qt fcitx5-gtk fcitx5-chinese-addons noto-fonts-cjk"
packages[ubuntu]="fcitx5 fcitx5-chinese-addons fonts-noto-cjk fonts-noto-cjk-extra im-config"
install 

name=nix
custom_install_command() {
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
    sh -s -- install --nix-build-group-id 3000000 --nix-build-user-id-base 3000000 --no-confirm

    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

}
custom_install_check() {
  command -v nix-env > /dev/null
}
install

name=lazygit
custom_install_command() {
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit.tar.gz
    rm -rf lazygit
}
custom_install_check() {
  command -v lazygit > /dev/null
}
install

name=rust
custom_install_command() {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}
custom_install_check() {
  command -v rustc > /dev/null
}
install

name=home-manager
custom_install_command() {
  nix run home-manager/master -- init --switch .
  sed  -i 's/\.\/home\.nix/\.\/home\.nix \.\/home-general\.nix \.\/confidential\/home-confidential\.nix/g' ./flake.nix
}
custom_install_check() {
  command -v home-manager > /dev/null
}
config_dirs="home-manager confidential/home-manager"
install

name=home-manager-update
custom_install_command() {
  home-manager switch --flake .
}
# lets just always run thsi command
custom_install_check() {
  false
}
install
