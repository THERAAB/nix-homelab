{ config, pkgs, ... }:
let
  devices = (import ./devices.properties.nix);
  shopping-zone = "Shopping";
in
{
  services.home-assistant.config = {
    automation = [
      {
        alias = "Send shopping list when arrive at store";
        trigger = {
          platform = "zone";
          entity_id = devices.entity-id.phones.pixel.location;
          zone = shopping-zone;
          event = "enter";
        };
        action = {
          service = devices.entity-id.phones.pixel.notify;
          data = {
            message = "Click to open shopping list";
            data = {
              clickAction = "/shopping-list";
              url = "/shopping-list";
            };
          };
        };
      }
    ];
  };
}