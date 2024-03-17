{self, ...}: {
  imports = [
    (self + /share/nixos/workstation)
    ./hardware.nix
  ];
  nix-homelab.workstation.enable = true;
  systemd.tmpfiles.rules = [
    "Z  /games  700 raab    -   -   -"
  ];
  programs = {
    steam.enable = true;
    gamemode = {
      enable = true;
      settings.general = {
        softrealtime = "auto";
        renice = 10;
      };
    };
  };
}
