{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;
  networking.wireless.enable = false;
  networking.firewall.enable = false;
  #networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];
}
