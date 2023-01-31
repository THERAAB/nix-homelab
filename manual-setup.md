# Manual Setup Notes
Some apps can't be managed declaratively, so additional setup needed for them is described here.
## Networking
### Use Adguard Home
- pfSense -> Services -> DHCP Server -> DNS Servers -> nix-homelab local ip
- tailscale -> DNS settings -> override local DNS

## Privacy VPN
### VueTorrent
- admin/adminadmin
- change user & password
- Settings > WebUi > Enable alternate UI
### Check IP Leakage
```console
sudo podman exec -it vuetorrent sh
curl https://am.i.mullvad.net/json
```
### Check privoxy
- Set firefox proxy to https://192.168.3.11:8118
- Verify with these:
  - https://iknowwhatyoudownload.com
  - https://mullvad.net/en/check/

## ARR Stack
### Jellyfin hardware acceleration
- Dashboard -> Playback
- Intel QuickSync
- Enable Tone mapping (non VPP option)

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

## Home Automation
### Home Assistant
Add below services & their devices:
- Govee
- Sonoff
- Kasa
- Pushbullet
- Android tv
- Zigbee devices (water alarms)
- Shopping (and shopping zone)