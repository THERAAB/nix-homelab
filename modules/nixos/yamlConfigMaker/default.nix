{ lib, pkgs, config, options, ... }:
with lib;
let
  format = pkgs.formats.yaml {};
  cfg = config.services.yamlConfigMaker;
  configOpts =
    { name, ... }: {
      options = {
        name = mkOption {
          default = null;
          type = with types; nullOr str;
        };
        path = mkOption {
          default = null;
          type = with types; nullOr str;
          description = lib.mdDoc "Path to resulting file";
          example = "/home/raab/config.yaml";
        };
        settings = mkOption {
          default = null;
          type = with types; nullOr (submodule {
            freeformType = (format { }).type;
          });
        };
      };
    };
  mkService = name: value: {
    wantedBy = ["multi-user.target"];
    script = "cp ${format.generate "${name}" value.settings} ${value.path}";
  };
in {
  options.services.yamlConfigMaker = mkOption {
    default = {};
    type = types.attrsOf (types.submodule configOpts);
  };
  config = {
    systemd.services = mapAttrs' (n: v: nameValuePair "yamlConfigMaker-${n}" (mkService n v)) cfg;
  };
}