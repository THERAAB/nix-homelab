{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.services.olivetin;

  format = pkgs.formats.yaml {};
  configFile = pkgs.runCommand "config.yaml" {preferLocalBuild = true;} ''
    cp ${format.generate "config.yaml" cfg.settings} $out
  '';
in {
  options.nix-homelab.services.olivetin = with types; {
    enable = mkEnableOption (lib.mdDoc "OliveTin command execution");
    settings = mkOption {
      default = null;
      type = nullOr (submodule {
        freeformType = (pkgs.formats.yaml {}).type;
      });
    };
  };

  config = mkIf cfg.enable {
    systemd.services.olivetin = {
      wantedBy = ["multi-user.target"];

      preStart = ''
        cp --force "${configFile}" "$STATE_DIRECTORY/config.yaml"
        chmod 600 "$STATE_DIRECTORY/config.yaml"
      '';

      serviceConfig = {
        User = "olivetin";
        Group = "olivetin";
        ExecStart = "${pkgs.nix-homelab.olivetin}/bin/olivetin -configdir $STATE_DIRECTORY";
        Environment = "PATH=/run/wrappers/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin";
        Restart = "always";
        RuntimeDirectory = "OliveTin";
        StateDirectory = "OliveTin";
      };
    };
  };
}
