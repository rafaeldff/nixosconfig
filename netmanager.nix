{ config, lib, pkgs, ... }:

{
  networking.networkmanager.enable = true;
  # networking.wireless.enable = false;
  # networking.firewall.enable = false;
  # networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so look for interface config on
  # hardware-specific config file (e.g. nu-dell.nix)
  networking.useDHCP = lib.mkDefault false;

  networking.networkmanager.dispatcherScripts = [
    {
      source = pkgs.writeText "wifi-wired-toggle" ''
        # Allow overriding the toggle behavior
        if [ -f /tmp/disable-wifi-auto-switch ]; then
          exit 0
        fi

        interface=$1
        status=$2

        # Check if the interface is Ethernet (starts with en or eth)
        if [[ "$interface" =~ ^(en|eth) ]]; then
          case "$status" in
            up)
              ${pkgs.networkmanager}/bin/nmcli radio wifi off
              ;;
            down)
              ${pkgs.networkmanager}/bin/nmcli radio wifi on
              ;;
          esac
        fi
      '';
      type = "basic";
    }
  ];

}
