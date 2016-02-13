## mac hardware / low-level stuff

{ config, pkgs, ... }:

{

  hardware.enableAllFirmware = true;
  # select the right sound card,
  boot.extraModprobeConfig = ''
    options snd_hda_intel enable=0,1
  '';

  # Use the gummiboot efi boot loader.
  boot.loader.gummiboot.enable = true;
  boot.loader.gummiboot.timeout = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.cleanTmpDir = true;
  
  # configure multitouch options 
  services.xserver = {
    multitouch.enable = true;
    multitouch.invertScroll = true;
    multitouch.ignorePalm = true;
    multitouch.additionalOptions = ''
        Option "FingerHigh" "20"
   '';
  };
}


