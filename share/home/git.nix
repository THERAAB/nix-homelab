{ config, pkgs, ... }:
let
  local-config-dir = "/nix/persist/home/raab/.config/";
in
{
  programs.git = {
    includes = [
     { path = "${local-config-dir}/.gitconfig"; }
    ];
    enable = true;
    userName = "THERAAB";
    extraConfig = {
      push.autoSetupRemote = true;
    };
  };
}
