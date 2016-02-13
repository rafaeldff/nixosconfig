 {config, pkgs, ...}:
 {
   # You need to configure a root filesytem
   # fileSystems."/".label = "vmdisk";
   imports = [ ./configuration.nix ];
 
   # The test vm name is based on the hostname, so it's nice to set one
   # networking.hostName = "vmhost"; 
 
   # Add a test user who can sudo to the root account for debugging
   users.extraUsers.vm = {
     password = "vm";
     isNormalUser = true;
     shell = "${pkgs.bash}/bin/bash";
     group = "users";
     extraGroups = ["wheel" "networkmanager" "docker"];
     createHome = true;
     home = "/home/vm";
   };
   security.sudo = {
     enable = true;
     wheelNeedsPassword = false;
   };
 
 }
