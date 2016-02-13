{ config, pkgs, ... }:

{
  environment.systemPackages =
    with pkgs; [
    htop
    tree
    ack
    file
    feh
    scrot
    xclip
    gawk
    jq
    unzip
    sl
    xlsfonts
    ctags
    ];
}

