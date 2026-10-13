{
  flake.homeModules.mako =
    { config, lib, ... }:
    {
      config = {
        services.mako.enable = true;

        wayland.windowManager.niri.settings._children = lib.mkIf config.wayland.windowManager.niri.enable (
          lib.mkAfter [
            { spawn-at-startup._args = [ "mako" ]; }
          ]
        );
      };
    };
}
