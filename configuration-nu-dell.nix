# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, ... }:

let
  #pkgs = (fetchGit {
    #name = "rafaeldff-nixos-2020.09";
    #url = https://github.com/rafaeldff/nixpkgs.git;
    #ref = "refs/heads/nixos-20.09";
    #rev = "20f316c5b4c26c9945f8fca70ca4a51a1df42c20";
  #});
in
{
  #nixpkgs.pkgs = import "${pkgs}" {
    #inherit (config.nixpkgs) config;
  #};

  #nix.nixPath = [
    #"nixpkgs=${pkgs}"
    #"nixos-config=/etc/nixos/configuration.nix"
  #];


  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Base version of kernel and the OS
      ./platform.nix

      # Mac hardware specific tuning (change for different hardware)
      ./nu-dell.nix

      # How to configure networking (change if you want gnome to take care of it) 
      ./netmanager.nix
      
      # vpn
      ./vpn.nix

      # Lots of packages!
      ./base-packages.nix
      ./xmonad-environment-packages.nix
      ./utils-packages.nix
      ./applications-packages.nix
      ./dev-packages.nix
      ./docker-packages.nix
      ./k8s.nix

      # XMonad/X settings
      ./xmonad-settings.nix 
      ./appearance.nix
      ./shell.nix
      ./security.nix
     
      # host/user specific settings:
      ./custom-nu-dell.nix

      # nubank
      ./nu.nix

      # locale stuff
      #./de.nix
      ./brasil.nix

      # system options (systemd, journald, etc)
      ./system.nix
    ];
}
