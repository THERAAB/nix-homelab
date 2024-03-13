{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  format = pkgs.formats.yaml {};
  cfg = config.nix-homelab.services.yamlConfigMaker;
  configOpts = {name, ...}: {
    options = {
      name = mkOption {
        default = null;
        type = with types; nullOr str;
      };
      path = mkOption {
        default = null;
        type = with types; nullOr str;
        description = lib.mdDoc "Path to resulting file";
        example = "/path/to/config.yaml";
      };
      settings = mkOption {
        default = null;
        type = with types;
          nullOr (submodule {
            freeformType = (pkgs.formats.yaml {}).type;
          });
      };
    };
  };
  mkService = name: value: {
    wantedBy = ["multi-user.target"];
    script = "cp ${format.generate "${name}" value.settings} ${value.path}";
  };
in {
  options.nix-homelab.services.yamlConfigMaker = mkOption {
    default = {};
    type = types.attrsOf (types.submodule configOpts);
  };
  config = {
    systemd.services = mapAttrs' (n: v: nameValuePair "yamlConfigMaker-${n}" (mkService n v)) cfg;
  };
}
