{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;
  # networking.wireless.enable = false;
  # networking.firewall.enable = false;
  # networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so look for interface config on
  # hardware-specific config file (e.g. nu-dell.nix)
  networking.useDHCP = false;

}
