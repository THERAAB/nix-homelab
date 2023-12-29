{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    snapper
  ];
}
