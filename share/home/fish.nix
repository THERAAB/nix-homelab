{...}: {
  programs = {
    fish = {
      enable = true;
      shellAliases = {
        nox = "/nix/persist/nix-dotfiles/nox";
        cat = "bat --theme=base16-256";
        grep = "rg";
        ps = "procs";
        du = "dust";
        htop = "btm";
      };
    };
    zoxide = {
      enable = true;
      options = ["--cmd cd"];
    };
    atuin.enable = true;
    exa = {
      enable = true;
      enableAliases = true;
    };
  };
}
