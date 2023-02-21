#!/bin/bash

########################################################################################################################
#                                   ---------- READ HERE FIRST ---------
#   NOTE: I recommend copy-pasting what commands you need because this script is dangerous.
#   If run fully, it will wipe entire system.
#   It also expects you to have /dev/sda device formatted as per below sections
########################################################################################################################

# ----------------------------------------------------------------------------------------------------------------------
# Wipe /dev/sda (OS Install) and reformat
# Don't do this unless you want to wipe your OS
# ----------------------------------------------------------------------------------------------------------------------
# Make partitions for /dev/sda
sudo parted /dev/sda -- mklabel gpt
sudo parted /dev/sda -- mkpart ESP fat32 1MB 512MB
sudo parted /dev/sda -- set 1 esp on
sudo parted /dev/sda -- mkpart primary btrfs 512MB 100%

# Format /dev/sda fs
sudo mkfs.fat -F 32 -n BOOT /dev/sda1
sudo mkfs.btrfs -L nixos /dev/sda2 -f

# Create btrfs subvolumes for /dev/sda
cd /
sudo mkdir -p /mnt
sudo mount /dev/disk/by-label/nixos /mnt
cd /mnt
sudo btrfs subvolume create nix
sudo btrfs subvolume create persist
cd ..
sudo umount /mnt
# ----------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------
# NixOs Setup and Install
# ----------------------------------------------------------------------------------------------------------------------
# Verify disk formatting worked
sudo fdisk -l

# Create temp dirs, Mount tmpfs & subvolumes
sudo mount -t tmpfs none /mnt
sudo mkdir -p /mnt/{home/raab,nix,boot,etc/nixos}
sudo mount -t tmpfs none /mnt/home/raab
sudo mount -o compress=zstd,noatime,subvol=nix /dev/disk/by-label/nixos /mnt/nix
sudo mkdir -p /mnt/nix/persist
sudo mount -o compress=zstd,noatime,subvol=persist /dev/disk/by-label/nixos /mnt/nix/persist
sudo mkdir -p /mnt/nix/persist/system/etc/nixos
sudo mkdir -p /mnt/nix/persist/home/raab
sudo mount -o bind /mnt/nix/persist/system/etc/nixos /mnt/etc/nixos
sudo mount /dev/disk/by-label/BOOT /mnt/boot

# Place git repo in the right spot
sudo git clone https://github.com/THERAAB/nix-homelab /mnt/nix/persist/nix-homelab
cd /mnt/nix/persist/nix-homelab

# Generate config
nixos-generate-config --root /mnt
sudo vi /mnt/etc/nixos/hardware-configuration.nix
sudo mv /mnt/etc/nixos/hardware-configuration.nix .
sudo rm /mnt/etc/nixos/configuration.nix

# Install NixOs
sudo nixos-install --flake .#nix-router

# Reboot, Remove flash drive, and go back to README.md
sudo reboot
# ----------------------------------------------------------------------------------------------------------------------