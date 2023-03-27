{ config, pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    colorschemes.nord = {
      enable = true;
      disable_background = true;
    };
    plugins = {
      lightline.enable = true;
      bufferline.enable = true;
      nvim-tree.enable = true;
      nvim-cmp.enable = true;
      telescope.enable = true;
      treesitter.enable = true;
    };
    options = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
    };
    extraPlugins = with pkgs.vimPlugins; [
      vim-nix
      nvim-web-devicons
    ];
  };
}
