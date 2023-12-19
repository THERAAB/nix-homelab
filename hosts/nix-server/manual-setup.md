# Manual Setup Notes

Some apps can't be managed declaratively, so additional setup needed for them is described here.

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

- Set firefox proxy to https://${network.nix-server.local.ip}:8118
- Verify with these:
  - https://iknowwhatyoudownload.com
  - https://mullvad.net/en/check/

## ARR Stack

### Jellyfin hardware acceleration

- Dashboard -> Playback
- Intel QuickSync
- Enable Tone mapping (non VPP option)

### Jellyfin Android client

Settings -> Client Settings -> Video Player type -> Integrated Player

### Prowlarr

- Add indexers
  - 1337x
  - TPB
- Add sonar & radarr
- Add qbittorent

### Sonar, Radarr

- Add qbittorrent
- Add movies/tv paths in sonarr/radarr and request something (needed for Jellyseerr to work)

### Readarr

- Add books path
- Add Standard Book Format: {Author Name}/{Book Title}/{Book Title}{ (PartNumber)}

### Audiobookshelf

- Add Schedule for automatic library scanning (Every 2 hours)

### Jellyseerr

Set up last, make sure to do above before trying to set up

## Home Automation

### Home Assistant

Zigbee Channel 26
Add below services & their devices:

- Govee
- Sonoff
- Kasa
- Pushbullet
- Android tv
- Zigbee devices
- Shopping List
- WiZ
- TP-Link Tapo

## Linkding

- Password setup

```
sudo podman exec -it linkding python manage.py createsuperuser --username=raab --email=raab@example.com
```

- Add API Key
