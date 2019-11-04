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
  
  hardware.u2f.enable = true;

  programs = {
    chromium = {
      enable = true;
      extraOpts = {
        AutoSelectCertificateForUrls = ["{\"pattern\":\"[*.]nubank.com.br\",\"filter\":{\"ISSUER\":{\"CN\":\"nubanker\"}}}"];
      };
    };
  };
}

