{config, pkgs, ...}:

{
  # kernel version — trying 6.19 again (VirtualBox compat issue may be fixed)
  boot.kernelPackages =  pkgs.linuxPackages_latest;

  # The NixOS release to be compatible with for stateful data such as databases.  # system.stateVersion = "15.09";
  
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.oraclejdk.accept_license = true;

  # /boot is 510 MB; each generation is ~22 MB, so 20 fits comfortably (~14% / 67 MB at 3)
  boot.loader.systemd-boot.configurationLimit = 20;
}
