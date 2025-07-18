{ config, pkgs, ... }:

{
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser ];
  services.printing.browsing = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.avahi.openFirewall = true;

  services.printing.webInterface = true;


  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.sane-airscan ];
  users.users.rafael.extraGroups = [ "scanner" "lp" ];

  environment.systemPackages = [ pkgs.xsane ];

  #hardware.sane.brscan5.netDevices = {
    #home = {
      #model = "MFC-L2710DW";
      #ip = "192.168.2.31";
    #};
  #};

  #hardware = {}

  hardware.sane.brscan5 = {
    enable = true;
    netDevices = {
      home = {
        model = "MFC-L2710DW";
        ip = "192.168.2.31";
      };
    };
  };
}

