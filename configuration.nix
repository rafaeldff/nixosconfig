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
  # select the right sound card,
  # and fix keyboard layout for backticks
  boot.extraModprobeConfig = ''
    options snd_hda_intel enable=0,1
  '';

  boot.kernelPackages =  pkgs.linuxPackages_4_4;

  # Use the gummiboot efi boot loader.
  boot.loader.gummiboot.enable = true;
  boot.loader.gummiboot.timeout = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.cleanTmpDir = true;

  networking.hostName = "rffnix"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.wireless.enable = false;
  networking.firewall.enable = false;
  networking.extraHosts ="127.0.0.1 rffnix";

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
  nixpkgs.config = {
    allowUnfree = true;
    chromium = {
      enablePepperFlash = true;
      enablePepperPDF = true;
    };
  };

  environment.systemPackages =
    let
      functools32 = with pkgs; python27Packages.buildPythonPackage rec {
        name = "functools32-3.2.3-2";

        propagatedBuildInputs = with self; [ ];

        src = pkgs.fetchurl {
          url = "https://pypi.python.org/packages/source/f/functools32/functools32-3.2.3-2.tar.gz";
          md5 = "09f24ffd9af9f6cd0f63cb9f4e23d4b2";
        };
      };  in
    with pkgs; [
    #bare minimum
    wget
    git
    dropbox
    rxvt_unicode
    xlockmore

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
    feh
    scrot
    xclip
    gawk
    nettools
    jq
    unzip
    sl

    # dev
    python2
    gitFull
    oraclejdk8
    idea.idea-community
    (pkgs.lib.overrideDerivation python27Packages.docker_compose (attrs: {
      version = "1.5.1";
      name = "docker-compose-1.5.1";
      
      src = pkgs.fetchurl {
        url = "https://pypi.python.org/packages/source/d/docker-compose/docker-compose-1.5.1.tar.gz";
        sha256 = "df5e885fd758a2b5983574d6718b5a07f92c7166c5706dc6ff88687d27bfaf55";
      };

      propagatedBuildInputs = with self; [
        python27Packages.six python27Packages.requests python27Packages.pyyaml python27Packages.texttable python27Packages.docopt python27Packages.docker python27Packages.dockerpty python27Packages.websocket_client python27Packages.enum34 python27Packages.requests2 
        (python27Packages.jsonschema.override {
          version = "2.5.1";
          name = "jsonschema-2.5.1";
          src = pkgs.fetchurl {
            url = "https://pypi.python.org/packages/source/j/jsonschema/jsonschema-2.5.1.tar.gz";
            md5 = "374e848fdb69a3ce8b7e778b47c30640";
          };
          propagatedBuildInputs = with self; [ functools32 ];
          preBuild = ''
            sed -i '/vcversioner/d' setup.py
            sed -i '/README.rst/i__version__ = "2.5.1"' setup.py
            sed -i '/packages=/iversion="2.5.1",' setup.py
            echo '__version__ = "2.5.1"' > jsonschema/version.py
          '';
        })
      ];
      
    }))
    python27Packages.enum34
    awscli

    # networking
    openvpn
    ldns
    mtr

    # xmonad
    termite
    haskellPackages.xmobar
    dmenu

    # media
    spotify

    # nixos meta
    nix-prefetch-scripts
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
    };
    windowManager.default = "xmonad";
    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;

    multitouch.enable = true;
    multitouch.invertScroll = true;
    multitouch.ignorePalm = true;
    multitouch.additionalOptions = ''
        Option "FingerHigh" "20"
   '';

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

  ## Shell
  # Show git info in bash prompt and display a colorful hostname if using ssh.
  programs.bash.promptInit = ''
    export _JAVA_AWT_WM_NONREPARENTING=1  
    export GIT_PS1_SHOWDIRTYSTATE=1

    source ${pkgs.gitAndTools.gitFull}/share/git/contrib/completion/git-prompt.sh
    __prompt_color="1;32m"
    # Alternate color for hostname if the generated color clashes with prompt color
    __alternate_color="1;33m"
    __hostnamecolor="$__prompt_color"
    # If logged in with ssh, pick a color derived from hostname
    if [ -n "$SSH_CLIENT" ]; then
      __hostnamecolor="1;$(${pkgs.nettools}/bin/hostname | od | tr ' ' '\n' | ${pkgs.gawk}/bin/awk '{total = total + $1}END{print 30 + (total % 6)}')m"
      # Fixup color clash
      if [ "$__hostnamecolor" = "$__prompt_color" ]; then
        __hostnamecolor="$__alternate_color"
      fi
    fi
    __red="1;31m"
    PS1='\n$(ret=$?; test $ret -ne 0 && printf "\[\e[$__red\]$ret\[\e[0m\] ")\[\e[$__prompt_color\]\u@\[\e[$__hostnamecolor\]\h \[\e[$__prompt_color\]\w$(__git_ps1 " [git:%s]")\[\e[0m\]\n$ '
  '';

  programs.bash.enableCompletion = true;
  programs.bash.interactiveShellInit = ''
    [[ -s "$HOME/.dircolors" ]] && eval `${pkgs.coreutils}/bin/dircolors $HOME/.dircolors`
  '';


  ## Users
  # users.mutableUsers = true;
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

}
