
# when running bash from scripts, dont run bashrc
#case $- in
#    *i*) ;;
#      *) return;;
#esac

# every file in bashrc.d will be sourced into this file
BASHRC_D=~/.bashrc.d
if [ -d $BASHRC_D ]
then
    for f in $BASHRC_D/*.sh
    do
       source $f
    done
fi

# history file
GREEN='\033[0;32m'
NO_COLOR='\033[0m'
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
alias py='python3'
# pretty docker ps
dps()  {
  docker ps $@ | awk '
  NR==1{
    FIRSTLINEWIDTH=length($0)
    IDPOS=index($0,"CONTAINER ID");
    IMAGEPOS=index($0,"IMAGE");
    COMMANDPOS=index($0,"COMMAND");
    CREATEDPOS=index($0,"CREATED");
    STATUSPOS=index($0,"STATUS");
    PORTSPOS=index($0,"PORTS");
    NAMESPOS=index($0,"NAMES");
    UPDATECOL();
  }
  function UPDATECOL () {
    ID=substr($0,IDPOS,IMAGEPOS-IDPOS-1);
    IMAGE=substr($0,IMAGEPOS,COMMANDPOS-IMAGEPOS-1);
    COMMAND=substr($0,COMMANDPOS,CREATEDPOS-COMMANDPOS-1);
    CREATED=substr($0,CREATEDPOS,STATUSPOS-CREATEDPOS-1);
    STATUS=substr($0,STATUSPOS,PORTSPOS-STATUSPOS-1);
    PORTS=substr($0,PORTSPOS,NAMESPOS-PORTSPOS-1);
    NAMES=substr($0, NAMESPOS);
  }
  function PRINT () {
    print ID NAMES IMAGE STATUS CREATED COMMAND PORTS;
  }
  NR==2{
    NAMES=sprintf("%s%*s",NAMES,length($0)-FIRSTLINEWIDTH,"");
    PRINT();
  }
  NR>1{
    UPDATECOL();
    PRINT();
  }' | less -FSX;
}
dpsa() { dps -a $@; }

# hack for now, fix kbd later
#setxkbmap eu

# taken from arch wiki
# solution for weird ssh issue upon entering backspace while connected via ssh
#[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh" ]

set -o vi

# Disable the bell
if [[ $iatest > 0 ]]; then bind "set bell-style visible"; fi

# this needs to be at the end, i think
eval "$(starship init bash)"
