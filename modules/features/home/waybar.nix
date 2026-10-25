{
  flake.homeModules.waybar =
    { config, lib, ... }:
    let
      fonts = config.moskas.fonts;
    in
    {
      config = {
        stylix.targets.waybar.addCss = false;
        programs.waybar = {
          enable = true;
          settings = {
            mainBar = {
              inherit (config.moskas.desktop.bar) position;
              height = fonts.sizes.desktop * 2;
              modules-left = [
                "custom/nix"
                "sway/workspaces"
                "sway/mode"
              ];
              modules-center = [
                "mpd"
              ];
              modules-right = [
                "tray"
                "backlight"
                "network"
                "pulseaudio"
                "battery"
                "battery#bat2"
                "clock"
              ];
              "wlr/taskbar" = {
                format = "{icon}";
                icon-size = fonts.sizes.desktop;
                tooltip-format = "{title}";
                on-click = "activate";
                on-click-middle = "close";
              };
              mpd = {
                format = "{stateIcon}  {artist} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S})";
                format-disconnected = "Disconnected";
                format-stopped = "Playback stopped";
                interval = 10;
                tooltip-format = "󰗮 {album} [{date}]\n󰲸 {songPosition}/{queueLength}   {volume}%";
                tooltip-format-disconnected = "MPD (disconnected)";
                on-click = "mpc toggle";
                on-right-click = "mpc stop";
                state-icons = {
                  paused = "";
                  playing = "";
                };
              };
              "sway/workspaces" = {
                format = "{icon}";
              };
              # No fixed device so waybar picks whichever backlight the host exposes
              backlight = {
                format = "{icon} {percent}%";
                tooltip = false;
                format-icons = [
                  ""
                ];
              };
              pulseaudio = {
                format = "{icon} {volume}%";
                format-bluetooth = " {icon} {volume}%";
                format-muted = "  {volume}%";
                tooltip-format = "{icon}: {format_source}";
                format-icons = {
                  default = [
                    ""
                    " "
                  ];
                };
              };
              battery = {
                bat = "BAT0";
                states = {
                  warning = 30;
                  critical = 15;
                };
                format = "{icon} {capacity}%";
                format-full = "{icon} {capacity}%";
                format-charging = "󰂄 {capacity}%";
                format-plugged = "󰂄 {capacity}%";
                format-alt = "{time} {icon}";
                tooltip-format = "󱐋 {power}W\n󱧥 {timeTo}\n󱈑 {health}%";
                format-icons = [
                  "󰁺"
                  "󰁻"
                  "󰁼"
                  "󰁾"
                  "󰂀"
                  "󰂂"
                  "󰁹"
                ];
              };
              "battery#bat2" = {
                bat = "BAT1";
                states = {
                  warning = 30;
                  critical = 15;
                };
                format = "{icon} {capacity}%";
                format-full = "{icon} {capacity}%";
                format-charging = "󰂄 {capacity}%";
                format-plugged = "󰂄 {capacity}%";
                format-alt = "{icon} {time}";
                tooltip-format = "󱐋 {power}W\n󱧥 {timeTo}\n󱈑 {health}%";
                format-icons = [
                  "󰁺"
                  "󰁻"
                  "󰁼"
                  "󰁾"
                  "󰂀"
                  "󰂂"
                  "󰁹"
                ];
              };
              clock = {
                tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
                format-alt = "󰃭 {:%d.%m.%Y}";
                format = "󱑍 {:%H:%M:%S}";
                interval = 1;
                calendar = {
                  mode-mon-col = 3;
                  weeks-pos = "right";
                  on-scroll = 1;
                };
              };
              network = {
                # interface = "wlp5s0";
                format = "{ifname}";
                format-wifi = "  {signalStrength}%";
                format-ethernet = "󰈀 {ifname}";
                format-disconnected = "󰌙 {ifname}";
                format-disabled = " {ifname}";
                tooltip-format = "{ifname}\nIP: {ipaddr}\nUP:{bandwidthUpBytes} DW:{bandwidthDownBytes}";
                tooltip-format-wifi = "SSID: {essid}@{frequency}Ghz {signaldBm}dB\nIP: {ipaddr}\nUP:{bandwidthUpBytes} DW:{bandwidthDownBytes}";
                tooltip-format-ethernet = "{ifname}\nIP: {ipaddr}\nUP:{bandwidthUpBytes} DW:{bandwidthDownBytes}";
                tooltip-format-disconnected = "Disconnected";
              };
              "custom/nix" = {
                format = "";
                on-click = "fuzzel";
                on-click-right = "foot";
                tooltip-format = "Left: launcher\nRight: terminal";
              };
              tray = {
                icon-size = 16;
                spacing = 10;
              };
            };
          };
          style = ''
            * {
              border-radius: 0;
              min-height: 0;
              font-size: ${toString fonts.sizes.desktop}px;
            }
            #workspaces {
              background-color: @base00;
            }
            #workspaces button {
              padding: 2px;
              margin: 0;
            }
            button {
              box-shadow: inset 0 -3px transparent;
              border: none;
            }
            #workspaces button.focused {
              color: @base06;
            }
            #workspaces button.empty {
              color: @base04;
            }
            .modules-left #workspaces button.focused,
            .modules-left #workspaces button.active {
              color: @base0B;
            }
            .modules-right * {
              padding: 0 5px;
            }
            tooltip {
              background: @base00;
              border: 1px solid @base02;  
              color: @base05;
            }
            tooltip label {
              color: @base05;
            }
            #custom-nix {
              color: @base0D;
              min-width: 30px;
              font-size: 24px;
              padding: 0 5px;
              margin: 0;
              font-family: "${fonts.mono.name}";
            }
            #mpd {
              padding: 0 5px;
            }
          '';
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
