{ config, pkgs, ... }:


{
  environment.systemPackages =
    let
      myclojure = pkgs.clojure.overrideAttrs (oldAttrs: rec {
        version = "1.10.0.442";
      });
    in
    with pkgs; [
    
    # dev
    python2
    gitFull
    openjdk11
    visualvm
    idea.idea-ultimate
    #(idea.idea-ultimate.overrideAttrs (old: rec {
      #version = "2018.1.4";
      #src = fetchurl {
        #url = "https://download.jetbrains.com/idea/ideaIC-${version}.tar.gz";
        #sha256 = "1qb425wg4690474g348yizhkcqcgigz2synp4blcfv4p0pg79ri6"; 
      #};
    #}))
    mat
    awscli
    gitAndTools.hub

    myclojure
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
    sassc
    sass
    phantomjs
    nodejs

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
