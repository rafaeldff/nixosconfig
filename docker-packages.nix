{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true; 

  environment.systemPackages =
    with pkgs; [
      python27Packages.docker_compose
    ];
}
