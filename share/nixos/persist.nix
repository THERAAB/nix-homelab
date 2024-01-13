{...}: {
  systemd.tmpfiles.rules = [
    "d  /nix/persist/home/raab                      -   raab    -   -   -               "
    "d  /nix/persist/home/raab/.config/sops/age     700 raab    -   -   -               "
    "d  /nix/persist/nix-homelab                    -   raab    -   -   -               "
    "Z  /nix/persist/nix-homelab                    -   raab    -   -   -               "
    "z  /nix/persist/nix-homelab/nox                744 raab    -   -   -               "
    "Z  /nix/persist/home/raab                      740 raab    -   -   -               "
    "Z  /nix/persist/home/raab/.ssh                 700 raab    -   -   -               "
    "Z  /nix/persist/home/raab/.config/sops         700 raab    -   -   -               "
    "L  /nix/persist/home/raab/.config/.gitconfig   -   -       -   -   /etc/gitconfig  "
  ];
  programs.fuse.userAllowOther = true;
  environment.persistence."/nix/persist/system" = {
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/log"
      "/var/lib/"
      "/var/cache/netdata"
      "/var/www/"
      "/etc/NetworkManager/system-connections"
      "/etc/ssh"
    ];
    files = [
      "/etc/machine-id"
      {
        file = "/etc/nix/id_rsa";
        parentDirectory = {mode = "u=rwx,g=,o=";};
      }
    ];
  };
}
