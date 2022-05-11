{config, pkgs, ...}:

{
  # kernel version (latest for net and audio drivers for fw laptop)
  boot.kernelPackages =  pkgs.linuxPackages_latest;

  # The NixOS release to be compatible with for stateful data such as databases.  # system.stateVersion = "15.09";
  
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.oraclejdk.accept_license = true;
}
