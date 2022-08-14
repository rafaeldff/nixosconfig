{ config, pkgs, ... }:


let 
in {
  environment.systemPackages =
  with pkgs; [
    #yubikey
    yubioath-desktop
    yubikey-manager
    #gnupg # this is gpg >= 2
    pinentry-curses
    #nss.tools
  ];

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
  };
  
  #hardware.u2f.enable = true;
}

