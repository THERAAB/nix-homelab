# Nix-Desktop

A [NixOS](https://nixos.org/) configuration repository for my desktop dotfiles.

## What's inside

- [GNOME](https://www.gnome.org/) on [Wayland](https://wiki.archlinux.org/title/Wayland)
- [Catppuccin](https://github.com/catppuccin/catppuccin) for theming
- [Forge](https://github.com/forge-ext/forge) for tiling window management

## Installation

This repo contains some customizations for my specific setup, and you likely won't be able to follow these instructions exactly
if you're not me for 3 reasons:

- You probably don't have my hardware (Ryzen 7700X, Radeon 7900XTX, ASRock X670E Pro RS, 4 nvme)
- You probably don't have my sops keys (shoutout to my FBI agent!)
- You likely won't have same IPs and network, firewall (pfSense), and tailscale setup

### Download NixOS

- Grab the GNOME installer from the [NixOS Downloads Page](https://nixos.org/download.html#nix-install-linux)
- Copy it onto a flash drive (I recommend [Ventoy](https://www.ventoy.net/en/index.html) for this)
- Tailscale cleanup of old device
- Boot into flash drive (F11 to load boot menu on startup)

### Get this repo so we can run some scripts

```console
nix-shell -p git
sudo git clone https://github.com/THERAAB/nix-homelab instructions
gnome-text-editor instructions/systems/x86_64-linux/nix-desktop/wipe-disk-and-install.sh &
```

I recommend copy-pasting what commands you need because this script is dangerous (will wipe entire system). It also
expects you to have 4 nvme devices to be run in RAID 0 on btrfs

### Reboot, activate tailscale

```console
sudo tailscale up
```

### Setup GitHub with SSH

Place sops keys from [Bitwarden](https://vault.bitwarden.com/#/login)

```console
vi ~/.config/sops/age/keys.txt
sudo vi /nix/persist/system/etc/ssh/ssh_host_ed25519_sops
```

Change git to SSH now that we have our SSH key

```console
cd /nix/persist/nix-homelab
git remote set-url origin git@github.com:THERAAB/nix-homelab.git
```

Finally, update, optimize store, and reboot

```console
nox update
nix-store --optimise
sudo reboot
```

Check [manual-setup.md](https://github.com/THERAAB/nix-homelab/blob/main/systems/x86_64-linux/nix-desktop/manual-setup.md) for specific manual app setups
