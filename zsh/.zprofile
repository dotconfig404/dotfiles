
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
#
# if dir exists and if string returned from ls -A (list without . and ..) is not null, 
# then source all the output from cat
if [ -d "$HOME/.zprofile.d" ] && [ ! -z "$(ls -A $HOME/.zprofile.d)" ]; then
    source <(cat $HOME/.zprofile.d/*.zsh)
fi

# history file location
HISTFILE=$HOME/.zsh_history
# x lines in history
SAVEHIST=100000
# unlimited history file size
HISTFILESIZE=-1
# we need this option otherwise history based completion won't work (or rather, it'll work only for a few entries)
HISTSIZE=9999
# [ \t]* ignores stuff with space in front
#this is only for bash, we need HISTORY_IGNORE
#HISTIGNORE="ls:ls -l:pwd:clear:ll:la:ls -al:[ \t]*"
HISTORY_IGNORE="(ls|ls -l|pwd|clear|ll|la|ls -al|[ \t]*)"
# share history between different zsh sessions
setopt share_history
# wrties history after each command and allows multiple zsh sessions
setopt inc_append_history
# extended history includes time and status code in fron of the command
setopt extended_history
# history based search with arrow keys
# arrow keys may have different keycodes, check using Ctrl+V and then the key
bindkey "^[OA" history-substring-search-up
bindkey "^[OB" history-substring-search-down

# https://stackoverflow.com/a/54048138
# potentially check link again if completion becomes too slow
#fpath=(~/.zshrc.d/completions $fpath)
##autoload -U compinit && compinit
#zstyle ':completion:*' menu select=2

# colors, colors, colors
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# mis aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias vim='nvim'
