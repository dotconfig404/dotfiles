# no need to run this zshrc when running zsh from scripts
[[ $- != *i* ]] && return

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

# colors, colors, colors
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# mis aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

if [ -d $HOME/.zshrc.d ]
then
    for f in $HOME/.zshrc.d/*.zsh; do
       source $f
    done
fi

# https://stackoverflow.com/a/54048138
# potentially check link again if completion becomes too slow
fpath=(~/.zshrc.d/completions $fpath)
#autoload -U compinit && compinit
zstyle ':completion:*' menu select=2

# needs to be at the end
eval "$(starship init zsh)"
