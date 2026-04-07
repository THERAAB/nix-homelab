{ pkgs, ... }:
let
  devices = import ./devices.properties.nix;
in
{
  services.home-assistant = {
    customComponents = [
      pkgs.nix-homelab.home-assistant-hubspace
    ];
    config = {
      automation = [
        {
          alias = "Switch Off Bedroom Fan at Morning";
          trigger = {
            trigger = "time";
            at = "8:30:00";
          };
          action = [
            {
              action = "fan.turn_off";
              target.entity_id = devices.entity-id.bedroom.spinny-boi.fan;
            }
          ];
        }
        {
          alias = "Switch On Bedroom Fan at Night";
          trigger = {
            trigger = "time";
            at = "20:30:00";
          };
          action = [
            {
              action = "fan.set_percentage";
              target.entity_id = devices.entity-id.bedroom.spinny-boi.fan;
              data.percentage = 10;
            }
            {
              action = "fan.turn_on";
              target.entity_id = devices.entity-id.bedroom.spinny-boi.fan;
            }
          ];
        }
      ];
    };
  };
}
