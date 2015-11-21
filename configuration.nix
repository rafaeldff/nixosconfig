# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  ## mac hardware / low-level stuff
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  hardware.enableAllFirmware = true;
  # select the right sound card
  boot.extraModprobeConfig = ''
    options snd_hda_intel enable=0,1
  '';

  boot.kernelPackages =  pkgs.linuxPackages_4_2;

  # Use the gummiboot efi boot loader.
  boot.loader.gummiboot.enable = true;
  boot.loader.gummiboot.timeout = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.cleanTmpDir = true;

  #nixpkgs.config.packageOverrides = super: let self = super.pkgs; in rec
  #{
  #  linux_4_1 = super.linux_4_1.override {
  #    extraConfig = ''
  #      BRCMFMAC_PCIE y
  #      BRCMFMAC_USB  y
  #      BRCMFMAC_SDIO y
  #    '';
  #  };
  #};

  networking.hostName = "rffnix"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.wireless.enable = false;
  networking.firewall.enable = false;

  ## Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  ## Packages
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    #bare minimum
    wget
    git
    dropbox
    rxvt_unicode

    # browsers
    chromium
    firefox
    
    # fonts
    xlsfonts

    # vim
    vimNox
    ctags
   
    # utils
    htop
    tree
    ack
    file

    # dev
    oraclejdk8
    idea.idea-community

    # networking
    openvpn

    # xmonad
    termite
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # docker
  virtualisation.docker.enable = true; 

  # auto-mount flash drives
  services.udisks2.enable = true;

  ## Appearance (X, xmonad, fonts, etc.)
  services.xserver = {
    enable = true;

    desktopManager.default = "none";
    desktopManager.xterm.enable = false;
    displayManager = {
      desktopManagerHandlesLidAndPower = false;
      lightdm.enable = true;
      sessionCommands = ''
        ${pkgs.xlibs.xsetroot}/bin/xsetroot -cursor_name left_ptr
      '';
      #${pkgs.feh}/bin/feh --bg-fill ${background}
    };
    windowManager.default = "xmonad";
    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;
    #windowManager.xmonad.extraPackages = haskellPackages: [
    #  haskellPackages.taffybar
    #];

    multitouch.enable = true;
    multitouch.invertScroll = true;
    multitouch.ignorePalm = true;
    multitouch.additionalOptions = ''
        Option "FingerHigh" "20"
   '';

    #screenSection = ''
    #  Option "NoLogo" "TRUE"
    #'';
    # Option "DPI" "96 x 96"

    # services.xserver.xkbOptions = "eurosign:e";
    xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      inconsolata
      ubuntu_font_family
    ];
  };


  ## Users
  users.mutableUsers = true;
  users.extraUsers.guest = {
    isNormalUser = true;
    name = "rafael";
    group = "users";
    uid = 1000;
    extraGroups = ["wheel" "networkmanager" "docker"];
    createHome = true;
    home = "/home/rafael";
  };
  security.pam.enableEcryptfs = true;

  ## Boilerplate
  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "15.09";

  nixpkgs.config.allowUnfree = true;
}
