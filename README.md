# Nix-Homelab

A [NixOS](https://nixos.org/) configuration repository for my [selfhosted](https://www.reddit.com/r/selfhosted/) homelab.
[NixOS](https://nixos.org/) allows you to create a fully declarative operating system using the [Nix language](https://nixos.wiki/wiki/Overview_of_the_Nix_Language).
This repo contains everything needed to rebuild my homelab from scratch, with the only manual steps being in the README files below.

![dashboard-png](https://github.com/THERAAB/nix-homelab/blob/main/share/assets/screenshots/dashboard.png?raw=true "PNG of Dashboard")

## What's inside

My NixOS Homelab, with each machine having some shared configuration

- Declarative/Reproducible builds using [NixOS](https://nixos.org/)
- An Ephemeral root/home storage scheme (See [Erase your darlings](https://grahamc.com/blog/erase-your-darlings) and [NixOS Impermanence](https://github.com/nix-community/impermanence))
- Secret management with [sops-nix](https://github.com/Mic92/sops-nix/blob/master/README.md)
- Dependency pinning with [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- Local user declarative setup with [Home Manager](https://github.com/nix-community/home-manager)
- [BTRFS](https://btrfs.wiki.kernel.org/index.php/Main_Page) file system (Copy on Write, Compression)

## Nix-Hypervisor

Hypervisor for various Microvms, see [The Nix-Hypervisor README.md](https://github.com/THERAAB/nix-homelab/blob/main/hosts/nix-hypervisor/README.md)

## Nix-Nas

See [The Nix-Nas README.md](https://github.com/THERAAB/nix-homelab/blob/main/hosts/nix-nas/README.md)

## Micro-Media

A Microvm for my media setup, see [The Micro-Media README.md](https://github.com/THERAAB/nix-homelab/blob/main/hosts/micro-media/README.md)

## Micro-Server

A Microvm for my server setup, see [The Micro-Server README.md](https://github.com/THERAAB/nix-homelab/blob/main/hosts/micro-server/README.md)

## Micro-Unifi

A Microvm for unifi controller/adguard, see [The Micro-Unifi README.md](https://github.com/THERAAB/nix-homelab/blob/main/hosts/micro-unifi/README.md)

## Maintenance

These commands might help with some common maintenance tasks

```console
# Check recent NixOs generations
sudo nix-env -p /nix/var/nix/profiles/system --list-generations

# Check last boot logs of certain priority (0-5)
journalctl -b -1 -p 0..5

# Add/modify secrets
sops /nix/persist/nix-homelab/share/secrets/secrets.yaml

# See anything not persisted by NixOs Persistence module (non 0B files will be wiped on boot)
ncdu -x /

# List systemd units
systemctl list-units

# Check unit failures
journalctl -u ${unit-name}

# Update microvm
sudo microvm -Ru ${microvm}
```
