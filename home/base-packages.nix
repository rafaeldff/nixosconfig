{ config, pkgs, ... }:

{

  home.packages =
    with pkgs; [
    wget
    git
    # vim (conflicts with vim-full)
  ];


}
