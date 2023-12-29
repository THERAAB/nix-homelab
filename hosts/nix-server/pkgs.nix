{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    tealdeer
  ];
}
