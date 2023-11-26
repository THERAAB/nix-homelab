{...}: {
  services.syncthing = {
    enable = true;
    user = "raab";
    configDir = "/nix/persist/home/raab/.config/syncthing";
    openDefaultPorts = true;
    overrideDevices = true;
    overrideFolders = true;
    devices = {
      nix-zenbook.id = "H46DP2U-MISHKSS-EC64UUM-F65VNK4-QTQ2AHP-BO6CRLK-55OAZ2V-QWMGAQS";
    };
    folders = {
      Share = {
        path = "/home/raab/Documents";
        devices = ["nix-zenbook"];
      };
    };
  };
}
