{ config, pkgs, ... }:

let
  spotifyVersion = "1.0.36.120.g536a862f-20";
in
{
  environment.systemPackages =
    with pkgs; [
    chromium
    firefox
    (lib.overrideDerivation spotify (attrs: {
       name = "spotify-${spotifyVersion}";
      src =
        fetchurl {
          url = "http://repository-origin.spotify.com/pool/non-free/s/spotify-client/spotify-client_${spotifyVersion}_amd64.deb";
          sha256 = "03r4hz4x4f3zmp6dsv1n72y5q01d7mfqvaaxqvd587a5561gahf0";
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

