{ config, pkgs, ... }:

let
  spotifyVersion = "1.0.36.120.g536a862f-20";
in
{
  environment.systemPackages =
    with pkgs; [
    vimHugeX
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

