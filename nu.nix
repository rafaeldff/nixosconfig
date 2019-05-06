{ config, pkgs, ... }:


let 
in {
  environment.systemPackages =
  with pkgs; [
    #yubikey
    yubioath-desktop
    yubikey-manager

    # vpn
    sshuttle
  ];

  services.pcscd.enable = true;
}

