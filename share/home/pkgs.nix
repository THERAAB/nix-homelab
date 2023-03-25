{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    ncdu_2
    lm_sensors
  ];
}
