{ config, pkgs, ... }:

{
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser ];

  # Disable cups-browsed to avoid auto-created queues
  # that point to file:///dev/null.
  services.printing.browsed.enable = false;

  # Expose the CUPS web interface at http://localhost:631
  services.printing.webInterface = true;

  # Declarative IPP queue for Brother MFC-L2710DW
  # Using IP to avoid breakage when mDNS hostname changes.
  # Set a static DHCP lease on the router for 192.168.1.54.
  hardware.printers.ensurePrinters = [{
    name = "BrotherManual";
    model = "everywhere";
    deviceUri = "ipp://192.168.1.54/ipp/print";
    description = "Brother MFC-L2710DW";
  }];
  hardware.printers.ensureDefaultPrinter = "BrotherManual";

  # Avahi for mDNS name resolution (needed for .local hostnames)
  services.avahi.enable       = true;
  services.avahi.nssmdns4     = true;
  services.avahi.openFirewall = true;

  # Scanner support
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.sane-airscan ];
  users.users.rafael.extraGroups = [ "scanner" "lp" ];

  environment.systemPackages = [ pkgs.xsane pkgs.cups ];

  # ensure-printers runs early and fails if the printer isn't reachable yet.
  # Wait for network-online and retry on failure so BrotherManual gets created.
  systemd.services.ensure-printers = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "30s";
    };
  };

  hardware.sane.brscan5 = {
    enable = true;
    netDevices = {
      home = {
        model = "MFC-L2710DW";
        ip = "192.168.1.54";
      };
    };
  };
}
