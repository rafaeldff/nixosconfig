{config, pkgs, ...}:

{
  # kernel version (need post 4.2 for better mac compatibility)
  boot.kernelPackages =  pkgs.linuxPackages_4_4;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "15.09";
  
  nixpkgs.config.allowUnfree = true;
}
