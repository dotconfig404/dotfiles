# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=100000
setopt autocd extendedglob nomatch notify
unsetopt beep
bindkey -v

zstyle :compinstall filename '/home/dotconfig/.zshrc'

autoload -Uz compinit
compinit

# prompt 

autoload -Uz vcs_info
precmd_vcs_info() {
	  vcs_info
  }
  precmd_functions+=(precmd_vcs_info)
  setopt prompt_subst

  export PROMPT="%F{196}%B%(?..?%? )%b%f%F{117}%2~%f%F{245} %#%f "
  export RPROMPT="%B\$vcs_info_msg_0_%f%b"

  zstyle ':vcs_info:git:*' formats '%F{240}%b %f %F{237}%r%f'
  zstyle ':vcs_info:*' enable git



alias ll='ls -al --color'
alias l='ls --color'
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward


alias py=python3
alias ins='sudo pacman -S'
alias que='pacman -Ss'
alias rem='sudo pacman -Rns'
alias upd='sudo pacman -Syyu'

source ~/.zsh/*.zsh

setopt share_history

function work() {
    cd ~/Desktop/
    if [ "$1" = "-lc" ]; then
        cd leetcode
        if [ -d "$2" ];then
            cd "$2"
            return 0
        else
            mkdir "$2"
            cd "$2"
            funName=`grep -oP '.*(?=\(.)' <<< $3`
            cat > "$funName.py" << EOL
input = [[]]

class Solution:
    def ${3}:

        return None

if __name__ == '__main__':
    s = Solution
    for i in range(len(input)):
        print(s.${funName}(s,*input[i]))
EOL
            return 0
        fi
    elif [ "$1" = "-rl" ];then
        cd rosalind
        if [ -d "$2" ];then
            cd "$2"
            return 0
        fi
        mkdir "$2"
        cd "$2"
        funName=`grep -oP '.*(?=\(.)' <<< $3`
        cat > "$funName.py" << EOL
input = [[]]

class Solution:
    def ${3}:

        return None

if __name__ == '__main__':
    s = Solution
    for i in range(len(input)):
        print(s.${funName}(s,*input[i]))
EOL
        return 0
        

    elif [ ! -d "$1" ]; then
      mkdir "$1"
    fi
    cd "$1"
}



function venv() {
    VENV=".venv"
    if [[ ! -d $VENV ]]; then
        python3 -m venv $VENV
    fi
    source $VENV/bin/activate
}

alias i3c="vim ~/.config/i3/config"
alias hlc="vim ~/.config/herbstluftwm/autostart"
alias dotfiles='/usr/bin/git --git-dir=/home/dotconfig/.dotfiles/ --work-tree=/home/dotconfig'
