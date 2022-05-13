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
  ];

  nixpkgs.config.allowUnfree = true;

}
