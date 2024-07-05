# no need to run this zshrc when running zsh from scripts
[[ $- != *i* ]] && return

# source all zsh files in .zshrc.d
if [ -d $HOME/.zshrc.d ]
then
    for f in $HOME/.zshrc.d/*.zsh; do
       source $f
    done
fi

# needs to be at the end
eval "$(starship init zsh)"
