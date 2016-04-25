{ config, pkgs, ... }:

{
  environment.systemPackages =
    with pkgs; [
    chromium
    firefox
    spotify
    evince
    vlc
    libreoffice
    ];

  nixpkgs.config = {
    chromium = {
      enablePepperFlash = true;
      enablePepperPDF = true;
    };
  };
}

