{
  services.home-assistant.config = {
    zone = [
      {
        name = "Shopping";
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
          entity_id = "device_tracker.pixel_6";
          zone = "zone.Shopping";
          event = "enter";
        };
        action = {
          service = "notify.mobile_app_pixel_6";
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