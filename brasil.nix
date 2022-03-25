{ config, pkgs, ... }:

let
  tzVersion = "2019c";
in
  {
    # Set your time zone.
    time.timeZone = "America/Sao_Paulo";
  }

