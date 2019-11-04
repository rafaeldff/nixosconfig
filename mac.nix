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
    multitouch.enable = true;
    multitouch.invertScroll = true;
    multitouch.ignorePalm = true;
    multitouch.additionalOptions = ''
        Option "FingerHigh" "20"
   '';
  };

  services.xserver.config = " # adding another comment";
  hardware.facetimehd.enable = true;

  nixpkgs.config.packageOverrides = super:
  let
    osxBlob = pkgs.requireFile {
      message = ''
      nix-prefetch-url file:///home/rafael/nixosconfig/OSXUpd10.11.5.dmg 
      '';
      #sha256 = "46cd31ee35b084f59dc8b8f632e6bebdb4badeafbab064eea32ae66cc3743301";
      sha256 = "009kfk1nrrialgp69c5smzgbmd5xpvk35xmqr2fzb15h6pp33ka6";
      #sha256 = "0zb52vsv04if2kla5k2azwfi04mn8mmpl5ahkgpch0157byygb4x";
      name = "AppleCameraInterface";
      };
      in {
      facetimehd-firmware = super.facetimehd-firmware.overrideDerivation (old: {
      name = "facetimehd-firmware";
      src = null; # disables download from apple
      buildPhase = ''
      mkdir -p $out/lib/firmware/facetimehd
      dd bs=1 skip=81920 if=${osxBlob} | gunzip -c > $out/lib/firmware/facetimehd/firmware.bin || true
      '';
    });
  };

}


