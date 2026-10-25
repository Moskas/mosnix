{
  flake.homeModules.waybar =
    { config, lib, ... }:
    {
      config = {
        programs.waybar = {
          enable = true;
          settings.mainBar = {
            inherit (config.moskas.desktop.bar) position;
            modules-left = [
              "sway/workspaces"
              "sway/mode"
            ];
            modules-center = [ "clock" ];
            modules-right = [
              "tray"
              "network"
              "wireplumber"
              "backlight"
              "battery"
            ];
            clock.format = "{:%H:%M}";
            network = {
              format-wifi = "{essid}";
              format-ethernet = "eth";
              format-disconnected = "offline";
            };
            battery.format = "{capacity}%";
          };
        };

        wayland.windowManager.niri.settings._children = lib.mkIf config.wayland.windowManager.niri.enable (
          lib.mkAfter [
            { spawn-at-startup._args = [ "waybar" ]; }
          ]
        );

        # Launched by the compositor; the systemd unit starts before WAYLAND_DISPLAY is imported
        wayland.windowManager.sway.config.startup = lib.mkIf config.wayland.windowManager.sway.enable [
          { command = "waybar"; }
        ];
      };
    };
}
