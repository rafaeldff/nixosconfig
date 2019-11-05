{ config, pkgs, ... }:

{
  networking.hostName = "rffnix"; # Define your hostname.
  networking.extraHosts ="127.0.0.1 rffnix";
  networking.networkmanager.insertNameservers = ["8.8.8.8" "8.8.4.4"];


  ## Users
  # users.mutableUsers = true;
  users.extraUsers.guest = {
    isNormalUser = true;
    name = "rafael";
    group = "users";
    uid = 1000;
    extraGroups = ["wheel" "networkmanager" "docker"];
    createHome = true;
    home = "/home/rafael";
  };
}
