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

  # Install wofi for power-menu (has better positioning options than wmenu)
  home.packages = [ pkgs.wofi ];

  # Power menu script
  home.file.".local/bin/power-menu" = {
    text = ''
      #!/usr/bin/env bash

      # Show a small menu using wofi.
      # If no choice is made within 15 seconds, default to "Sleep".
      # If user presses ESC, treat as "Cancel" (do nothing).

      CHOICES="Sleep\nLock\nShutdown\nRestart\nLog-off\nCancel"

      choice=$(printf "$CHOICES" | timeout 15 wofi --dmenu --prompt "Power" --location center 2>/dev/null)
      exit_code=$?

      # Distinguish between timeout and user cancellation
      if [ $exit_code -eq 124 ]; then
        # Timeout - default to Sleep
        choice="Sleep"
      elif [ $exit_code -ne 0 ] || [ -z "$choice" ]; then
        # User pressed ESC or cancelled - treat as Cancel
        choice="Cancel"
      fi

      case "$choice" in
        Sleep)
          systemctl suspend-then-hibernate
          ;;
        Lock)
          swaylock -f -c 000000
          ;;
        Shutdown)
          systemctl poweroff
          ;;
        Restart)
          systemctl reboot
          ;;
        Log-off)
          swaymsg exit
          ;;
        Cancel)
          # Do nothing
          ;;
        *)
          # Anything else: do nothing
          ;;
      esac
    '';
    executable = true;
  };
}
