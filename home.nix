{ config, pkgs, ... }:

{
  # Default version for programs that can't update automatically
  home.stateVersion = "25.05";

  # User specific
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";
  xdg.cacheHome = builtins.getEnv "XDG_CACHE_HOME";

  # Let home manager install and manage itself.
  programs.home-manager.enable = true;

  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  
    plugins = with pkgs.vimPlugins; [
      telescope-nvim
      which-key-nvim
      vim-nix
    ];
  
    extraConfig = ''
      set number
      lua << EOF
        require("telescope").setup{}
      EOF
    '';
  };

  # ZSH
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -lh";
      g = "git";
    };

    initContent = ''
      export PATH="$HOME/bin:$PATH"
      bindkey '^R' history-incremental-search-backward
    '';
  };
}

