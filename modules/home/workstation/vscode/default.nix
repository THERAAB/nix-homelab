{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.workstation.vscode;
in {
  options.nix-homelab.workstation.vscode = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup vscode");
  };
  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      # package = pkgs.vscodium;
      mutableExtensionsDir = false;
      userSettings = {
        "[nix]" = {
          "editor.tabSize" = 2;
          "editor.defaultFormatter" = "kamadorueda.alejandra";
        };
        "editor.formatOnPaste" = true;
        "editor.formatOnSave" = true;
        "editor.formatOnType" = false;
        "editor.fontFamily" = "JetBrainsMono Nerd Font";
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "editor.cursorBlinking" = "smooth";
        "editor.fontLigatures" = true;
        "editor.minimap.enabled" = false;
        "window.titleBarStyle" = "custom";
        "window.openFoldersInNewWindow" = "on";
        "window.menuBarVisibility" = "compact";
        "workbench.colorTheme" = "Catppuccin Frappé";
        "workbench.startupEditor" = "none";
        "workbench.iconTheme" = "vscode-icons";
        "files.trimFinalNewlines" = true;
        "files.autoSave" = "afterDelay";
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "extensions.experimental.affinity"."asvetliakov.vscode-neovim" = 1;
        "telemetry.telemetryLevel" = "off";
        "explorer.confirmDelete" = false;
        "vsicons.dontShowNewVersionMessage" = true;
        "search.defaultViewMode" = "tree";
        "alejandra.program" = "alejandra";
        "editor.lineNumbers" = "relative";
        "explorer.confirmDragAndDrop" = false;
        "security.workspace.trust.untrustedFiles" = "open";
        "update.mode" = "none";
        "files.enableTrash" = false;
      };
      extensions = with pkgs.vscode-extensions; [
        catppuccin.catppuccin-vsc
        jnoortheen.nix-ide
        asvetliakov.vscode-neovim
        kamadorueda.alejandra
        esbenp.prettier-vscode
        vscode-icons-team.vscode-icons
        christian-kohler.path-intellisense
        tailscale.vscode-tailscale
      ];
    };
  };
}
