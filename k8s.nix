{ config, pkgs, ... }:

let
  baseUrl = "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads";
in
{
  environment.systemPackages =
  with pkgs; [
    #google-cloud-sdk
    (google-cloud-sdk.overrideAttrs (old: rec {
      version = "200.0.0";
      name = "google-cloud-sdk-${version}";
      src = fetchurl {
        url = "${baseUrl}/${name}-linux-x86_64.tar.gz";
        sha256 = "0sr256w0jvjwgbqhgrvzwswrx7gh78b2q2hfwlnnbnmn2adlr4sv";
      };
    }))
    cfssl
		kubernetes
    #(kubernetes.overrideAttrs (old: rec {
      #version = "1.10.3"; 
			#src = fetchFromGitHub {
				#owner = "kubernetes";
				#repo = "kubernetes";
				#rev = "v${version}";
				#sha256 = "1la9cdf5a67kg72xn4bn5mib1caiv5vxsjmnxqsmx0m7vhbv5i4n";
			#};
		#}))
	];

}
