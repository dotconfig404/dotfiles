# when running bash from scripts, dont run bashrc
case $- in
    *i*) ;;
      *) return;;
esac

# we have most configuration in bash_profile
source ~/.bash_profile

# this needs to be at the end, i think
eval "$(starship init bash)"

. "$HOME/.cargo/env"

# pnpm
export PNPM_HOME="/home/$USER/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# opencode
export PATH=/home/frras6571/.opencode/bin:$PATH
