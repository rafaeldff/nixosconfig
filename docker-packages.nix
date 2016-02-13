{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true; 

  environment.systemPackages =
    let
      functools32 = with pkgs; python27Packages.buildPythonPackage rec {
        name = "functools32-3.2.3-2";

        propagatedBuildInputs = with self; [ ];

        src = pkgs.fetchurl {
          url = "https://pypi.python.org/packages/source/f/functools32/functools32-3.2.3-2.tar.gz";
          md5 = "09f24ffd9af9f6cd0f63cb9f4e23d4b2";
        };
      };  in
    with pkgs; [
    (pkgs.lib.overrideDerivation python27Packages.docker_compose (attrs: {
      version = "1.5.1";
      name = "docker-compose-1.5.1";
      
      src = pkgs.fetchurl {
        url = "https://pypi.python.org/packages/source/d/docker-compose/docker-compose-1.5.1.tar.gz";
        sha256 = "df5e885fd758a2b5983574d6718b5a07f92c7166c5706dc6ff88687d27bfaf55";
      };

      propagatedBuildInputs = with self; [
        python27Packages.six python27Packages.requests python27Packages.pyyaml python27Packages.texttable python27Packages.docopt python27Packages.docker python27Packages.dockerpty python27Packages.websocket_client python27Packages.enum34 python27Packages.requests2 
        (python27Packages.jsonschema.override {
          version = "2.5.1";
          name = "jsonschema-2.5.1";
          src = pkgs.fetchurl {
            url = "https://pypi.python.org/packages/source/j/jsonschema/jsonschema-2.5.1.tar.gz";
            md5 = "374e848fdb69a3ce8b7e778b47c30640";
          };
          propagatedBuildInputs = with self; [ functools32 ];
          preBuild = ''
            sed -i '/vcversioner/d' setup.py
            sed -i '/README.rst/i__version__ = "2.5.1"' setup.py
            sed -i '/packages=/iversion="2.5.1",' setup.py
            echo '__version__ = "2.5.1"' > jsonschema/version.py
          '';
        })
      ];
      
    }))
    python27Packages.enum34
    ];
}
