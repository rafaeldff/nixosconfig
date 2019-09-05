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
    xlsfonts
    ctags
    zip

    # networking
    mtr
    ldns
    ];
}

