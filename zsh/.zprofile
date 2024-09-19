# if dir exists and if string returned from ls -A (list without . and ..) is not null, 
# then source all the output from cat
if [ -d "$HOME/.zprofile.d" ] && [ ! -z "$(ls -A $HOME/.zprofile.d)" ]; then
    source <(cat $HOME/.zprofile.d/*.zsh)
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# history file location
HISTFILE=~/.zsh_history
# x lines in history
SAVEHIST=100000
# unlimited history file size
HISTFILESIZE=-1
# [ \t]* ignores stuff with space in front
HISTIGNORE="ls:ls -l:pwd:clear:ll:la:ls -al:[ \t]*"
# share history between different zsh sessions
setopt share_history
# wrties history after each command and allows multiple zsh sessions
setopt inc_append_history
# history based search with arrow keys
# arrow keys may have different keycodes, check using Ctrl+V and then the key
autoload -U compinit && compinit
bindkey "^[OA" history-search-backward
bindkey "^[OB" history-search-forward

# https://stackoverflow.com/a/54048138
# potentially check link again if completion becomes too slow
fpath=(~/.zshrc.d/completions $fpath)
#autoload -U compinit && compinit
zstyle ':completion:*' menu select=2

# colors, colors, colors
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# mis aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# trash setup
trm() {
  mv "$1" ~/.trash
}

export XMODIFIERS=@im=fcitx5
export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
