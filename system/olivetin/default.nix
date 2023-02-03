{ config, pkgs, ... }:
let
  port = 1337;
  app-name = "olivetin";
  local-config-dir = "/nix/persist/${app-name}";
  system-config-dir = "/nix/persist/nix-homelab/system/${app-name}";
  uid = 1778;
  gid = 1778;

  olivetin = pkgs.stdenv.mkDerivation rec {
    pname = "OliveTin";
    version = "2022.11.14";
    src = pkgs.fetchurl {
      url = "https://github.com/OliveTin/OliveTin/releases/download/${version}/OliveTin-linux-amd64.tar.gz";
      sha256 = "";
    };
    installPhase = ''
      mkdir -p $out/bin
      echo hello
      ls
      pwd
    '';
  };
in
{
  environment.systemPackages = [ olivetin ];
  users = {
    groups.${app-name}.gid = gid;
    users.${app-name} = {
      group = app-name;
      uid = uid;
      isSystemUser = true;
    };
  };
  systemd.tmpfiles.rules = [
    "d    ${local-config-dir}                   -       -             -               -   -                                 "
    "r    ${local-config-dir}/config.yaml       -       -             -               -   -                                 "
    "C    ${local-config-dir}/config.yaml       -       -             -               -   ${system-config-dir}/config.yaml  "
    "Z    ${local-config-dir}                   740     ${app-name}   ${app-name}     -   -                                 "
  ];
  services.caddy.virtualHosts = {
    "http://${app-name}.server.box".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
    "http://${app-name}.server.tail".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
  };
}