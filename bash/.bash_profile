
if [ -d $HOME/.bash_profile.d ]
then
    for f in $HOME/.bash_profile.d/*.sh; do
       source $f
    done
fi
