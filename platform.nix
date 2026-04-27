{config, pkgs, ...}:

{
  # kernel version — trying 6.19 again (VirtualBox compat issue may be fixed)
  boot.kernelPackages =  pkgs.linuxPackages_latest;

  # The NixOS release to be compatible with for stateful data such as databases.  # system.stateVersion = "15.09";
  
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.oraclejdk.accept_license = true;

  # We were running out of space on the /boot partition, so had to limit the number of linked configurations
  boot.loader.systemd-boot.configurationLimit = 3;  # or 3 if it fits
}
