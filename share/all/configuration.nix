{pkgs, ...}: {
  nix = {
    # Flake setup
    package = pkgs.nixVersions.stable;
    settings.experimental-features = "nix-command flakes";
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  system.stateVersion = "23.11";
}
