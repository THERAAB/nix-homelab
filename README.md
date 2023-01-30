# RAAB's HomeLab Server

A [NixOS](https://nixos.org/) configuration repository for my Intel 12th Gen [selfhosted](https://www.reddit.com/r/selfhosted/) server.
[NixOS](https://nixos.org/) allows you to create a fully declarative operating system using the [Nix language](https://nixos.wiki/wiki/Overview_of_the_Nix_Language).

![dashboard-png](https://github.com/THERAAB/nix-homelab/blob/main/assets/dashboard.png?raw=true "PNG of Dashboard")

## What's inside

- Declarative/Reproducible OS using [NixOS](https://nixos.org/)
- An Ephemeral root/home storage scheme (See [Erase your darlings](https://grahamc.com/blog/erase-your-darlings) and [NixOS Impermanence](https://github.com/nix-community/impermanence))
- Secret management with [sops-nix](https://github.com/Mic92/sops-nix/blob/master/README.md)
- Dependency pinning with [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- Local user declarative setup with [Home Manager](https://github.com/nix-community/home-manager)
- Declarative Home Assistant with [NixOS Home Assistant Module](https://nixos.wiki/wiki/Home_Assistant)
- Media setup with the [Servarr stack](https://wiki.servarr.com/), [Jellyfin](https://jellyfin.org/), [JellySeerr](https://github.com/Fallenbagel/jellyseerr), and [linuxserver.io](https://www.linuxserver.io/) podman images
- VPN with the [hotio qbittorrent](https://hotio.dev/containers/qbittorrent/) image
- [AdGuard Home](https://adguard.com/en/adguard-home/overview.html) for DNS adblocking
- Mesh VPN with [Tailscale](https://tailscale.com/)
- [Homer](https://github.com/bastienwirtz/homer) Dashboards for local and tailscale access
- Reverse Proxy with [caddy](https://caddyserver.com/docs/quick-starts/reverse-proxy)
- Monitoring/Statistics with [netdata](https://www.netdata.cloud/) and [gatus](https://github.com/TwiN/gatus)
- [BTRFS](https://btrfs.wiki.kernel.org/index.php/Main_Page) file system for compression and snapshots (not using right now)

## Installation

Note that it's probably a bad idea for you to try to build this if you're not me for 3 reasons:
- You probably don't have my hardware
- You probably don't have my sops keys (shoutout to my FBI agent!)
- You likely won't have same IPs and network setup

### Download NixOS
- Grab the GNOME installer from the [NixOS Downloads Page](https://nixos.org/download.html#nix-install-linux)
- Copy it onto a flash drive (I recommend [Ventoy](https://www.ventoy.net/en/index.html) for this)
- If you have hardcoded DNS server in pfSense, remove it. Otherwise, you will have no DNS during install
  - Services -> DHCP Server -> DNS Servers -> remove IP
  - Repeat for all interfaces
- Tailscale cleanup of old device
  - Disable Override local DNS
  - delete old tailscale "nix-homelab" device
- Boot into flash drive

### Get this repo so we can run some scripts
I recommend copy-pasting what commands you need because this script is dangerous (will wipe entire system). It also
expects you to have 1 nvme and 1 sda device
```console
nix-shell -p git
sudo git clone https://github.com/THERAAB/nix-homelab instructions
gnome-text-editor instructions/wipe-disk-and-install.sh &
```
### Now we can reboot into console
```console
sudo tailscale up --ssh
```
- Disable expiry from tailscale console. 
- Update tailscale IP in 
  - system/network.properties.nix 
  - tailscale DNS server settings

### SSH From Desktop
Now we can SSH in, change git to SSH now that we have our SSH key
```console
cd /nix/persist/nix-homelab
git remote set-url origin git@github.com:THERAAB/nix-homelab.git
```
Place keys.txt
```console
vi ~/.config/sops/age/keys.txt
```
Place ssh_host_ed25519_key
```console
sudo vi /nix/persist/system/etc/ssh/ssh_host_ed25519_sops
```
Finally, Update and reboot
```console
update-full-with-git
sudo reboot
```
## Manual Setup Steps
Check [manual-setup.md](https://github.com/THERAAB/nix-homelab/blob/main/manual-setup.md) for specific manual app setups

## TODO
Check [TODO.txt](https://github.com/THERAAB/nix-homelab/blob/main/TODO.txt)