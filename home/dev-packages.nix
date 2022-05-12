{ config, pkgs, ... }:


{
  home.packages =
    let
    in
    with pkgs; [
    
    # dev
    python2
    # gitFull conflicts with git #XXX 
    openjdk11
    maven
    visualvm
    jetbrains.idea-ultimate
    awscli
    github-cli

    (clojure.override {jdk = pkgs.jdk11;})
    leiningen

    #clj-kondo

    linuxPackages.perf

    # virtualization
    vagrant

    # infosec
    nssTools

    vscode
    glibc
    gnumake

    # web ui
    ncurses.dev
    confluent-platform
    ];

    #virtualisation.virtualbox.host.enable = true; #XXX
}
