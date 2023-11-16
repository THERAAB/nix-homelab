{...}: {
  programs = {
    fish = {
      enable = true;
      shellAliases = {
        nox = "/nix/persist/nix-homelab/nox";
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
    # atuin.enable = true;
    eza = {
      enable = true;
      enableAliases = true;
    };
  };
}
