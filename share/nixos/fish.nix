{ config, pkgs, ... }:
{
  environment.shells = with pkgs; [ fish ];
  users.defaultUserShell = pkgs.fish;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    shellAliases = {
      update-channels = "/nix/persist/nix-homelab/nixos-update-manager.sh update_channel";
      update-flake = "/nix/persist/nix-homelab/nixos-update-manager.sh update_flake";
      update-full-with-git = "/nix/persist/nix-homelab/nixos-update-manager.sh update_full";
      update-git-dotfiles = "/nix/persist/nix-homelab/nixos-update-manager.sh update_dotfiles_git";
      garbage-collect-all = "/nix/persist/nix-homelab/nixos-update-manager.sh gc";
      ls = "exa";
      la = "exa -lah";
      vi = "nvim";
    };
  };
  programs.starship = {
    enable = true;
    settings = {
      hostname = {
        ssh_only = false;
        format = "on [$hostname](bold yellow) ";
      };
      username = {
        style_user = "blue bold";
        style_root = "red bold";
        format = "[$user]($style) ";
        disabled = false;
        show_always = true;
      };
      directory = {
        format = "at [$path]($style)[$read_only]($read_only_style) ";
        read_only = " ";
      };
      git_branch = {
        format = "in [$symbol$branch(:$remote_branch)]($style) ";
      };
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      cmd_duration = {
        min_time = 100;
      };
    };
  };
  environment.systemPackages = with pkgs; [
    exa
  ];
}
