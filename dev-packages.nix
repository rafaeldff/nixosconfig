{ config, pkgs, ... }:

{

  environment.systemPackages =
    with pkgs; [
    
    # dev
    python2
    gitFull
    oraclejdk8
    idea.idea-community
    awscli
    gitAndTools.hub

    # clojure
    leiningen

    # virtualization
    vagrant
    ];

    virtualisation.virtualbox.host.enable = true;
}
