# Nix-Homelab

A [NixOS](https://nixos.org/) configuration repository for my [selfhosted](https://www.reddit.com/r/selfhosted/) homelab.
[NixOS](https://nixos.org/) allows you to create a fully declarative operating system using the [Nix language](https://nixos.wiki/wiki/Overview_of_the_Nix_Language).
This repo contains everything needed to rebuild my homelab from scratch, with the only manual steps being in the README files below.

![dashboard-png](https://github.com/THERAAB/nix-homelab/blob/main/assets/screenshots/dashboard.png?raw=true "PNG of Dashboard")

## What's inside

My NixOS Homelab, with each machine having some shared configuration

- Declarative/Reproducible builds using [NixOS](https://nixos.org/)
- [Microvm.nix](https://astro.github.io/microvm.nix/) for microvm servers
- [Snowfall](https://snowfall.org/guides/lib/quickstart/) project structure
- An Ephemeral root/home storage scheme (See [Erase your darlings](https://grahamc.com/blog/erase-your-darlings) and [NixOS Impermanence](https://github.com/nix-community/impermanence))
- Secret management with [sops-nix](https://github.com/Mic92/sops-nix/blob/master/README.md)
- Dependency pinning with [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [BTRFS](https://btrfs.wiki.kernel.org/index.php/Main_Page) file system (Copy on Write, Compression)
- Local user declarative setup with [Home Manager](https://github.com/nix-community/home-manager)
- Check the `nox` command [here](https://github.com/THERAAB/nix-homelab/blob/main/modules/nixos/utils/nox/default.nix) for common maintenance tasks

### Machines

#### Nix-Hypervisor

Hypervisor for various Microvms, see [The Nix-Hypervisor README.md](https://github.com/THERAAB/nix-homelab/blob/main/systems/x86_64-linux/nix-hypervisor/README.md)

#### Nix-Nas

Nixos config for my nfs/media NAS, see [The Nix-Nas README.md](https://github.com/THERAAB/nix-homelab/blob/main/systems/x86_64-linux/nix-nas/README.md)

#### Nix-Desktop

My desktop, see [Nix-Desktop README.md](https://github.com/THERAAB/nix-homelab/blob/main/systems/x86_64-linux/nix-desktop/README.md)

#### Nix-Zenbook

My laptop, see [Nix-Zenbook README.md](https://github.com/THERAAB/nix-homelab/blob/main/systems/x86_64-linux/nix-zenbook/README.md)
