{ config, pkgs, ... }:

with pkgs.lib;

{
  virtualisation.docker.enable = true; 

  environment.systemPackages =
    let
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
          #license = licenses.asl20;
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
          requests2 six pyyaml texttable docopt docker websocket_client
          enum34 jsonschema
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
}
