{ config, pkgs, ... }:

let
  tzVersion = "2019c";
in
  {
    # Set your time zone.
    time.timeZone = "America/Sao_Paulo";

    environment.systemPackages =
    with pkgs; [
      (tzdata.overrideAttrs (old: rec {
	name = "tzdata-${tzVersion}";
	version = tzVersion;

	srcs =
	[ (fetchurl {
	  url = "https://data.iana.org/time-zones/releases/tzdata${tzVersion}.tar.gz";
	  sha256 = "0z7w1yv37cfk8yhix2cillam091vgp1j4g8fv84261q9mdnq1ivr";
	})
	(fetchurl {
	  url = "https://data.iana.org/time-zones/releases/tzcode${tzVersion}.tar.gz";
	  sha256 = "1m3y2rnf1nggxxhxplab5zdd5whvar3ijyrv7lifvm82irkd7szn";
	  })
	  ];
	  }))

	];
      }

