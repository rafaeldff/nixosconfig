{ config, pkgs, ... }:

{
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      corefonts
      inconsolata
      ubuntu-sans
      ubuntu-sans-mono
    ];
  };
}
