{...}: let
  devices = import ./devices.properties.nix;
  shopping-zone = "Shopping";
in {
  services.home-assistant.config = {
    zone = [
      {
        name = shopping-zone;
        latitude = "!secret shopping_latitude";
        longitude = "!secret shopping_longitude";
        radius = "63";
      }
    ];
    automation = [
      {
        alias = "Send shopping list when arrive at store";
        trigger = {
          platform = "zone";
          entity_id = devices.entity-id.phones.pixel.location;
          zone = "zone.${shopping-zone}";
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
