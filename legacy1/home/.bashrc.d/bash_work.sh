alias cad='cd ~/nobobox/nobotoken/truffle-init'
alias ctd='cd ~/nobobox/unfug/unfug'
alias csd='cd ~/nobobox/ico_smart_contract'
alias truga='rm build/contracts/* && truffle console --network g'
alias trupi='rm build/contracts/* && truffle console --network p'
function saveScriptForLater() {
    cp $1 $HOME/nobobox/scripts/$2
}
export PATH=~/.npm-global/bin:$PATH
function gatest() {
    truffle test $1 --network g
}
function pitest() {
    truffle test $1 --network p
}
#alias dps='docker ps | less -s'
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
