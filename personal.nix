{ config, pkgs, ... }:


let 
in {
  environment.systemPackages =
  with pkgs; [
    #yubikey
    yubioath-flutter
    yubikey-manager
    #gnupg # this is gpg >= 2
    pinentry-curses
    #nss.tools
  ];

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    #pinentryFlavor = "curses";
    pinentryPackage = pkgs.pinentry-curses;
  };
  
  #hardware.u2f.enable = true;
}

