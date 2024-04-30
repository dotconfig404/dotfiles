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
