{ config, pkgs, ... }:

{
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser ];

  # ────────────────────────────────────────────────
  # Workaround for NixOS 25.05 cups‑browsed bug
  # ────────────────────────────────────────────────
  # Disable cups‑browsed to avoid auto‑created queues
  # that point to file:///dev/null.  We rely on a
  # static IPP Everywhere queue instead.
  services.printing.browsed.enable = false;

  # Dynamic discovery (kept for future reference)
  # services.printing.browsing = true;
  # services.printing.browsedConf = ''
  #   BrowseRemoteProtocols DNSSD
  #   CreateIPPPrinterQueues All
  #   DebugLogging true
  # '';

  # Expose the CUPS web interface at http://localhost:631
  services.printing.webInterface = true;

  # ────────────────────────────────────────────────
  # Static fallback IPP queue for Brother MFC‑L2710DW
  # Using the new hardware.printers.* options (25.05+)
  # ────────────────────────────────────────────────
  hardware.printers = {
    ensurePrinters = [
      {
        name        = "BrotherManual";
        description = "Brother MFC‑L2710DW (manual IPP)";
        deviceUri   = "ipp://BRW900F0CD6AC59.local/ipp/print";
        model       = "everywhere"; # IPP Everywhere driverless
        # ppdOptions  = { sides = "two-sided-long-edge"; };
      }
    ];
    ensureDefaultPrinter = "BrotherManual";
  };

  # Avahi for mDNS name resolution (needed for .local hostnames)
  services.avahi.enable       = true;
  services.avahi.nssmdns      = true;
  services.avahi.openFirewall = true;

  # ────────────────────────────────────────────────
  # Scanner support 
  # ────────────────────────────────────────────────

  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.sane-airscan ];
  users.users.rafael.extraGroups = [ "scanner" "lp" ];

  environment.systemPackages = [ pkgs.xsane pkgs.cups ];

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

