
if [ -d $HOME/.zprofile.d ]
then
    for f in $HOME/.zprofile.d/*.zsh; do
       source $f
    done
fi
