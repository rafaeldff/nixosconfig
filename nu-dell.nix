## dell hardware / low-level stuff

{ config, pkgs, ... }:

{

  hardware.bluetooth.enable = true;
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };
  environment.systemPackages = [ pkgs.pavucontrol ];

  # Use the systemd-boot EFI bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.timeout = 5;

  # configure multitouch options 
  services.xserver.libinput = {
    enable = true;
    touchpad = {
      #accelSpeed = "0.2";
      naturalScrolling = true;
    };
    #multitouch.enable = true;
    #multitouch.invertScroll = true;
    #multitouch.ignorePalm = true;
    #multitouch.additionalOptions = ''
        #Option "FingerHigh" "20"
   #'';
  };

  # services.xserver.config = " # adding another comment";
  networking.interfaces.wlp59s0.useDHCP = true;

  # auto-mount flash drives
  services.udisks2.enable = true;

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser ];
}


