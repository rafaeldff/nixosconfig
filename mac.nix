## mac hardware / low-level stuff

{ config, pkgs, ... }:

{

  hardware.enableAllFirmware = true;
  # select the right sound card,
  boot.extraModprobeConfig = ''
    options snd_hda_intel enable=0,1
  '';

  hardware.bluetooth.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };
  environment.systemPackages = [ pkgs.pavucontrol ];

  # Use the gummiboot efi boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.cleanTmpDir = true;
  # configure multitouch options 
  services.xserver = {
    libinput.enable = true;
    #multitouch.enable = true;
    #multitouch.invertScroll = true;
    #multitouch.ignorePalm = true;
    #multitouch.additionalOptions = ''
        #Option "FingerHigh" "20"
   #'';
  };

  services.xserver.config = " # adding another comment";

}


