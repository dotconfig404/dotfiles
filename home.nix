{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      hello
    ];

    username = builtins.getEnv "USER";
    homeDirectory = builtins.getEnv "HOME";

    stateVersion = "23.11";
  };
}
