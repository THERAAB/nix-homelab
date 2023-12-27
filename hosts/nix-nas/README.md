# Nix-Server

A [NixOS](https://nixos.org/) configuration for my [selfhosted](https://www.reddit.com/r/selfhosted/) Network Attached Storage (NAS).
This repo contains everything needed to rebuild my server from scratch, with the only manual steps being in [manual-setup.md](https://github.com/THERAAB/nix-homelab/blob/main/hosts/nix-nas/manual-setup.md)
and the installation instructions below.

## What's inside

#TODO: Add

## Installation

This repo contains some customizations for my specific setup, and you likely won't be able to follow these instructions exactly
if you're not me for 3 reasons:

- You probably don't have my hardware (Terramaster F4-223, 1TB NVME, 2x8GB DDR4 SODIMM RAM)
- You probably don't have my sops keys (shoutout to my FBI agent!)
- You likely won't have same IPs and network, firewall (pfSense), and tailscale setup

### Download NixOS

- Grab the GNOME installer from the [NixOS Downloads Page](https://nixos.org/download.html#nix-install-linux)
- Copy it onto a flash drive (I recommend [Ventoy](https://www.ventoy.net/en/index.html) for this)
- Tailscale cleanup of old device
- Boot into flash drive (DEL to load boot menu on startup)

### Get this repo so we can run some scripts

```console
nix-shell -p git
sudo git clone https://github.com/THERAAB/nix-homelab instructions
gnome-text-editor instructions/hosts/nix-nas/wipe-disk-and-install.sh &
```

I recommend copy-pasting what commands you need because this script is dangerous (will wipe entire system). It also
expects you to have 1 nvme device

### Reboot into console, activate SSH

```console
sudo tailscale up --ssh

# SSH from desktop
ssh nix-nas
```

- Disable expiry from tailscale console.
- Update tailscale IP in
  - share/network.properties.nix

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
update-full-with-git
nix-store --optimise
sudo reboot
```

Check [manual-setup.md](https://github.com/THERAAB/nix-homelab/blob/main/hosts/nix-nas/manual-setup.md) for specific manual app setups
