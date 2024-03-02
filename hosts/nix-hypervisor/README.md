# Nix-Hypervisor

A [NixOS](https://nixos.org/) configuration for my [selfhosted](https://www.reddit.com/r/selfhosted/) server.
This repo contains everything needed to rebuild my server from scratch, with the only manual steps being in [manual-setup.md](https://github.com/THERAAB/nix-homelab/blob/main/hosts/nix-hypervisor/manual-setup.md)
and the installation instructions below.

## What's inside

- Declarative Home Assistant with [NixOS Home Assistant Module](https://nixos.wiki/wiki/Home_Assistant)
- [Microvm host](https://astro.github.io/microvm.nix/)
- Mesh VPN with [Tailscale](https://tailscale.com/)
- Reverse Proxy with [Caddy](https://caddyserver.com/docs/quick-starts/reverse-proxy)
- Monitoring/Statistics with [NetData](https://www.netdata.cloud/) and [Gatus](https://github.com/TwiN/gatus)
- WebUI for script execution with [OliveTin](https://www.olivetin.app/)
- SSL Certs with [Cloudflare](https://www.cloudflare.com/)
- Nix store cache sharing with [Harmonia](https://github.com/nix-community/harmonia)
- Backups with [SyncThing](https://syncthing.net/)


## Installation

This repo contains some customizations for my specific setup, and you likely won't be able to follow these instructions exactly
if you're not me for 3 reasons:

- You probably don't have my hardware (Intel i3 12100, 1 nvme (system files), 32GB RAM, nix-nas device for media/storage)
- You probably don't have my sops keys (shoutout to my FBI agent!)
- You likely won't have same IPs and network, firewall (pfSense), and tailscale setup

### Download NixOS

- Grab the GNOME installer from the [NixOS Downloads Page](https://nixos.org/download.html#nix-install-linux)
- Copy it onto a flash drive (I recommend [Ventoy](https://www.ventoy.net/en/index.html) for this)
- If you previously used this setup and have hardcoded DNS server in pfSense, remove it. Otherwise, you will have no DNS during install
- Tailscale cleanup of old devices
  - Disable Override local DNS
  - delete old tailscale "nix-hypervisor" device
- Boot into flash drive (Fn + F12 to load boot menu on startup)

### Get this repo so we can run some scripts

```console
nix-shell -p git
sudo git clone https://github.com/THERAAB/nix-homelab instructions
gnome-text-editor instructions/hosts/nix-hypervisor/wipe-disk-and-install.sh &
```

I recommend copy-pasting what commands you need because this script is dangerous (will wipe entire system). It also expects you to have 1 nvme device

### Reboot into console, activate SSH

```console
sudo tailscale up --ssh

# SSH from desktop
ssh nix-hypervisor
```

- Disable expiry from tailscale console.
- Update tailscale IPs in
  - share/network.properties.nix
  - tailscale DNS server settings

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

Check [manual-setup.md](https://github.com/THERAAB/nix-homelab/blob/main/hosts/nix-hypervisor/manual-setup.md) for specific manual app setups
