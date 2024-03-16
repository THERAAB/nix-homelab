# Manual Setup Notes

Some apps can't be managed declaratively, so additional setup needed for them is described here.

### Firefox

Sign in

### Discord

Disable minimize to tray

### Printing

http://localhost:631/ > Administration > Add printer

### Plocate

```console
sudo updatedb
```

### Forge

- Disable Split Direction Hint
- Change Colors

### Ulauncher

Set theme & number of favorites

### nix-homelab

```console
git clone git@github.com:THERAAB/nix-homelab.git /nix/persist/nix-homelab
```

### Some notes on the Asus Zenbook 14 Q409ZA Bios

- Use Bios 310 for ssdt patch to work properly for audio, Don't update Bios!
- Use the s0ix-selftest-tool to test s0ix sleep states with display on and during sleep
- Disable eMMC Card reader and Webcam (optional?) to achieve s0ix sleep S3 (C10)
- Don't try to force pcie_aspm=powersave as it will actually hurt s0ix performance
- There's a fingerprint reader under the power button, but it can't be disabled through Bios. I used a udev rule instead
- Don't disable USB Hub (causes issues with s0ix)
