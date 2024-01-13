{pkgs, ...}: {
  virtualisation.podman = {
    defaultNetwork.settings.dns_enabled = false;
    autoPrune = {
      enable = true;
      flags = ["--all"];
    };
  };
  systemd.services.podman-auto-update = {
    script = ''
      ${pkgs.podman}/bin/podman auto-update
    '';
    after = ["podman.service"];
    requires = ["podman.service"];
  };
  systemd.timers.podman-auto-update = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = "true";
      Unit = "podman-auto-update.service";
    };
  };
}
