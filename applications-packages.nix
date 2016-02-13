{ config, pkgs, ... }:

{
  environment.systemPackages =
    with pkgs; [
    chromium
    firefox
    spotify
    ];

  nixpkgs.config = {
    chromium = {
      enablePepperFlash = true;
      enablePepperPDF = true;
    };
  };
}

