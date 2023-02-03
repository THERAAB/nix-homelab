{ config, pkgs, ... }:
let
  ui-port = 1338;
  backend-port = 1337;
  uid = 62893;
  gid = 62893;
  app-name = "olivetin";
  www-dir = "/nix/persist/${app-name}/www";
  configFile = "/nix/persist/nix-homelab/system/${app-name}/config.yaml";

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
      DynamicUser = true;
      ExecStart = "${olivetin}/bin/olivetin -configdir $STATE_DIRECTORY";
      Restart = "always";
      RuntimeDirectory = "OliveTin";
      StateDirectory = "OliveTin";
    };
  };
  systemd.tmpfiles.rules = [
    "C    ${www-dir}    -       -             -               -   ${olivetin}/www   "
    "Z    ${www-dir}    770     ${app-name}   ${app-name}     -   -                 "
  ];
  networking.firewall.allowedTCPPorts = [ ui-port backend-port ];
  services.caddy.virtualHosts = {
    "http://${app-name}.server.box".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString ui-port}
    '';
    "http://${app-name}.server.tail".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString ui-port}
    '';
    "http://127.0.0.1:${toString ui-port}".extraConfig = ''
      root * ${www-dir}
      file_server
    '';
  };
}