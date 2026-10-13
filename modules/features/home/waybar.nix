{
  flake.homeModules.waybar =
    { config, lib, ... }:
    {
      config = {
        programs.waybar.enable = true;

        wayland.windowManager.niri.settings._children = lib.mkIf config.wayland.windowManager.niri.enable (
          lib.mkAfter [
            { spawn-at-startup._args = [ "waybar" ]; }
          ]
        );
      };
    };
}
