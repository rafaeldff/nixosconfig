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
  # Make ensure-printers start after network+Avahi+CUPS, retry if early
  systemd.services.ensure-printers = {
    after  = [ "network-online.target" "avahi-daemon.service" "cups.service" ];
    wants  = [ "network-online.target" "avahi-daemon.service" "cups.service" ];
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "10s";
      TimeoutStartSec = "60s";
      ExecStartPre = "${pkgs.writeShellScript ''wait-mdns'' ''
        # Wait (max ~30s) for mDNS resolution of the printer's .local name
        for i in $(seq 1 15); do
          if getent hosts BRW900F0CD6AC59.local >/dev/null; then
            exit 0
          fi
          sleep 2
        done
        # Don't fail hard; allow the main ExecStart to run and systemd to retry
        exit 0
      ''}";
    };
  };


  # Avahi for mDNS name resolution (needed for .local hostnames)
  services.avahi.enable       = true;
  services.avahi.nssmdns4     = true;
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

