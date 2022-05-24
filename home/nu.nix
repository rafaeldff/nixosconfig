{ config, pkgs, ... }:


{
  home.packages =
  with pkgs; [
    #yubikey
    yubioath-desktop
    yubikey-manager
    #gnupg # this is gpg >= 2
    pinentry-curses
    nss.tools


    #zoom-us

    # vpn
    # sshuttle #
    # openfortivpn

    #mobile
    git-lfs

    #nucli
    gettext
  ];

  #services.pcscd.enable = true; #XXX
  #programs.gnupg.agent = { #XXX
  #  enable = true;
  #  pinentryFlavor = "curses";
  #};
  
  #hardware.u2f.enable = true; #XXX

  # programs = { #XXX
  #   chromium = {
  #     enable = true;
  #     extraOpts = {
  #       AutoSelectCertificateForUrls = ["{\"pattern\":\"[*.]nubank.com.br\",\"filter\":{\"ISSUER\":{\"CN\":\"nubanker\"}}}"];
  #     };
  #   };
  # };
}

