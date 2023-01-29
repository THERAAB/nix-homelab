#!/bin/bash

# Make GPT/fat32/btrfs partitions for nvme0n1 (nvme)
# Only do this if you want to wipe your OS/Boot drive
sudo parted /dev/nvme0n1 -- mklabel gpt
sudo parted /dev/nvme0n1 -- mkpart ESP fat32 1MB 512MB
sudo parted /dev/nvme0n1 -- set 1 esp on
sudo parted /dev/nvme0n1 -- mkpart primary btrfs 512MB 100%
# Format fs
sudo mkfs.fat -F 32 -n BOOT /dev/nvme0n1p1
sudo mkfs.btrfs -L nixos /dev/nvme0n1p2 -f
# Verify it worked
sudo fdisk -l

# Create btrfs subvolumes for OS drive
# Only if you did above
cd /
sudo mkdir -p /mnt
sudo mount /dev/disk/by-label/nixos /mnt
cd /mnt
sudo btrfs subvolume create nix
sudo btrfs subvolume create persist
cd ..
sudo umount /mnt

# Make GPT/btrfs partitions for sda (media HDD)
# Only do this if you want to wipe your media drive
sudo parted /dev/sda -- mklabel gpt
sudo parted /dev/sda -- mkpart primary btrfs 4MiB 100%
# Format media HDD fs
sudo mkfs.btrfs -L media /dev/sda1 -f
# Verify it worked
sudo fdisk -l

# Create btrfs subvolumes for media drive
# Only if you did above
sudo mount /dev/disk/by-label/media /mnt
cd /mnt
sudo btrfs subvolume create media
cd ..
sudo umount /mnt

# Verify it worked
sudo fdisk -l

# Create dirs, Mount tmpfs & subvolumes
sudo mount -t tmpfs none /mnt
sudo mkdir -p /mnt/{home/raab,nix,boot,media,etc/nixos}
sudo mount -t tmpfs none /mnt/home/raab
sudo mount -o compress=zstd,noatime,subvol=nix /dev/disk/by-label/nixos /mnt/nix
sudo mkdir -p /mnt/nix/persist
sudo mount -o compress=zstd,noatime,subvol=persist /dev/disk/by-label/nixos /mnt/nix/persist
sudo mount -o compress=zstd,noatime,subvol=media /dev/disk/by-label/media /mnt/media
sudo mkdir -p /mnt/nix/persist/system/etc/nixos
sudo mkdir -p /mnt/nix/persist/home/raab
sudo mount -o bind /mnt/nix/persist/system/etc/nixos /mnt/etc/nixos
sudo mount /dev/disk/by-label/BOOT /mnt/boot

# Setup server directory
sudo git clone https://github.com/THERAAB/nix-homelab /mnt/nix/persist/nix-homelab
cd /mnt/nix/persist/nix-homelab

# Install NixOs
sudo nixos-install --flake .#nix-homelab

sudo reboot
# Remove flash drive, and go back to README.md