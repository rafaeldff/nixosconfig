{ config, pkgs, ... }:

{
  home.packages =
    with pkgs; [
    vim_configurable
    chromium #XXX
    # firefox-bin #XXX
    #spotify
    evince
    vlc
    libreoffice
    ];

}

