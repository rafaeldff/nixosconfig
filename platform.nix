{config, pkgs, ...}:

{
  # kernel version (need post 4.2 for better mac compatibility)
  # boot.kernelPackages =  pkgs.linuxPackages_latest;

  # The NixOS release to be compatible with for stateful data such as databases.
  # system.stateVersion = "15.09";
  
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.oraclejdk.accept_license = true;
}
