# Manual Setup Notes

Some apps can't be managed declaratively, so additional setup needed for them is described here.

## Privacy VPN

### VueTorrent

- admin/adminadmin
- change user & password
- Settings -> WebUi -> Enable alternate UI
- Settings -> Bittorrent -> Seed Limits -> When Ratio reaches 2
- Settings -> WebUI -> Enable Trusted Proxy Support -> Add IP

### Check IP Leakage

```console
sudo podman exec -it vuetorrent sh
curl https://am.i.mullvad.net/json
```

### Check privoxy

- Set firefox proxy to https://${network.micro-media.local.ip}:8118
- Verify with these:
  - https://iknowwhatyoudownload.com
  - https://mullvad.net/en/check/

## ARR Stack

### Jellyfin

- Hardware acceleration
  - Dashboard -> Playback
  - Intel QuickSync
  - Enable Tone mapping (non VPP option)
  - Don't enable GuC (Low power encoding)
- (Android Client) Settings -> Client Settings -> Video Player type -> Integrated Player
- Settings -> Subtitles -> English, only forced
- Add plugins
  - Jellyscrub
  - Intro Skipper

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

- Settings -> enable CSRF protection
- Settings -> Discover language -> English
- Settings -> enable proxy support