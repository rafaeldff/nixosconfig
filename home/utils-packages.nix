{ config, pkgs, ... }:

{
  home.packages =
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
    bat
    dutree
    pv

    # networking
    mtr
    ldns

    # sec
    _1password
    libsecret  # Provides secret-tool for Secret Service API access
    ];

  #programs.ssh.startAgent = true; #XXX
  services.gnome-keyring.enable = true;
}


