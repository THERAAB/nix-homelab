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
    '';
  };
in
{
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
  networking.firewall.allowedTCPPorts = [ port ];
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