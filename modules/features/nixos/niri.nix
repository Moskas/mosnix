{
  inputs,
  ...
}:
{
  flake.nixosModules.niri = {
    imports = [ inputs.niri.nixosModules.niri ];
    config = {
      nixpkgs.overlays = [ inputs.niri.overlays.niri ];
      programs.niri = {
        enable = true;
      };
    };
  };

  flake.homeModules.niri = {
    config = {
      programs.niri = {
        settings = {
          input = {
            keyboard.numlock = true;
            touchpad = {
              tap = true;
              natural-scroll = true;
              accel-speed = 0.2;
            };
            mouse = {
              scroll-method = "no-scroll";
              scroll-factor = 1.0;
            };
            trackpoint = {
              accel-speed = 0.2;
              middle-emulation = true;
            };
            focus-follows-mouse = {
              enable = true;
              max-scroll-amount = "0%";
            };
          };

          outputs = {
            "LG Display 0x0521 Unknown" = {
              mode = {
                width = 1920;
                height = 1080;
                refresh = 60.020;
              };
              scale = 1.1;
              transform = {
                rotation = 0;
                flipped = false;
              };
              position = {
                x = 0;
                y = 0;
              };
            };
            "Dell Inc. DELL P2319H J19FY83" = {
              mode = {
                width = 1920;
                height = 1080;
                refresh = 59.940;
              };
              position = {
                x = -88;
                y = -1080;
              };
              scale = 1.0;
            };
            "DP-4" = {
              mode = {
                width = 1920;
                height = 1080;
                refresh = 60.000;
              };
              scale = 1;
              enable = false;
            };
            "DP-7" = {
              mode = {
                width = 1920;
                height = 1080;
                refresh = 60.000;
              };
              scale = 1;
              enable = false;
            };
          };

          workspaces = {
            "1" = { };
            "2" = { };
            "3" = { };
            "4" = { };
            "5" = { };
            "6" = { };
          };

          overview = {
            zoom = 0.6;
          };

          layout = {
            gaps = 8;
            center-focused-column = "never";
            always-center-single-column = true;
            preset-column-widths = [
              { proportion = 0.33333; }
              { proportion = 0.5; }
              { proportion = 0.66667; }
            ];
            default-column-width = {
              proportion = 0.5;
            };
            focus-ring = {
              enable = false;
              width = 2;
            };
            border = {
              width = 2;
            };
            shadow = {
              softness = 30;
              spread = 5;
              offset = {
                x = 0;
                y = 5;
              };
            };
            struts = { };
          };

          spawn-at-startup = [
            { sh = "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY"; }
          ];

          hotkey-overlay.skip-at-startup = true;
          prefer-no-csd = true;
          screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

          window-rules = [
            {
              matches = [ { app-id = "^org\\.wezfurlong\\.wezterm$"; } ];
              default-column-width = { };
            }
            {
              matches = [
                { app-id = "mpv"; }
                { app-id = "emacs"; }
                { app-id = "org.prismlauncher.PrismLauncher"; }
              ];
              open-maximized = true;
            }
            {
              matches = [ { title = "Umamusume"; } ];
              open-fullscreen = true;
            }
            {
              matches = [
                {
                  app-id = "firefox$";
                  title = "^Picture-in-Picture$";
                }
                {
                  app-id = "firefox$";
                  title = "Extension: (Bitwarden Password Manager) - Bitwarden — Mozilla Firefox";
                }
              ];
              open-floating = true;
            }
            {
              matches = [ { app-id = "firefox$"; } ];
              excludes = [ { title = "^Picture-in-Picture$"; } ];
              open-on-workspace = "1";
            }
            {
              matches = [ { app-id = "qutebrowser"; } ];
              open-on-workspace = "1";
            }
            {
              matches = [ { app-id = "vesktop"; } ];
              open-maximized = true;
            }
          ];

          layer-rules = [
            {
              matches = [ { namespace = "^noctalia-overview*"; } ];
              place-within-backdrop = true;
            }
          ];

          binds = {
            "Mod+Shift+Slash".action."show-hotkey-overlay" = [ ];

            "Mod+Return" = {
              hotkey-overlay.title = "Open a Terminal: kitty";
              action.spawn = [ "kitty" ];
            };
            "Mod+T" = {
              hotkey-overlay.title = "Open a Terminal: kitty";
              action.spawn = [ "kitty" ];
            };
            "Mod+D" = {
              hotkey-overlay.title = "Run an Application: fuzzel";
              action."spawn-sh" = "fuzzel";
            };
            "Super+Alt+L" = {
              hotkey-overlay.title = "Lock the Screen: swaylock";
              action.spawn = [ "swaylock" ];
            };
            "Super+Alt+S" = {
              allow-when-locked = true;
              hotkey-overlay.hidden = true;
              action."spawn-sh" = "pkill orca || exec orca";
            };

            "XF86AudioRaiseVolume" = {
              allow-when-locked = true;
              action."spawn-sh" = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0";
            };
            "XF86AudioLowerVolume" = {
              allow-when-locked = true;
              action."spawn-sh" = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
            };
            "XF86AudioMute" = {
              allow-when-locked = true;
              action."spawn-sh" = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            };
            "XF86AudioMicMute" = {
              allow-when-locked = true;
              action."spawn-sh" = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
            };
            "XF86AudioPlay" = {
              allow-when-locked = true;
              action."spawn-sh" = "playerctl play-pause";
            };
            "XF86AudioStop" = {
              allow-when-locked = true;
              action."spawn-sh" = "playerctl stop";
            };
            "XF86AudioPrev" = {
              allow-when-locked = true;
              action."spawn-sh" = "playerctl previous";
            };
            "XF86AudioNext" = {
              allow-when-locked = true;
              action."spawn-sh" = "playerctl next";
            };
            "XF86MonBrightnessUp" = {
              allow-when-locked = true;
              action.spawn = [
                "brightnessctl"
                "--class=backlight"
                "set"
                "+10%"
              ];
            };
            "XF86MonBrightnessDown" = {
              allow-when-locked = true;
              action.spawn = [
                "brightnessctl"
                "--class=backlight"
                "set"
                "10%-"
              ];
            };

            "Mod+O" = {
              repeat = false;
              action."toggle-overview" = [ ];
            };
            "Mod+Q" = {
              repeat = false;
              action."close-window" = [ ];
            };
            "Mod+S".action.spawn = [
              "niri-scratchpad"
              "create"
              "1"
            ];
            "Mod+Ctrl+S".action.spawn = [
              "niri-scratchpad"
              "delete"
              "1"
            ];

            "Mod+Left".action."focus-column-left" = [ ];
            "Mod+Down".action."focus-window-down" = [ ];
            "Mod+Up".action."focus-window-up" = [ ];
            "Mod+Right".action."focus-column-right" = [ ];
            "Mod+H".action."focus-column-left" = [ ];
            "Mod+J".action."focus-window-down" = [ ];
            "Mod+K".action."focus-window-up" = [ ];
            "Mod+L".action."focus-column-right" = [ ];

            "Mod+Ctrl+Left".action."move-column-left" = [ ];
            "Mod+Ctrl+Down".action."move-window-down" = [ ];
            "Mod+Ctrl+Up".action."move-window-up" = [ ];
            "Mod+Ctrl+Right".action."move-column-right" = [ ];
            "Mod+Ctrl+H".action."move-column-left" = [ ];
            "Mod+Ctrl+J".action."move-window-down" = [ ];
            "Mod+Ctrl+K".action."move-window-up" = [ ];
            "Mod+Ctrl+L".action."move-column-right" = [ ];

            "Mod+Home".action."focus-column-first" = [ ];
            "Mod+End".action."focus-column-last" = [ ];
            "Mod+Ctrl+Home".action."move-column-to-first" = [ ];
            "Mod+Ctrl+End".action."move-column-to-last" = [ ];

            "Mod+Shift+Ctrl+Left".action."move-column-to-monitor-left" = [ ];
            "Mod+Shift+Ctrl+Down".action."move-column-to-monitor-down" = [ ];
            "Mod+Shift+Ctrl+Up".action."move-column-to-monitor-up" = [ ];
            "Mod+Shift+Ctrl+Right".action."move-column-to-monitor-right" = [ ];
            "Mod+Shift+Ctrl+H".action."move-column-to-monitor-left" = [ ];
            "Mod+Shift+Ctrl+J".action."move-column-to-monitor-down" = [ ];
            "Mod+Shift+Ctrl+K".action."move-column-to-monitor-up" = [ ];
            "Mod+Shift+Ctrl+L".action."move-column-to-monitor-right" = [ ];

            "Mod+Page_Down".action."focus-workspace-down" = [ ];
            "Mod+Page_Up".action."focus-workspace-up" = [ ];
            "Mod+Shift+J".action."focus-workspace-down" = [ ];
            "Mod+Shift+K".action."focus-workspace-up" = [ ];
            "Mod+U".action."focus-workspace-down" = [ ];
            "Mod+I".action."focus-workspace-up" = [ ];
            "Mod+Ctrl+Page_Down".action."move-column-to-workspace-down" = [ ];
            "Mod+Ctrl+Page_Up".action."move-column-to-workspace-up" = [ ];
            "Mod+Ctrl+U".action."move-column-to-workspace-down" = [ ];
            "Mod+Ctrl+I".action."move-column-to-workspace-up" = [ ];
            "Mod+Shift+Page_Down".action."move-workspace-down" = [ ];
            "Mod+Shift+Page_Up".action."move-workspace-up" = [ ];
            "Mod+Shift+U".action."move-workspace-down" = [ ];
            "Mod+Shift+I".action."move-workspace-up" = [ ];

            "Mod+WheelScrollDown" = {
              cooldown-ms = 150;
              action."focus-workspace-down" = [ ];
            };
            "Mod+WheelScrollUp" = {
              cooldown-ms = 150;
              action."focus-workspace-up" = [ ];
            };
            "Mod+Ctrl+WheelScrollDown" = {
              cooldown-ms = 150;
              action."move-column-to-workspace-down" = [ ];
            };
            "Mod+Ctrl+WheelScrollUp" = {
              cooldown-ms = 150;
              action."move-column-to-workspace-up" = [ ];
            };

            "Mod+WheelScrollRight".action."focus-column-right" = [ ];
            "Mod+WheelScrollLeft".action."focus-column-left" = [ ];
            "Mod+Ctrl+WheelScrollRight".action."move-column-right" = [ ];
            "Mod+Ctrl+WheelScrollLeft".action."move-column-left" = [ ];
            "Mod+Shift+WheelScrollDown".action."focus-column-right" = [ ];
            "Mod+Shift+WheelScrollUp".action."focus-column-left" = [ ];
            "Mod+Ctrl+Shift+WheelScrollDown".action."move-column-right" = [ ];
            "Mod+Ctrl+Shift+WheelScrollUp".action."move-column-left" = [ ];

            "Mod+1".action."focus-workspace" = 1;
            "Mod+2".action."focus-workspace" = 2;
            "Mod+3".action."focus-workspace" = 3;
            "Mod+4".action."focus-workspace" = 4;
            "Mod+5".action."focus-workspace" = 5;
            "Mod+6".action."focus-workspace" = 6;
            "Mod+7".action."focus-workspace" = 7;
            "Mod+8".action."focus-workspace" = 8;
            "Mod+9".action."focus-workspace" = 9;
            "Mod+Ctrl+1".action."move-column-to-workspace" = 1;
            "Mod+Ctrl+2".action."move-column-to-workspace" = 2;
            "Mod+Ctrl+3".action."move-column-to-workspace" = 3;
            "Mod+Ctrl+4".action."move-column-to-workspace" = 4;
            "Mod+Ctrl+5".action."move-column-to-workspace" = 5;
            "Mod+Ctrl+6".action."move-column-to-workspace" = 6;
            "Mod+Ctrl+7".action."move-column-to-workspace" = 7;
            "Mod+Ctrl+8".action."move-column-to-workspace" = 8;
            "Mod+Ctrl+9".action."move-column-to-workspace" = 9;

            "Mod+BracketLeft".action."consume-or-expel-window-left" = [ ];
            "Mod+BracketRight".action."consume-or-expel-window-right" = [ ];
            "Mod+Comma".action."consume-window-into-column" = [ ];
            "Mod+Period".action."expel-window-from-column" = [ ];

            "Mod+R".action."switch-preset-column-width" = [ ];
            "Mod+Shift+R".action."switch-preset-window-height" = [ ];
            "Mod+Ctrl+R".action."reset-window-height" = [ ];
            "Mod+F".action."maximize-column" = [ ];
            "Mod+Shift+F".action."fullscreen-window" = [ ];
            "Mod+Ctrl+F".action."expand-column-to-available-width" = [ ];
            "Mod+C".action."center-column" = [ ];
            "Mod+Ctrl+C".action."center-visible-columns" = [ ];
            "Mod+Minus".action."set-column-width" = "-10%";
            "Mod+Equal".action."set-column-width" = "+10%";
            "Mod+Shift+Minus".action."set-window-height" = "-10%";
            "Mod+Shift+Equal".action."set-window-height" = "+10%";
            "Mod+V".action."toggle-window-floating" = [ ];
            "Mod+Shift+V".action."switch-focus-between-floating-and-tiling" = [ ];
            "Mod+W".action."toggle-column-tabbed-display" = [ ];

            "Print".action."screenshot-screen" = [ ];
            "Ctrl+Print".action.screenshot = [ ];
            "Alt+Print".action."screenshot-window" = [ ];

            "Mod+Escape" = {
              allow-inhibiting = false;
              action."toggle-keyboard-shortcuts-inhibit" = [ ];
            };

            "Mod+Shift+E".action.quit = [ ];
            "Ctrl+Alt+Delete".action.quit = [ ];
            "Mod+Shift+P".action."power-off-monitors" = [ ];
          };
        };
      };
    };
  };
}
