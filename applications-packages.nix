{ config, pkgs, ... }:

let
  #spotifyVersion = "1.0.59.395.ge6ca9946-18";
  spotifyVersion  = "1.0.69.336.g7edcc575-39";
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
          sha256 = "0bh2q7g478g7wj661fypxcbhrbq87zingfyigg7rz1shgsgwc3gd";
        };
    }))
    #spotify
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

