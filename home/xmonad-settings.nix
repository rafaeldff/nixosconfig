{ config, pkgs, ... }:

{

  xsession = {
    enable = true;

    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;

    #xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";
  };
}

