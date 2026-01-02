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
    acpi

    #sound
    pavucontrol

    # networking
    mtr
    ldns

    # sec
    _1password-cli
    ];

  # SSH agent is provided by gnome-keyring (gcr-ssh-agent)
  # programs.ssh.startAgent = true;  # Conflicts with gcr-ssh-agent
  services.gnome.gnome-keyring.enable = true;
}


