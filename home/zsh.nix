{ config, pkgs, ... }:
let
  update-script = "/nix/persist/server/nixos-update-manager.sh";
in
{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    shellAliases = {
      update-channels = "${update-script} update_channel";
      update-flake = "${update-script} update_flake";
      update-full-with-git = "${update-script} update_full";
      update-git-dotfiles = "${update-script} update_dotfiles_git";
      garbage-collect-all = "${update-script} gc";
    };
    initExtra = '' export EDITOR="nvim" '';
  };
}
