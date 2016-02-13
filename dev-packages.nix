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
    ];
}
