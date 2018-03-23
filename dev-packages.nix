{ config, pkgs, ... }:

{

  environment.systemPackages =
    with pkgs; [
    
    # dev
    python2
    gitFull
    oraclejdk9
    idea.idea-ultimate
    awscli
    gitAndTools.hub

    # clojure
    leiningen

    # virtualization
    vagrant
    ];

    virtualisation.virtualbox.host.enable = true;
}
