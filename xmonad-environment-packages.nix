{ config, pkgs, ... }:

{
  environment.systemPackages =
    with pkgs; [
    termite
    alacritty
    haskellPackages.xmobar
    dmenu
    rxvt_unicode
    xlockmore
    ];
}

