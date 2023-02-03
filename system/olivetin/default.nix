{ config, pkgs, ... }:
let
  port = 1337;
  uid = 62893;
  gid = 62893;
  app-name = "olivetin";
  www-dir = "/var/www/${app-name}";
  scripts-dir = "/nix/persist/${app-name}/scripts";
  configFile = "/nix/persist/nix-homelab/system/${app-name}/config.yaml";

  shellScript = pkgs.writeShellScript "commands.sh" ''
    case "$1" in
      reboot)
        reboot now;;
      jellyfin_reboot)
        podman stop jellyfin
        sleep 1
        podman start jellyfin
    esac
  '';

  olivetin = pkgs.stdenv.mkDerivation rec {
    pname = "OliveTin";
    version = "2022.11.14";
    src = pkgs.fetchurl {
      url = "https://github.com/OliveTin/OliveTin/releases/download/${version}/OliveTin-linux-amd64.tar.gz";
      sha256 = "sha256-7vviqktDhFTjFEjLEbgqcwUxyqRTvAUNNwta02pEz5E=";
    };
    installPhase = ''
      install -m755 -D ./OliveTin $out/bin/olivetin
      mkdir -p $out/www
      cp -r webui/* $out/www/
    '';
  };

in
{
  users = {
    groups.${app-name}.gid = gid;
    users.${app-name} = {
      group = app-name;
      uid = uid;
      isSystemUser = true;
    };
    users.caddy.extraGroups = [ app-name ];
  };
  environment.systemPackages = [ olivetin ];
  systemd.services.olivetin = {
    wantedBy = [ "multi-user.target" ];

    preStart = ''
      cp --force "${configFile}" "$STATE_DIRECTORY/config.yaml"
      chmod 600 "$STATE_DIRECTORY/config.yaml"
    '';

    serviceConfig = {
      User = "olivetin";
      Group = "olivetin";
      ExecStart = "${olivetin}/bin/olivetin -configdir $STATE_DIRECTORY";
      Environment="PATH=/run/wrappers/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin";
      Restart = "always";
      RuntimeDirectory = "OliveTin";
      StateDirectory = "OliveTin";
    };
  };
  systemd.tmpfiles.rules = [
    "R  ${www-dir}                    -           -               -               -   -                                 "
    "C  ${www-dir}                    -           -               -               -   ${olivetin}/www                   "
    "r  ${scripts-dir}/commands.sh    -           -               -               -   -                                 "
    "L  ${scripts-dir}/commands.sh    -           -               -               -   ${shellScript}                    "
    "r  ${www-dir}/customIcons        -           -               -               -   -                                 "
    "L  ${www-dir}/customIcons        -           -               -               -   /nix/persist/nix-homelab/icons    "
    "Z  ${scripts-dir}                700         root            root            -   -                                 "
    "Z  ${www-dir}                    770         ${app-name}     ${app-name}     -   -                                 "
  ];
  networking.firewall.allowedTCPPorts = [ port ];
  services.caddy.virtualHosts = {
    "http://${app-name}.server.box".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
    "http://${app-name}.server.tail".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
  };
}