{pkgs, ...}: {
  virtualisation.podman.autoPrune = {
    enable = true;
    flags = ["--all"];
  };
  systemd.services.podman-auto-update = {
    script = ''
      ${pkgs.podman}/bin/podman auto-update
    '';
    after = ["podman.service"];
    requires = ["podman.service"];
  };
}
