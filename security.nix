{ config, pkgs, ... }:

{
  security.pam.enableEcryptfs = true;

  environment.systemPackages =
    with pkgs; [
    ecryptfs
    ecryptfs-helper
    _1password
    _1password-gui
  ]; 
}
