{ config, pkgs, iproute, bridge-utils, devicemapper
, btrfsProgs, iptables, e2fsprogs, xz, utillinux
, enableLxc ? false, lxc, ... }:


{
  services.journald.extraConfig = "SystemKeepFree=10G";




}
