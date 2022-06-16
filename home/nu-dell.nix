{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "rafael";
  home.homeDirectory = "/home/rafael";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./common.nix
    ./nu.nix
  ];

# Various options that are specific for this machine/user.
  #xsession.importedVariables = [
  #    "DBUS_SESSION_BUS_ADDRESS"
  #    "DISPLAY"
  #    #"SSH_AUTH_SOCK" #XXX this was breaking .xprofile initalization
  #    "XAUTHORITY"
  #    "XDG_DATA_DIRS"
  #    "XDG_RUNTIME_DIR"
  #    "XDG_SESSION_ID"
  #  ];

}
