{...}: {
  virtualisation.podman.autoPrune = {
    enable = true;
    flags = ["--all"];
  };
}
