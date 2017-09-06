{ config, pkgs, ... }:

let
  #spotifyVersion =  "1.0.57.474.gca9c9538-30";
  spotifyVersion =  "1.0.59.395.ge6ca9946-18";
in
{
  environment.systemPackages =
    with pkgs; [
    vimHugeX
    chromium
    firefox
    #(lib.overrideDerivation spotify (attrs: {
       #name = "spotify-${spotifyVersion}";
      #src =
        #fetchurl {
          #url = "http://repository-origin.spotify.com/pool/non-free/s/spotify-client/spotify-client_${spotifyVersion}_amd64.deb";
          #sha256 = "8fbe821fd516f5cd77eb2d5085e5acd8f1852b97f7b7294846fcc57b810ef515";
        #};
    #}))
    spotify
    evince
    vlc
    libreoffice
    atom
    ];

  nixpkgs.config = {
    chromium = {
      enablePepperPDF = true;
    };
  };
}

