#!/usr/bin/env bash
source jichu.sh

###################
name=basics
###################
packages[ubuntu]="curl wget less unzip zip python3 python3-venv silversearcher-ag python3 python3-venv dolphin"
packages[arch]="curl wget less unzip zip python the_silver_searcher python dolphin"
install

###################
name=basics2
###################
packages[arch]="numlockx tree thunar wireshark-qt sshuttle spectacle gthumb flameshot nodejs thunar-archive-plugin mplayer wqy-zenhei irssi filezilla"
packages[ubuntu]="numlockx tree thunar wireshark sshuttle kde-spectacle gthumb flameshot nodejs thunar-archive-plugin mplayer fonts-wqy-zenhei irssi filezilla"
install

###################
name=basics3
###################
packages[arch]="code chromium pavucontrol gnome sshfs cmake"
packages[ubuntu]="code chromium-browser pavucontrol gnome sshfs cmake"
install

###################
name=starship
###################
custom_install_command() {
	curl -sS https://starship.rs/install.sh | sh
}
custom_install_check() {
	command -v starship &> /dev/null
}
config_dirs="starship"
install

###################
name=shell
###################
# bat and fd for fzf in fish
packages[arch]="bash-completion pinentry-curses fd bat"
packages[ubuntu]="bash-completion pinentry-curses fd-find bat"
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
# now done for each program individually: gpg and ssh
#post_install_command() {
#  sudo update-alternatives --set pinentry /usr/bin/pinentry-curses
#}
config_dirs="bash zsh fzf"
install

###################
name=nvim
###################
packages[arch]="xclip"
packages[ubuntu]="xclip"
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

# OSC52 support soon! https://bugs.kde.org/show_bug.cgi?id=372116
# but not soon enough, wezterm for now? besides the config sucks
###################
name=konsole
###################
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

###################
name=vim
###################
config_dirs=vim
packages[ubuntu]=vim
packages[arch]=vim
#post_install_comand(){
#  vim -c 'PlugInstall' -c 'qa!'
#  vim -c 'CocInstall coc-pyright' -c 'qa!'
#  vim -c 'CocInstall coc-rust-analyzer' -c 'qa!'
#}
install

###################
name=tmux
###################
config_dirs=$name
packages[ubuntu]=$name
packages[arch]=$name
install

###################
name=i3
###################
packages[arch]="xorg-server i3-wm i3lock jgmenu nitrogen xcape i3blocks network-manager-applet dmenu xorg-xinit autorandr ttf-font-awesome arandr tk python xorg-xrandr picom blueman"
packages[ubuntu]="i3 i3lock jgmenu nitrogen xcape i3blocks network-manager-gnome suckless-tools xinit autorandr fonts-font-awesome arandr python3-tk python3 x11-xserver-utils picom blueman" 
config_dirs="i3 i3blocks fonts xinit autorandr picom"
install

###################
name=emacs
###################
config_dirs="emacs spacemacs"
packages[ubuntu]=$name
packages[arch]=$name
install

###################
name=themes
###################
config_dirs=gtk
install

###################
name=fcitx5
###################
packages[arch]="fcitx5 fcitx5-qt fcitx5-gtk fcitx5-chinese-addons noto-fonts-cjk"
packages[ubuntu]="fcitx5 fcitx5-chinese-addons fonts-noto-cjk fonts-noto-cjk-extra im-config"
install 

###################
name=lazygit
###################
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

###################
name=rust
###################
custom_install_command() {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}
custom_install_check() {
  command -v rustc > /dev/null
}
install

#OSC52 support soon? https://github.com/wezterm/wezterm/pull/6239/files
###################
name=wezterm
###################
#custom_install_command() {
#curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
#echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
#sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
#sudo apt update
#sudo apt install wezterm
#}
config_dirs=wezterm
install

###################
name=rust
###################
config_dirs=ruby
install
