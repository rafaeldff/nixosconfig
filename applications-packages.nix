{ config, pkgs, ... }:

let
  spotifyVersion  = "1.0.77.338.g758ebd78-41";
in
{
  environment.systemPackages =
    with pkgs; [
    vim-full
    chromium
    firefox-bin
    #(lib.overrideDerivation spotify (attrs: {
       #name = "spotify-${spotifyVersion}";
      #src =
        #fetchurl {
          #url = "http://repository-origin.spotify.com/pool/non-free/s/spotify-client/spotify-client_${spotifyVersion}_amd64.deb";
          #sha256 = "1971jc0431pl8yixpl37ryl2l0pqdf0xjvkg59nqdwj3vbdx5606";
        #};
    #}))
    #spotify
    evince
    vlc
    libreoffice
    #atom
    ];

  #nixpkgs.config = {
    #chromium = {
      #enablePepperPDF = true;
    #};
  #};
}

