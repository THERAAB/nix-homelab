# Manual Setup Notes

Some apps can't be managed declaratively, so additional setup needed for them is described here.

## Networking

### Use Adguard Home

- pfSense -> DHCP Server -> DNS Servers -> nix-server local ip
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

### Sonar, Radarr, Readarr

- Add qbittorrent
- Add movies/tv paths in sonarr/radarr and request something (needed for Jellyseerr to work)
- Add books path in readarr

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
- Shopping List
- WiZ
- TP-Link Tapo

## Cloudflare SSL Certs

```
# Create cloudflare secret
sudo mkdir /var/lib/secrets
sudo chmod 644 /var/lib/secrets
sudo vi /var/lib/secrets/cloudflare.secret

> CF_DNS_API_TOKEN=$key
> CLOUDFLARE_EMAIL=$email
```

## Unifi

Create init.js and env.secret as per: https://hub.docker.com/r/linuxserver/unifi-network-application

```console
sudo nvim /nix/persist/unifi/init-mongo.js

sudo nvim /nix/persist/unifi/env.secret

MONGO_USER=$user
MONGO_PASS=$pass
MONGO_DBNAME=$dbname

```
