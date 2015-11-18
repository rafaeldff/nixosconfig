# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  hardware.enableAllFirmware = true;
  #networking.enableB43Firmware = true;

  boot.kernelPackages =  pkgs.linuxPackages_4_2;
  # Use the gummiboot efi boot loader.
  boot.loader.gummiboot.enable = true;
  boot.loader.gummiboot.timeout = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.cleanTmpDir = true;

  nixpkgs.config.packageOverrides = super: let self = super.pkgs; in rec
  {
    linux_4_1 = super.linux_4_1.override {
      extraConfig = ''
        BRCMFMAC_PCIE y
        BRCMFMAC_USB  y
        BRCMFMAC_SDIO y
      '';
    };
  };

  #boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  #boot.initrd.kernelModules = [ "wl" ];

  networking.hostName = "rffnix"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.wireless.enable = false;
  networking.firewall.enable = false;

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    #bare minimum
    wget
    git
    dropbox
    rxvt_unicode
    termite

    # browsers
    chromium
    firefox
    
    # fonts
    xlsfonts
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  services.xserver = {
    enable = true;

    # vaapiDrivers = [ pkgs.vaapiIntel ];

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
	Option "Thumbsize" "50"
	Option "ScrollDistance" "100" 
    '';

    #synaptics.additionalOptions = ''
    #  Option "VertScrollDelta" "-100"
    #  Option "HorizScrollDelta" "-100"
    #'';
    #synaptics.buttonsMap = [ 1 3 2 ];
    #synaptics.enable = true;
    #synaptics.tapButtons = false;
    #synaptics.fingersMap = [ 0 0 0 ];
    #synaptics.twoFingerScroll = true;
    #synaptics.vertEdgeScroll = false;

    screenSection = ''
      Option "NoLogo" "TRUE"
    '';
    # Option "DPI" "96 x 96"

    xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";
  };


  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.kde4.enable = true;

  users.mutableUsers = true;


  users.extraUsers.guest = {
    isNormalUser = true;
    name = "rafael";
    group = "users";
    uid = 1000;
    extraGroups = ["wheel" "networkmanager"];
    createHome = true;
    home = "/home/rafael";
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "15.09";

  nixpkgs.config.allowUnfree = true;

  security.pam.enableEcryptfs = true;

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      inconsolata
      ubuntu_font_family
    ];
  };
   
}
