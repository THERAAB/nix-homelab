{pkgs,...}: {
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      flags = ["--all"];
    };
  };
  systemd.services.docker-auto-update = {
    script = ''
      ${pkgs.docker}/bin/podman auto-update
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
}
