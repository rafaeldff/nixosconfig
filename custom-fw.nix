{ config, pkgs, ... }:

{
  networking.hostName = "fw-rafaelnix"; # Define your hostname.

  #networking.extraHosts ="127.0.0.1 fw-rafaelnix";
  #networking.networkmanager.insertNameservers = ["8.8.8.8" "8.8.4.4"];

  ## Users
  # users.mutableUsers = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rafael = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ]; # Enable ‘sudo’ for the user.
    createHome = true;
    uid = 1000;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "22.05";
}
