{ config, pkgs, ... }:
{
  services.fprintd.enable = true;
  security.pam.services.sudo = {
    enable = true;
    # optional: explicitly allow fingerprint for sudo
    fprintAuth = true;
  };
}

