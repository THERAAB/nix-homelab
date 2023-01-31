{ config, pkgs, ... }:
let
  devices = (import ./devices.properties.nix);
in
{
  services.home-assistant.config = {
    zone = [
      {
        name = "Send shopping list when arrive at shopping center";
        latitude = "!secret shopping_latitude";
        longitude = "!secret shopping_longitude";
        radius = "63";
      }
    ];
    automation = [
      {
        alias = "Send shopping notification";
        trigger = {
          platform = "zone";
          entity_id = devices.entity-id.phones.pixel.location;
          zone = devices.entity-id.phones.pixel.notify;
          event = "enter";
        };
        action = {
          service = "";
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