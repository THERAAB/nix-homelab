{ config, pkgs, ... }:
{
  programs.helix = {
    enable = true;
    settings = {
      theme = "base16_default";
    };
  };
}
