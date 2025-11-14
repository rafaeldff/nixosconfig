# Suspend and hibernation configuration
#
# Goals:
# 1. Lock & blank the session after inactivity (no suspend on idle)
# 2. Suspend-then-hibernate on lid close, with lock before suspend
# 3. Power button -> interactive menu (handled by Sway)
# 4. Simple way to temporarily prevent screen lock or suspend-on-lid-close
#
# This module configures system-level (logind and systemd-sleep) behavior.
# User-level configuration (swaylock, swayidle) is in home/suspending.nix.

{ config, lib, pkgs, ... }:

{
  # Lid close -> suspend-then-hibernate
  services.logind = {
    lidSwitch = "suspend-then-hibernate";

    # No idle suspend at logind level (handled by swayidle for screen lock only)
    # Power button ignored (let Sway handle it with power-menu script)
    extraConfig = ''
      IdleAction=ignore
      HandlePowerKey=ignore
    '';
  };

  # Configure suspend-then-hibernate behavior
  # After 60min of suspend, transition to hibernate
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=60m
    SuspendState=mem
  '';
}
