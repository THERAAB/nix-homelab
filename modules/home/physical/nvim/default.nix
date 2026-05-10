{
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab;
let
  cfg = config.nix-homelab.physical.nvim;
in
{
  options.nix-homelab.physical.nvim = with types; {
    enable = mkEnableOption (lib.mdDoc "Configure neovim");
  };
  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      withRuby = false;
      withPython3 = false;
      extraConfig = ''
        set number relativenumber
        set clipboard+=unnamedplus
      '';
    };
  };
}
