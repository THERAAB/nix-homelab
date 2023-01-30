## Manual Setup Notes
Some additional setup is needed for non-declarative apps
### Add Back DNS resolver
- Services -> DHCP Server -> DNS Servers -> nix-homelab local ip
- Re-enable override local DNS in tailscale, make sure it has new IP

### VueTorrent
- admin/adminadmin
- change user & password
- Settings > WebUi > Enable alternate UI
### Check IP Leakage
```console
sudo podman exec -it vuetorrent sh
curl https://am.i.mullvad.net/json
```

### If you want to use privoxy
- https
- nix-homelab local ip
- 8118
- https://iknowwhatyoudownload.com
- https://mullvad.net/en/check/

### Jellyfin hardware acceleration
- Dashboard > Playback
- Intel QuickSync
- Enable Tone mapping (not VPP)

### Prowlarr 
- Add indexers
  - 1337x
  - Rarbg
  - TPB
  - RuTracker.ru
- Add sonar & radarr
- Add qbittorent

### Sonar & Radarr
- Add qbittorrent
- Add movies/tv paths in sonarr/radarr and request something (needed for Jellyseerr to work)

### Jellyseerr
Set up last, make sure to do above before trying to set up

### Home Assistant
Add govee, sonoff, kasa, pushbullet, android tv and zigbee devices

### Clean up nix store
```console
update-full-with-git
garbage-collect-all
nix-store --optimise
sudo reboot
```

### Some useful commands
```console
sudo nix-env -p /nix/var/nix/profiles/system --list-generations
journalctl -b -1 -p 0..5
sops /nix/persist/nix-homelab/system/secrets/secrets.yaml
ncdu -x /
```