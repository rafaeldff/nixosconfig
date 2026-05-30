{ config, pkgs, ... }:

{
  home.packages =
    with pkgs; [
    #alacritty # commented out because it has to be installed from sources in ubuntu
    haskellPackages.xmobar
    dmenu
    xterm
    xlockmore
    ];
}

