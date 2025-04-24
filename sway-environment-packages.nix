{ config, pkgs, ... }:

# from https://nixos.wiki/wiki/Sway
{
  environment.systemPackages = with pkgs; [
    alacritty # gpu accelerated terminal
    wayland
    xdg-utils # for opening default programs when clicking links
    glib # gsettings
    dracula-theme # gtk theme
    gnome.adwaita-icon-theme  # default gnome cursors
    swaylock
    swayidle
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    bemenu # wayland clone of dmenu
    mako # notification system developed by swaywm maintainer
    wdisplays # tool to configure displays
    kanshi # set up display profiles
  ];
}

