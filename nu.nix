{ config, pkgs, ... }:


let 
in {
  environment.systemPackages =
  with pkgs; [
    #yubikey
    yubioath-desktop
    yubikey-manager
    gnupg # this is gpg >= 2
    nss.tools

    # vpn
    sshuttle

    zoom-us

    openfortivpn

    #mobile
    git-lfs

    #nucli
    gettext
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

