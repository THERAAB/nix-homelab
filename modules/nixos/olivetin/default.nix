{ lib, pkgs, config, ... }:
let
  cfg = config.services.olivetin;

  format = pkgs.formats.yaml {};
  configFile = pkgs.runCommand "config.yaml" { preferLocalBuild = true; } ''
      cp ${format.generate "config.yaml" cfg.settings} $out
    '';

in {

  options.services.olivetin = {
    enable = mkEnableOption (lib.mdDoc "OliveTin");
    settings = mkOption {
      default = null;
      type = nullOr (submodule {
        freeformType = (pkgs.formats.yaml { }).type;
      });
    };
  };

  config = mkIf cfg.enable {
    systemd.services.olivetin = {
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        cp --force "${configFile}" "$STATE_DIRECTORY/config.yaml"
        chmod 600 "$STATE_DIRECTORY/config.yaml"
      '';

      serviceConfig = {
        User = "olivetin";
        Group = "olivetin";
        ExecStart = "${pkgs.olivetin}/bin/olivetin -configdir $STATE_DIRECTORY";
        Environment="PATH=/run/wrappers/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin";
        Restart = "always";
        RuntimeDirectory = "OliveTin";
        StateDirectory = "OliveTin";
      };
    };
  };
}