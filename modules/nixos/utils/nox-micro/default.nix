{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.utils.nox-micro;
in {
  options.nix-homelab.utils.nox-micro = with types; {
    enable = mkEnableOption (lib.mdDoc "Nox for microvms");
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [
      (
        pkgs.writeScriptBin "nox-micro" ''

          #!/bin/sh
          # nox-micro: NixOs eXecute microvm



        ''
      )
    ];
  };
}
