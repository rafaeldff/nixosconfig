{ config, pkgs, ... }:

let
  #spotifyVersion = "1.0.36.120.g536a862f-20";
  spotifyVersion =  "1.0.57.474.gca9c9538-30";
in
{
  environment.systemPackages =
    with pkgs; [
    vimHugeX
    chromium
    firefox
    (lib.overrideDerivation spotify (attrs: {
       name = "spotify-${spotifyVersion}";
      src =
        fetchurl {
          url = "http://repository-origin.spotify.com/pool/non-free/s/spotify-client/spotify-client_${spotifyVersion}_amd64.deb";
          sha256 = "fe46f2084c45c756bee366f744d2821d79e82866b19942e30bb2a20c1e597437";
        };
    }))
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

