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
      config = mkMerge [
        {
          name = mkDefault name;
        }
        (mkIf (config.format == "yaml") {
          fileFormat = pkgs.formats.yaml {};
        })
        {
          result = pkgs.runCommand "${name}" { preferLocalBuild = true; } ''
            cp ${fileFormat.generate "${name}" config.fileContents} ${config.path}
          '';
        }
        {
          systemd.services.configMaker.${name} = {
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              ExecStart = "cp $result ${config.path}";
            };
          };
        }
      ];
    };
in {
  options.services.configMaker = {
    configFiles = mkOption {
     default = {};
     type = types.attrsOf (types.submodule configOpts);
    };
  };
  config = {
    systemd.services = mapAttrs' (n: v: nameValuePair "config-${n}" (lib.mkService n v)) cfg.configFiles;
  };
}