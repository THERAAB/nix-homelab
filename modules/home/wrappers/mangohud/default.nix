{
  lib,
  config,
  ...
}:
with lib;
with lib.nix-homelab; let
  cfg = config.nix-homelab.wrappers.mangohud;
in {
  options.nix-homelab.wrappers.mangohud = with types; {
    enable = mkEnableOption (lib.mdDoc "Setup mangohud");
  };
  config = mkIf cfg.enable {
    programs.mangohud = {
      enable = true;
      enableSessionWide = true;
      settings = {
        toggle_hud = "Shift_R+F12"; # Right Shift + F12 to toggle display
        no_display = true;
        gpu_stats = true;
        gpu_temp = true;
        cpu_stats = true;
        cpu_temp = true;
        cpu_mhz = true;
        fps = true;
        frametime = true;
        frame_timing = true;
      };
    };
  };
}
