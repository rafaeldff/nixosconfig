{ config, pkgs, ... }:

{
  # auto-mount flash drives
  services.udisks2.enable = true;
  
  # xserver
  services.xserver = {
    enable = true;

    desktopManager.default = "none";
    desktopManager.xterm.enable = false;
    displayManager = {
      desktopManagerHandlesLidAndPower = false;
      lightdm.enable = true;
      sessionCommands = ''
        ${pkgs.xlibs.xsetroot}/bin/xsetroot -cursor_name left_ptr
      '';
    };
    windowManager.default = "xmonad";
    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;

    xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";
  };
}

