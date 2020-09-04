{ config, pkgs, ... }:


let 
in {
  environment.systemPackages =
  with pkgs; [
    #yubikey
    yubioath-desktop
    yubikey-manager
    gnupg # this is gpg >= 2

    # vpn
    sshuttle

    zoom-us

  ];

  services.pcscd.enable = true;
  programs.gnupg.agent.enable = true;
  
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

