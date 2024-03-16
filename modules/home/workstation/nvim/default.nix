{
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.workstation.nvim;
in {
  options.nix-homelab.workstation.nvim = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup nvim");
  };
  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      extraConfig = ''
        set number relativenumber
        set clipboard+=unnamedplus
      '';
    };
  };
}
