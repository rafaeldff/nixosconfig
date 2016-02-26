{ config, pkgs, ... }:

with pkgs.lib

{
  virtualisation.docker.enable = true; 

  environment.systemPackages =
    let
      mydockerpty = with python27Packages; python27Packages.buildPythonPackage rec {
        name    = "dockerpty-0.4.1";
        version = "0.4.1";

        src = pkgs.fetchurl {
          url = "https://pypi.python.org/packages/source/d/dockerpty/dockerpty-0.4.1.tar.gz";
          md5 = "028bacb34536f3ee6a2ccd668c27e8e4";
        };

        propagatedBuildInputs = [ six ];

        meta = {
          description = "Functionality needed to operate the pseudo-tty (PTY) allocated to a docker container";
          homepage = https://github.com/d11wtq/dockerpty;
        };
      };
      mydockercompose = with pkgs.python27Packages buildPythonPackage rec {
        #version = "1.6.2";
        #name = "docker-compose-${version}";
        #namePrefix = "";
        #disabled = isPy3k || isPyPy;
    
        #src = fetchurl {
          #url = "https://pypi.python.org/packages/source/d/docker-compose/docker-compose-1.6.2.tar.gz"; 
          #sha256 = "10i4032d99hm5nj1p74pcad9i3gz1h5x3096byklncgssfyjqki6";
        #};

        ## lots of networking and other fails
        #doCheck = false;
        #buildInputs = with self; [ mock pytest nose ];
        #propagatedBuildInputs = with self; [
          #requests2 six pyyaml texttable docopt docker websocket_client
          #enum34 jsonschema
          #dockerpty
        #];
        #patchPhase = ''
          #sed -i "s/'requests >= 2.6.1, < 2.8'/'requests'/" setup.py
        #'';
    
        #meta = {
          #homepage = "https://docs.docker.com/compose/";
          #description = "Multi-container orchestration for Docker";
          #license = licenses.asl20;
        #};
      };
    in [
      mydockerpty
      mydockercompose
    ];
}
