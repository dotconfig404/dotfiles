# no need to run this zshrc when running zsh from scripts
[[ $- != *i* ]] && return

# history file
HISTFILE=~/.zsh_history
SAVEHIST=100000
HISTFILESIZE=-1
# [ \t]* ignores stuff with space in front
HISTIGNORE="ls:ls -l:pwd:clear:ll:la:ls -al:[ \t]*"
# wrties history after each command and allows multiple zsh sessions
setopt SHARE_HISTORY 

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
    for f in $HOME/*.zsh
    do
       source $f
    done
fi

eval "$(starship init zsh)"
