# Nix-Router
## Note: This project is still a WIP and you probably don't want to actually use it

A [NixOS](https://nixos.org/) configuration for my [selfhosted](https://www.reddit.com/r/selfhosted/) router.
This repo contains everything needed to rebuild my router from scratch, with the only manual steps being in the installation instructions below.

## What's inside
- A router using NixOS

## Installation

This repo contains some customizations for my specific setup, and you likely won't be able to follow these instructions exactly
if you're not me for 3 reasons:
- You probably don't have my hardware (Intel J4125 CPU,  1 sda device, Intel i225 NIC)
- You probably don't have my sops keys (shoutout to my FBI agent!)
- You likely won't have same IPs, network, and tailscale setup

### Download NixOS
- Grab the GNOME installer from the [NixOS Downloads Page](https://nixos.org/download.html#nix-install-linux)
- Copy it onto a flash drive (I recommend [Ventoy](https://www.ventoy.net/en/index.html) for this)
- Tailscale cleanup of old device
    - delete old tailscale "nix-router" device
- Boot into flash drive (Fn + F12 to load boot menu on startup)

### Get this repo so we can run some scripts
```console
nix-shell -p git
sudo git clone https://github.com/THERAAB/nix-homelab instructions
gnome-text-editor instructions/hosts/nix-router/wipe-disk-and-install.sh &
```
I recommend copy-pasting what commands you need because this script is dangerous (will wipe entire system). It also
expects you to have 1 sda device as primary
### Reboot into console, activate SSH
```console
sudo tailscale up --ssh
```
- Disable expiry from tailscale console.
- Update tailscale IP in share/network.properties.nix

### Setup GitHub with SSH
Place sops keys from [Bitwarden](https://vault.bitwarden.com/#/login)
```console
vi ~/.config/sops/age/keys.txt
sudo vi /nix/persist/system/etc/ssh/ssh_host_ed25519_sops
```
Change git to SSH now that we have our SSH key
```console
ssh nix-router
cd /nix/persist/nix-homelab
git remote set-url origin git@github.com:THERAAB/nix-homelab.git
```
Finally, update, optimize store, and reboot
```console
update-full-with-git
nix-store --optimise
sudo reboot
```
