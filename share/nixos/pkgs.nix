{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    neovim
    killall
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
    dos2unix
    hping
    fwts
    exa
    grc
    bat
    ripgrep
    tealdeer
    procs
    du-dust
    fd
    bottom
  ];
}
