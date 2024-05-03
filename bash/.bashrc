GREEN='\033[0;32m'
NO_COLOR='\033[0m'

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# history file
HISTSIZE=100000
HISTFILESIZE=-1
HISTTIMEFORMAT=`echo -e $GREEN[0m[%F %T] $NO_COLOR`
# [ \t]* ignores stuff with space in front
HISTIGNORE="ls:ls -l:pwd:clear:ll:la:ls -al:[ \t]*"
# on exit append to histfile instead of overwriting
shopt -s histappend


# colors, colors, colors
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# mis aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# this needs to be at the end, i think
eval "$(starship init bash)"
