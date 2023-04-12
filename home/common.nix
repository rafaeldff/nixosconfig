{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  #home.username = "rafael";
  #home.homeDirectory = "/home/rafael";

  imports = [
    ./base-packages.nix
    ./utils-packages.nix
    ./applications-packages.nix
    ./dev-packages.nix
    #XXX docker-packages
    ./k8s.nix
    ./xmonad-environment-packages.nix
    ./xmonad-settings.nix
    ./shell.nix
  ];

  nixpkgs.config.allowUnfree = true;
  manual.manpages.enable = false;

  home = {
    keyboard = {
      layout = "us";
      variant = "intl";
      options = ["terminate:ctrl_alt_bksp" "ctrl:nocaps"];
    };
    sessionPath = ["$HOME/.local/bin:$PATH" "$HOME/.cargo/bin:$PATH" "$HOME/bin"];
  };
}
