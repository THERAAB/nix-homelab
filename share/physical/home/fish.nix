{...}: {
  programs = {
    fish = {
      enable = true;
      shellAliases = {
        # nox = "/nix/persist/nix-homelab/nox"; TODO: remove
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
    eza = {
      enable = true;
      enableAliases = true;
    };
  };
}
