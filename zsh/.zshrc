# no need to run this zshrc when running zsh from scripts
[[ $- != *i* ]] && return

# if dir exists and if string returned from ls -A (list without . and ..) is not null, 
# then source all the output from cat
if [ -d "$HOME/.zshrc.d" ] && [ ! -z "$(ls -A $HOME/.zshrc.d)" ]; then
    source <(cat $HOME/.zshrc.d/*.zsh)
fi

# needs to be at the end
eval "$(starship init zsh)"
