{ config, pkgs, ... }:

{

  users.users.r2 = {
    isNormalUser = true;
    #extraGroups = [ "wheel" "networkmanager" "docker" ]; # Enable ‘sudo’ for the user.
    #createHome = true;
    #uid = 1000;
  };

  home-manager.users.r2 = import ./home/fw.nix;
  home-manager.users.rafael = import ./home/fw.nix;

  services.xserver = {
    enable = true;

    displayManager.defaultSession = "none+xmonad";
    #desktopManager.xterm.enable = false;
    displayManager = {
      lightdm.enable = true;
      #sessionCommands = ''
        #${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr
        #echo "in nixos sessionCommands" | systemctl-cat -t debug_init
        #source $HOME/.profile
      #'';
    };

    #windowManager.xmonad.enable = true;
    #windowManager.xmonad.enableContribAndExtras = true;

    xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";
  };
}
