{ config, pkgs, ... }:


{
  environment.systemPackages =
    let
    in
    with pkgs; [
    
    # dev
    #python2
    gitFull
    openjdk11
    maven
    visualvm
    jetbrains.idea-ultimate
    #(idea.idea-ultimate.overrideAttrs (old: rec {
      #version = "2018.1.4";
      #src = fetchurl {
        #url = "https://download.jetbrains.com/idea/ideaIC-${version}.tar.gz";
        #sha256 = "1qb425wg4690474g348yizhkcqcgigz2synp4blcfv4p0pg79ri6"; 
      #};
    #}))
    # mat
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

    #nixpkgs.config.packageOverrides = pkgs: rec {
      #leiningen = pkgs.leiningen.override {
        #jdk = pkgs.openjdk10;
      #};
    #};

    virtualisation.virtualbox.host.enable = true;
}
