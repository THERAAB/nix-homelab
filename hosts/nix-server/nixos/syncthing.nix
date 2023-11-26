{...}: {
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    overrideDevices = true;
    overrideFolders = true;
    devices = {
      nix-zenbook.id = "M3OWV56-LFY5O5S-AYUOLEL-AOJN6FS-E3LA3XY-6QUG5MV-TIDRRNY-C3YS7AT";
    };
    folders = {
      "Share" = {
        path = "/home/raab/Documents";
        devices = ["nix-zenbook"];
      };
    };
  };
}
