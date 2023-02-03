{ config, pkgs, ... }:
let
  port = 1337;
  app-name = "olivetin";
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
  environment.systemPackages = [ olivetin ];
  systemd.services.olivetin = {
    wantedBy = [ "multi-user.target" ];

    preStart = ''
      cp --force "${configFile}" "$STATE_DIRECTORY/config.yaml"
      cp --force -r ${olivetin}/www/* "$STATE_DIRECTORY/www"
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
    "C  /nix/persist/home/raab                      -   raab    -   -   -"
    "Z  /nix/persist/home/raab/.config/sops         700 raab    -   -   -"
  ];
  networking.firewall.allowedTCPPorts = [ port ];
  services.caddy.virtualHosts = {
    "http://${app-name}.server.box".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
    "http://${app-name}.server.tail".extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString port}
    '';
    "http://127.0.0.1:${toString port}".extraConfig = ''
      root * /var/lib/OliveTin/www/
      file_server
    '';
  };
}