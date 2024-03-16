#!/bin/bash

########################################################################################################################
#                                   ---------- READ HERE FIRST ---------
#   NOTE: I recommend copy-pasting what commands you need because this script is dangerous.
#   If run fully, it will wipe entire system.
#   It also expects you to have /dev/nvme0n1 formatted as per below sections
########################################################################################################################

# ----------------------------------------------------------------------------------------------------------------------
# Wipe /dev/nvme0n1 (Bootloader & OS Install) and reformat
# Don't do this unless you want to wipe your OS
# ----------------------------------------------------------------------------------------------------------------------
# Make partitions for /dev/nvme0n1
sudo parted /dev/nvme0n1 -- mklabel gpt
sudo parted /dev/nvme0n1 -- mkpart ESP fat32 1MB 512MB
sudo parted /dev/nvme0n1 -- set 1 esp on
sudo parted /dev/nvme0n1 -- mkpart primary btrfs 512MB 100%

# Format /dev/nvme0n1 boot fs
sudo mkfs.fat -F 32 -n BOOT /dev/nvme0n1p1
# Create btrfs volume on /dev/nvme0n1
sudo mkfs.btrfs -f -L nixos /dev/nvme0n1p2

# ----------------------------------------------------------------------------------------------------------------------
# NixOs Setup and Install
# ----------------------------------------------------------------------------------------------------------------------
# Verify disk formatting worked
sudo fdisk -l

# Then Create btrfs subvolumes
cd /
sudo mkdir -p /mnt
sudo mount /dev/disk/by-label/nixos /mnt
cd /mnt
sudo btrfs subvolume create nix
sudo btrfs subvolume create persist
sudo btrfs subvolume create sync
sudo btrfs subvolume create swap
cd ..
sudo umount /mnt

# Create dirs, Mount tmpfs & subvolumes
sudo mount -t tmpfs none /mnt
sudo mkdir -p /mnt/{home/raab,nix,boot,sync,etc/nixos,swap}
sudo mount -t tmpfs none /mnt/home/raab
sudo mount -o compress=zstd,noatime,subvol=nix /dev/disk/by-label/nixos /mnt/nix
sudo mkdir -p /mnt/nix/persist
sudo mount -o compress=zstd,noatime,subvol=persist /dev/disk/by-label/nixos /mnt/nix/persist
sudo mount -o compress=zstd,noatime,subvol=sync /dev/disk/by-label/nixos /mnt/sync
sudo mkdir -p /mnt/nix/persist/system/etc/nixos
sudo mkdir -p /mnt/nix/persist/home/raab
sudo mount -o bind /mnt/nix/persist/system/etc/nixos /mnt/etc/nixos
sudo mount /dev/disk/by-label/BOOT /mnt/boot

# Make Swapfile
sudo mount -o compress=no,noatime,subvol=swap /dev/disk/by-label/nixos /mnt/swap
sudo truncate -s 0 /mnt/swap/swapfile
sudo chattr +C /mnt/swap/swapfile
sudo dd if=/dev/zero of=/mnt/swap/swapfile bs=1M count=8192
sudo chmod 0600 /mnt/swap/swapfile
sudo mkswap /mnt/swap/swapfile

# Place git repo in the right spot
cd /mnt/nix/persist
sudo git clone https://github.com/THERAAB/nix-homelab /mnt/nix/persist/nix-homelab
cd /mnt/nix/persist/nix-homelab

# Before nix-install we need to place ssdt-csc3551 in /boot to fix audio
sudo cp /mnt/nix/persist/nix-homelab/systems/x86_64-linux/nix-zenbook/ssdt-csc3551.aml /mnt/boot

# Install NixOs
sudo nixos-install --flake .#nix-zenbook

# Reboot, Remove flash drive, and go back to README.md
sudo reboot
# ----------------------------------------------------------------------------------------------------------------------
