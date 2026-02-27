{config, pkgs, ...}:

{
  # kernel version (used to be latest for net and audio drivers for fw laptop)
  # set to 6_18 because 6_19 (latest as of last run) was incompatible with VirtualBox
  boot.kernelPackages =  pkgs.linuxPackages_6_18;

  # The NixOS release to be compatible with for stateful data such as databases.  # system.stateVersion = "15.09";
  
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.oraclejdk.accept_license = true;

  # We were running out of space on the /boot partition, so had to limit the number of linked configurations
  boot.loader.systemd-boot.configurationLimit = 3;  # or 3 if it fits
}
