{
  nix = {
    settings = {
      # Use all cores and multiple jobs
      max-jobs = "auto";
      cores    = 0;

      # Use more connections for downloads
      http-connections = 50;

      # If supported by your Nix version:
      max-substitution-jobs = 16;

      # Experimental but usually already on in 25.05
      experimental-features = [ "nix-command" "flakes" ];
    };

    # Optional: don't optimise the store automatically
    #optimise.automatic = false;
  };
}

