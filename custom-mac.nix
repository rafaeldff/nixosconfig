{ config, pkgs, ... }:

{
  networking.hostName = "rffnix"; # Define your hostname.
  networking.extraHosts ="127.0.0.1 rffnix";

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

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
