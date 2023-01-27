{ config, pkgs, ... }:
{
  programs.git = {
    includes = [
     { path = "/home/raab/.config/.gitconfig"; }
    ];
    enable = true;
    userName = "THERAAB";
    extraConfig = {
      push.autoSetupRemote = true;
    };
  };
}
