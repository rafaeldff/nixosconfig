{ config, pkgs, ... }:

{
  home.packages =
    with pkgs; [
    termite
    alacritty
    haskellPackages.xmobar
    dmenu
    rxvt_unicode
    xlockmore
    ];
}

