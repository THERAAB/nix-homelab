{pkgs, ...}: {
  environment.shells = with pkgs; [fish];
  users.defaultUserShell = pkgs.fish;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      zoxide init --cmd cd fish | source
    '';
    shellAliases = {
      nox = "/nix/persist/nix-homelab/nox";
      ls = "exa";
      la = "exa -lah";
      cat = "bat --theme=base16-256";
      grep = "rg";
      ps = "procs";
      du = "dust";
      htop = "btm";
    };
  };
}
