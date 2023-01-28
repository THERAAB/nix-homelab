Some additional setup is needed for non-declarative apps
### Check IP Leakage
```console
sudo podman exec -it vuetorrent sh
curl https://am.i.mullvad.net/json
```

### If you want to use privoxy
- https
- 192.168.3.11
- 8118
- https://iknowwhatyoudownload.com
- https://mullvad.net/en/check/

### Jellyfin hardware acceleration
- Dashboard > Playback
- Intel QuickSync
- Enable Tone mapping

### Prowlarr indexers
- 1337x
- Rarbg
- TPB
- RuTracker.ru

### VueTorrent
- Settings > WebUi > Enable alternate UI

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