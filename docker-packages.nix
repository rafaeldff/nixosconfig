{ config, pkgs, iproute, bridge-utils, devicemapper
, btrfsProgs, iptables, e2fsprogs, xz, utillinux
, enableLxc ? false, lxc, ... }:


{
  virtualisation.docker.enable = true; 

  environment.systemPackages =
    let
      cached_property = with pkgs; python27Packages.buildPythonPackage rec {
        name    = "cached-property-1.3.0";

        src = pkgs.fetchurl {
          url = "https://pypi.python.org/packages/source/c/cached-property/cached-property-1.3.0.tar.gz";
          md5 = "4a6039f7418007275505e355359396a8";
        };

        meta = {
          description = "A decorator for caching properties in classes.";
          homepage = https://github.com/pydanny/cached-property/;
          license = licenses.bsd;
        };
      };
      mydockerpty = with pkgs; python27Packages.buildPythonPackage rec {
        name    = "dockerpty-0.4.1";
        version = "0.4.1";

        src = pkgs.fetchurl {
          url = "https://pypi.python.org/packages/source/d/dockerpty/dockerpty-0.4.1.tar.gz";
          md5 = "028bacb34536f3ee6a2ccd668c27e8e4";
        };

        propagatedBuildInputs = [ python27Packages.six ];

        meta = {
          description = "Functionality needed to operate the pseudo-tty (PTY) allocated to a docker container";
          homepage = https://github.com/d11wtq/dockerpty;
          license = licenses.asl20;
        };
      };
      mydockerpy = with pkgs.python27Packages; pkgs.python27Packages.buildPythonPackage rec {
        name = "docker-py-1.7.2";

        src = pkgs.fetchurl {
          url = "https://pypi.python.org/packages/source/d/docker-py/${name}.tar.gz";
          sha256 = "0k6hm3vmqh1d3wr9rryyif5n4rzvcffdlb1k4jvzp7g4996d3ccm";
        };

        propagatedBuildInputs = [ six requests2 websocket_client ];

        # Version conflict
        doCheck = false;

        meta = {
          description = "An API client for docker written in Python";
          homepage = https://github.com/docker/docker-py;
          license = licenses.asl20;
        };
      };
      mydockercompose = with pkgs.python27Packages; pkgs.python27Packages.buildPythonPackage rec {
        version = "1.6.2";
        name = "docker-compose-${version}";
        namePrefix = "";
        disabled = isPy3k || isPyPy;
    
        src = pkgs.fetchurl {
          url = "https://pypi.python.org/packages/source/d/docker-compose/docker-compose-1.6.2.tar.gz"; 
          sha256 = "10i4032d99hm5nj1p74pcad9i3gz1h5x3096byklncgssfyjqki6";
        };

        # lots of networking and other fails
        doCheck = false;
        buildInputs = [ mock pytest nose ];
        propagatedBuildInputs = [
          requests2 six pyyaml texttable docopt mydockerpy websocket_client
          enum34 jsonschema
          cached_property
          mydockerpty
        ];
        patchPhase = ''
          sed -i "s/'requests >= 2.6.1, < 2.8'/'requests'/" setup.py
        '';
    
        meta = {
          homepage = "https://docs.docker.com/compose/";
          description = "Multi-container orchestration for Docker";
          license = licenses.asl20;
        };
      };
    in
    with pkgs; [
      mydockerpty
      mydockercompose
    ];

  nixpkgs.config.packageOverrides = pkgs:
    {
      docker = pkgs.lib.overrideDerivation pkgs.docker (attrs: {
        version = "1.10.2";
        name = "docker-1.10.2";
        src = pkgs.fetchFromGitHub {
          owner = "docker";
          repo = "docker";
          rev = "v1.10.2";
          sha256 = "0q07gq2kv5zhxm7apwf52pgfm8pb2zn2pjb40fd4gpmajp5yw2d3";
        };
        installPhase = ''
          install -Dm755 ./bundles/1.10.2/dynbinary/docker-1.10.2 $out/libexec/docker/docker
          install -Dm755 ./bundles/1.10.2/dynbinary/dockerinit-1.10.2 $out/libexec/docker/dockerinit
          makeWrapper $out/libexec/docker/docker $out/bin/docker \
            --prefix PATH : "${pkgs.iproute}/sbin:sbin:${pkgs.iptables}/sbin:${pkgs.e2fsprogs}/sbin:${pkgs.xz}/bin:${pkgs.utillinux}/bin:${pkgs.stdenv.lib.optionalString config.virtualisation.lxc.enable "${lxc}/bin"}"
          # systemd
          install -Dm644 ./contrib/init/systemd/docker.service $out/etc/systemd/system/docker.service
          # completion
          install -Dm644 ./contrib/completion/bash/docker $out/share/bash-completion/completions/docker
          install -Dm644 ./contrib/completion/zsh/_docker $out/share/zsh/site-functions/_docker
        '';
      });
   };
}
