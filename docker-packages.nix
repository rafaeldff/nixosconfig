{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true; 

  environment.systemPackages =
    let
      dockerpty = with pkgs; python27Packages.buildPythonPackage rec {
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
      }; in
    with pkgs; [
      (lib.overrideDerivation python27Packages.docker_compose (attrs: {
        version = "1.6.2";
        name = "docker-compose-1.6.2";

        
        src = fetchurl {
          #sha256 = "df5e885fd758a2b5983574d6718b5a07f92c7166c5706dc6ff88687d27bfaf55";
          url = "https://pypi.python.org/packages/source/d/docker-compose/docker-compose-1.6.2.tar.gz"; 
          sha256 = "10i4032d99hm5nj1p74pcad9i3gz1h5x3096byklncgssfyjqki6";
        };


        propagatedBuildInputs = with self; [
          python27Packages.requests2 python27Packages.six python27Packages.pyyaml python27Packages.texttable python27Packages.docopt python27Packages.docker python27Packages.websocket_client
          python27Packages.enum34 python27Packages.jsonschema
          (python27Packages.dockerpty.override {
            name = "dockerpty-0.4.1";
            src = pkgs.fetchurl {
              url = "https://pypi.python.org/packages/source/d/dockerpty/dockerpty-0.4.1.tar.gz";
              md5 = "028bacb34536f3ee6a2ccd668c27e8e4";
            };
          })
        ];
        
      }))
    ];
}
