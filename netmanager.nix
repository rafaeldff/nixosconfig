{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;
  networking.wireless.enable = false;
  networking.firewall.enable = false;
}
