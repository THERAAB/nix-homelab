{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim
    neovim
    killall
    htop
    parted
    hdparm
    pciutils # for lspci
    lshw
    libva-utils
    clinfo
    wget
    unzip
    usbutils
    age
    sops
    ssh-to-age
    netavark # for podman to stop flooding logs
  ];
}
