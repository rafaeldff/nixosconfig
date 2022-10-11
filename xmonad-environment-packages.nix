{ config, pkgs, ... }:

{
  environment.systemPackages =
    with pkgs; [
    termite
    alacritty
    haskellPackages.xmobar
    dmenu
    xterm
    xlockmore
    ];
}

