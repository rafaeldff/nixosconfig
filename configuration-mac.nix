# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Base version of kernel and the OS
      ./platform.nix

      # Mac hardware specific tuning (change for different hardware)
      ./mac.nix

      # How to configure networking (change if you want gnome to take care of it) 
      ./netmanager.nix

      # Lots of packages!
      ./base-packages.nix
      ./xmonad-environment-packages.nix
      ./utils-packages.nix
      ./applications-packages.nix
      ./dev-packages.nix
      ./docker-packages.nix

      # XMonad/X settings
      ./xmonad-settings.nix 
      ./appearance.nix
      ./shell.nix
      ./security.nix
     
      # host/user specific settings:
      ./custom-mac.nix
    ];
}
