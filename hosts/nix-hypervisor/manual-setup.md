# Manual Setup Notes

Some apps can't be managed declaratively, so additional setup needed for them is described here.

## Home Automation

### Home Assistant

- Add below services & their devices:
  - Govee
  - Sonoff
  - Kasa
  - Android tv
  - Zigbee devices
  - Shopping List
  - TP-Link Tapo
- Zigbee Channel 26

- Add Zigbee Binding to Inovelli switch
  - Create group
    - Devices & Services -> ZHA configure -> groups -> Create group
  - Bind Switch
    - Devices & Services -> ZHA devices -> Inovelli switch -> 3 dots under device info -> Manage
    - Bindings -> Bindable groups -> Bathroom lights -> OnOff -> Bind group

## NetData

Add to NetData Cloud
