# User-level suspend and lock configuration
#
# This configures swaylock, swayidle, and the power-menu script.
# System-level configuration is in suspending.nix at the NixOS level.

{ config, pkgs, ... }:

{
  # Install swaylock
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock;
  };

  # Configure swayidle for screen locking only (no DPMS)
  services.swayidle = {
    enable = true;

    # Lock screen after 5 minutes of inactivity
    timeouts = [
      {
        timeout = 300;  # seconds
        command = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
      }
    ];

    # Lock before any system sleep (lid close, power-menu suspend, etc.)
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
      }
    ];
  };

  # Install dmenu for power-menu
  home.packages = [ pkgs.dmenu ];

  # Power menu script
  home.file.".local/bin/power-menu" = {
    text = ''
      #!/usr/bin/env bash

      # Show a small menu using dmenu.
      # If no choice is made within 15 seconds, default to "Suspend".

      CHOICES="Suspend\nHibernate\nCancel"

      choice=$(printf "$CHOICES" | timeout 15 dmenu -p "Power" 2>/dev/null)

      # If dmenu was killed by timeout or user hit Esc / empty
      if [ $? -eq 124 ] || [ -z "$choice" ]; then
        choice="Suspend"
      fi

      case "$choice" in
        Suspend)
          systemctl suspend-then-hibernate
          ;;
        Hibernate)
          systemctl hibernate
          ;;
        *)
          # Cancel or anything else: do nothing
          ;;
      esac
    '';
    executable = true;
  };
}
