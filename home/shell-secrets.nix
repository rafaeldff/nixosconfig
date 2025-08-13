{ config, pkgs, ... }:

{
  home.sessionVariables = {
    # Ensure secret-tool is available in PATH
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.bash.bashrcExtra = builtins.readFile ./secrets-functions.sh;

  programs.zsh.initExtra = builtins.readFile ./secrets-functions.sh;
}
