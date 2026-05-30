{ config, pkgs, ... }:

{
  environment.systemPackages =
    with pkgs; [
    alacritty
    haskellPackages.xmobar
    dmenu
    xterm
    xlockmore
    ];
}

