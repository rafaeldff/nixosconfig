# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable sound.
  #sound.enable = true;
  #hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true;

  #hardware.pulseaudio = {
  #  enable = true;
  #  package = pkgs.pulseaudioFull;
  #};

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput = {
    enable = true;
    touchpad = {
    # accelSpeed = "0.2";
      naturalScrolling = true;
    };
    #multitouch.enable = true;
    #multitouch.invertScroll = true;
    #multitouch.ignorePalm = true;
    #multitouch.additionalOptions = ''
    #   Option "FingerHigh" "20"
   #'';
  };



  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # fingerprint sensor
  services.fprintd.enable = true;
  services.udisks2.enable = true;

  # AMD Ryzen Framework only supports s2idle (no S3); rely on suspend-then-hibernate
  # (see suspending.nix) to limit standby drain. resumeDevice points at the swap
  # partition so the initrd has a deterministic resume target.
  boot.resumeDevice = "/dev/disk/by-uuid/0a8e42b2-157f-4bd5-8495-5d536c57ed02";

  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = "ondemand";
  };

  services.tlp = {
    enable = true;
    settings = {
      CPU_BOOST_ON_BAT = 0;
      CPU_SCALING_GOVERNOR_ON_AC="performance";
      CPU_SCALING_GOVERNOR_ON_BATTERY = "powersave";
      START_CHARGE_THRESH_BAT0 = 90;
      STOP_CHARGE_THRESH_BAT0 = 97;
      RUNTIME_PM_ON_BAT = "auto";
      # Apple Magic Trackpad 2: autosuspend prevents cursor movement after
      # a few seconds of inactivity (requires a click to wake).
      USB_AUTOSUSPEND_DISABLE_ON_AC = "05ac:0265";
      USB_AUTOSUSPEND_DISABLE_ON_BAT = "05ac:0265";
    };
  };

  services.fwupd.enable = true;

  # MT7922 Wi-Fi 6E: enable 6 GHz scanning
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom=DE
    options mt7921_common disable_clc=1
  '';
}

