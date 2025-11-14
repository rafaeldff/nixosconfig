{ ... }:

{
  imports = [
    ./common.nix
    ./suspending.nix
  ];
  home.stateVersion = "22.05";

  # Various options that are specific for this machine/user.
}
