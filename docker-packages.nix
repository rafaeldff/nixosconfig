{ config, pkgs, iproute, bridge-utils, devicemapper
, btrfsProgs, iptables, e2fsprogs, xz, utillinux
, enableLxc ? false, lxc, ... }:


{
  virtualisation.docker.enable = true; 

  environment.systemPackages =
    with pkgs; [
      #python27Packages.docker
      docker-compose
    ];

}
