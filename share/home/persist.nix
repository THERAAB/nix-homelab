{...}: {
  home.persistence."/nix/persist/home/raab" = {
    allowOther = true;
    directories = [
      ".config/sops/age"
      ".config/fish"
      ".cache.tealdeer"
      ".cache/nvim"
      ".local/share/fish"
      ".local/share/zoxide"
    ];
    files = [
      ".ssh/known_hosts"
      ".ssh/id_rsa"
    ];
  };
}
