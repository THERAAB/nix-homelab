{ config, pkgs, ... }:
{
  programs.git = {
    includes = [
     { path = "/nix/persist/home/raab/.config/.gitconfig"; }
    ];
    enable = true;
    userName = "THERAAB";
    extraConfig = {
      push.autoSetupRemote = true;
    };
  };
}
