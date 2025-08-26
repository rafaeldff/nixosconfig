{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    openvpn
  ];

  services.tailscale.enable = true;
}
