{ config, pkgs, ... }:

{

  environment.systemPackages =
    with pkgs; [
    
    # dev
    python2
    gitFull
    oraclejdk10
    (idea.idea-ultimate.overrideAttrs (old: rec {
      version = "2018.1.4";
      src = fetchurl {
        url = "https://download.jetbrains.com/idea/ideaIC-${version}.tar.gz";
        sha256 = "1qb425wg4690474g348yizhkcqcgigz2synp4blcfv4p0pg79ri6"; 
      };
    }))
    awscli
    gitAndTools.hub

    # clojure
    leiningen

    # virtualization
    vagrant
    ];

    nixpkgs.config.packageOverrides = pkgs: rec {
      leiningen = pkgs.leiningen.override {
        jdk = pkgs.oraclejdk10;
      };
    };

    virtualisation.virtualbox.host.enable = true;
}
