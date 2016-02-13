{ config, pkgs, ... }:

{
  environment.systemPackages =
    with pkgs; [
    termite
    haskellPackages.xmobar
    dmenu
    rxvt_unicode
    xlockmore
    ];
}

