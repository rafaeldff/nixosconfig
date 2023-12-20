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
    bat
    dutree
    pv

    #sound
    pavucontrol

    # networking
    mtr
    ldns

    # sec
    _1password
    ];

  programs.ssh.startAgent = true;
  services.gnome.gnome-keyring.enable = true;
}


