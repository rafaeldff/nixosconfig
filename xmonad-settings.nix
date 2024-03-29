{ config, pkgs, ... }:

{
  # xserver
  services.xserver = {
    enable = true;

    #desktopManager.default = "none";
    displayManager.defaultSession = "none+xmonad";
    desktopManager.xterm.enable = false;
    displayManager = {
      lightdm.enable = true;
      sessionCommands = ''
        ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr
        echo "in nixos sessionCommands" | systemctl-cat -t debug_init
        source $HOME/.profile
      '';
    };
    #windowManager.default = "xmonad";
    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;

    xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";
  };
}

