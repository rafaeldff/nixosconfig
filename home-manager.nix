{ config, pkgs, ... }:

{

  users.users.r2 = {
    isNormalUser = true;
    #extraGroups = [ "wheel" "networkmanager" "docker" ]; # Enable ‘sudo’ for the user.
    #createHome = true;
    #uid = 1000;
  };

  home-manager.users.r2 = import ./home/fw.nix;
}
