{ config, pkgs, lib, ... }:
{
  services.gvfs.enable = true;

  
  #------------------------------------------
  # GDM wayland only
  #------------------------------------------
  # https://github.com/NixOS/nixpkgs/issues/57602#issuecomment-657762138
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  # Extracted from nixos/modules/services/x11/xserver.nix
  systemd.defaultUnit = "graphical.target";
  #  systemd.services.display-manager =
  #    let
  #      cfg = config.services.xserver.displayManager;
  #    in
  #    {
  #      description = "Display Manager";
  #
  #      after = [ "acpid.service" "systemd-logind.service" ];
  #
  #      restartIfChanged = false;
  #
  #      environment =
  #        lib.optionalAttrs
  #          config.hardware.opengl.setLdLibraryPath {
  #          LD_LIBRARY_PATH = pkgs.addOpenGLRunpath.driverLink;
  #        } // cfg.job.environment;
  #
  #      preStart =
  #        ''
  #          ${cfg.job.preStart}
  #
  #          rm -f /tmp/.X0-lock
  #        '';
  #
  #      script = "${cfg.job.execCmd}";
  #
  #      serviceConfig = {
  #        Restart = "always";
  #        RestartSec = "200ms";
  #        SyslogIdentifier = "display-manager";
  #        # Stop restarting if the display manager stops (crashes) 2 times
  #        # in one minute. Starting X typically takes 3-4s.
  #        StartLimitInterval = "30s";
  #        StartLimitBurst = "3";
  #        # trace: warning: Service 'display-manager.service' uses the attribute 'StartLimitInterval' in the Service section, which is deprecated. See https://github.com/NixOS/nixpkgs/issues/45786.
  #
  #      };
  #    };

  # make new tabs/shells use the previous directory
  #environment.interactiveShellInit = ''
    #if [[ "$VTE_VERSION" > 3405 ]]; then
      #source "${pkgs.gnome.vte}/etc/profile.d/vte.sh"
    #fi
  #'';



  #------------------------------------------
  # _sway 
  #------------------------------------------

  environment.pathsToLink = [ "/libexec" ]; # enable polkit
  #networking.networkmanager.enable = true;
  #programs.sway = {
    #enable = true;
    #wrapperFeatures.gtk = true; # so that gtk works properly
    #extraPackages = with pkgs; [
      #swaylock # lockscreen
      #swayidle
      #xwayland # for legacy apps
      #waybar # status bar
      #mako # notification daemon
      #kanshi # autorandr
      #dmenu
      #wofi # replacement for dmenu
      #brightnessctl
      #gammastep # make it red at night!
      #sway-contrib.grimshot # screenshots
      #swayr

      #gnome.gnome-terminal
      #gnome.gnome-system-monitor
      #mate.caja
      #gnome.nautilus
      #evince

      ## https://discourse.nixos.org/t/some-lose-ends-for-sway-on-nixos-which-we-should-fix/17728/2?u=senorsmile
      #gnome3.adwaita-icon-theme # default gnome cursors
      #glib                      # gsettings
      #dracula-theme             # gtk theme (dark)
      #gnome.networkmanagerapplet
    #];

  #};
}
