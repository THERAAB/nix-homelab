{pkgs, ...}: {
  virtualisation.oci-containers.backend = "docker";
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      flags = ["--all"];
    };
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  systemd.services.docker-auto-update = {
    script = ''
      ${pkgs.docker}/bin/docker auto-update
    '';
    after = ["docker.service"];
    requires = ["docker.service"];
  };
  systemd.timers.docker-auto-update = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = "true";
      Unit = "docker-auto-update.service";
    };
  };
}