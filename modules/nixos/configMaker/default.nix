{ lib, pkgs, config, options, ... }:
with lib;
let
  cfg = config.services.configMaker;
  configOpts =
    { name, ... }: {
      options = {
        name = mkOption {
          default = "config.yaml";
          type = nullOr str;
        };
        path = mkOption {
          default = null;
          type = nullOr str;
          description = lib.mdDoc "Path to resulting file";
          example = "/home/raab/config.yaml";
        };
        format = mkOption {
          default = "yaml";
          type = str;
        };
        fileContents = mkOption {
          default = null;
          type = nullOr (submodule {
            freeformType = (pkgs.formats.yaml { }).type;
          });
        };
      };
      mkService = name: value: {
        wantedBy = "multi-user.target";
        ExecStart = "cp ${format.generate "${name}" value.settings} ${value.path}";
      };
    };
in {
  options.services.configMaker = {
    configFiles = mkOption {
     default = {};
     type = types.attrsOf (types.submodule configOpts);
    };
  };
  config = {
    systemd.services = mapAttrs' (n: v: nameValuePair "config-${n}" (mkService n v)) cfg.configFiles;
  };
}