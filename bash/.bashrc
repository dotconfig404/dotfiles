# when running bash from scripts, dont run bashrc
case $- in
    *i*) ;;
      *) return;;
esac


# if dir exists and if string returned from ls -A (list without . and ..) is not null, 
# then source all the output from cat
if [ -d "$HOME/.bashrc.d" ] && [ ! -z "$(ls -A $HOME/.bashrc.d)" ]; then
    source <(cat $HOME/.bashrc.d/*.sh)
fi

# this needs to be at the end, i think
eval "$(starship init bash)"
