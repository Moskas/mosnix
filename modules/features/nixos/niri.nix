{
  flake.nixosModules.niri = {
    config = {
      programs.niri = {
        enable = true;
      };
    };
  };

  flake.homeModules.niri = { pkgs, ... }: {
    config = {
      home.packages = with pkgs; [
        wdisplays
        wl-clipboard
      ];
      wayland.windowManager.niri = {
        enable = true;

        # The upstream home-manager niri module serialises `settings` straight
        # to KDL via `lib.hm.generators.toKDL`. It does NOT provide the niri-flake
        # DSL sugar (`action.*`, `matches`/`excludes`, `enable` toggles, ...), so:
        #   * flag-style options -> `= { }` (emits a bare node)
        #   * repeated top-level nodes (workspace, window-rule, ...) -> `_children`
        #   * node properties (x=, app-id=, hotkey-overlay-title=) -> `_props`
        settings = {
          input = {
            keyboard.numlock = { };
            touchpad = {
              tap = { };
              natural-scroll = { };
              accel-speed = 0.2;
            };
            mouse = {
              scroll-method = "no-scroll";
              scroll-factor = 1.0;
            };
            trackpoint = {
              accel-speed = 0.2;
              middle-emulation = { };
            };
            focus-follows-mouse._props.max-scroll-amount = "0%";
          };

          overview.zoom = 0.6;

          layout = {
            gaps = 8;
            center-focused-column = "never";
            always-center-single-column = { };
            preset-column-widths._children = [
              { proportion = 0.33333; }
              { proportion = 0.5; }
              { proportion = 0.66667; }
            ];
            default-column-width.proportion = 0.5;
            focus-ring = {
              off = { };
              width = 2;
            };
            border.width = 2;
            shadow = {
              softness = 30;
              spread = 5;
              offset._props = {
                x = 0;
                y = 5;
              };
            };
            struts = { };
          };

          hotkey-overlay.skip-at-startup = { };
          prefer-no-csd = { };
          screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

          # Repeated / parameterised top-level nodes.
          _children = [
            { workspace._args = [ "1" ]; }
            { workspace._args = [ "2" ]; }
            { workspace._args = [ "3" ]; }
            { workspace._args = [ "4" ]; }
            { workspace._args = [ "5" ]; }
            { workspace._args = [ "6" ]; }

            {
              spawn-at-startup._args = [
                "dbus-update-activation-environment"
                "--systemd"
                "DISPLAY"
                "WAYLAND_DISPLAY"
              ];
            }

            {
              window-rule._children = [
                { match._props.app-id = "^org\\.wezfurlong\\.wezterm$"; }
                { default-column-width = { }; }
              ];
            }
            {
              window-rule._children = [
                { match._props.app-id = "mpv"; }
                { match._props.app-id = "emacs"; }
                { match._props.app-id = "org.prismlauncher.PrismLauncher"; }
                { open-maximized = true; }
              ];
            }
            {
              window-rule._children = [
                { match._props.title = "Umamusume"; }
                { open-fullscreen = true; }
              ];
            }
            {
              window-rule._children = [
                {
                  match._props = {
                    app-id = "firefox$";
                    title = "^Picture-in-Picture$";
                  };
                }
                {
                  match._props = {
                    app-id = "firefox$";
                    title = "Extension: (Bitwarden Password Manager) - Bitwarden — Mozilla Firefox";
                  };
                }
                { open-floating = true; }
              ];
            }
            {
              window-rule._children = [
                { match._props.app-id = "firefox$"; }
                { exclude._props.title = "^Picture-in-Picture$"; }
                { open-on-workspace = "1"; }
              ];
            }
            {
              window-rule._children = [
                { match._props.app-id = "qutebrowser"; }
                { open-on-workspace = "1"; }
              ];
            }
            {
              window-rule._children = [
                { match._props.app-id = "vesktop"; }
                { open-maximized = true; }
              ];
            }

            {
              layer-rule._children = [
                { match._props.namespace = "^noctalia-backdrop*"; }
                { place-within-backdrop = true; }
              ];
            }
          ];

          binds = {
            "Mod+Shift+Slash"."show-hotkey-overlay" = { };

            "Mod+Return" = {
              _props.hotkey-overlay-title = "Open a Terminal: kitty";
              spawn = [ "kitty" ];
            };
            "Mod+T" = {
              _props.hotkey-overlay-title = "Open a Terminal: kitty";
              spawn = [ "kitty" ];
            };
            "Mod+D" = {
              _props.hotkey-overlay-title = "Run an Application: fuzzel";
              spawn-sh = "fuzzel";
            };
            "Super+Alt+L" = {
              _props.hotkey-overlay-title = "Lock the Screen: swaylock";
              spawn = [ "swaylock" ];
            };
            "Super+Alt+S" = {
              _props = {
                allow-when-locked = true;
                hotkey-overlay-title = null;
              };
              spawn-sh = "pkill orca || exec orca";
            };

            "XF86AudioRaiseVolume" = {
              _props.allow-when-locked = true;
              spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0";
            };
            "XF86AudioLowerVolume" = {
              _props.allow-when-locked = true;
              spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
            };
            "XF86AudioMute" = {
              _props.allow-when-locked = true;
              spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            };
            "XF86AudioMicMute" = {
              _props.allow-when-locked = true;
              spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
            };
            "XF86AudioPlay" = {
              _props.allow-when-locked = true;
              spawn-sh = "playerctl play-pause";
            };
            "XF86AudioStop" = {
              _props.allow-when-locked = true;
              spawn-sh = "playerctl stop";
            };
            "XF86AudioPrev" = {
              _props.allow-when-locked = true;
              spawn-sh = "playerctl previous";
            };
            "XF86AudioNext" = {
              _props.allow-when-locked = true;
              spawn-sh = "playerctl next";
            };
            "XF86MonBrightnessUp" = {
              _props.allow-when-locked = true;
              spawn = [
                "brightnessctl"
                "--class=backlight"
                "set"
                "+10%"
              ];
            };
            "XF86MonBrightnessDown" = {
              _props.allow-when-locked = true;
              spawn = [
                "brightnessctl"
                "--class=backlight"
                "set"
                "10%-"
              ];
            };

            "Mod+O" = {
              _props.repeat = false;
              "toggle-overview" = { };
            };
            "Mod+Q" = {
              _props.repeat = false;
              "close-window" = { };
            };
            "Mod+S".spawn = [
              "niri-scratchpad"
              "create"
              "1"
            ];
            "Mod+Ctrl+S".spawn = [
              "niri-scratchpad"
              "delete"
              "1"
            ];

            "Mod+Left"."focus-column-left" = { };
            "Mod+Down"."focus-window-down" = { };
            "Mod+Up"."focus-window-up" = { };
            "Mod+Right"."focus-column-right" = { };
            "Mod+H"."focus-column-left" = { };
            "Mod+J"."focus-window-down" = { };
            "Mod+K"."focus-window-up" = { };
            "Mod+L"."focus-column-right" = { };

            "Mod+Ctrl+Left"."move-column-left" = { };
            "Mod+Ctrl+Down"."move-window-down" = { };
            "Mod+Ctrl+Up"."move-window-up" = { };
            "Mod+Ctrl+Right"."move-column-right" = { };
            "Mod+Ctrl+H"."move-column-left" = { };
            "Mod+Ctrl+J"."move-window-down" = { };
            "Mod+Ctrl+K"."move-window-up" = { };
            "Mod+Ctrl+L"."move-column-right" = { };

            "Mod+Home"."focus-column-first" = { };
            "Mod+End"."focus-column-last" = { };
            "Mod+Ctrl+Home"."move-column-to-first" = { };
            "Mod+Ctrl+End"."move-column-to-last" = { };

            "Mod+Shift+Ctrl+Left"."move-column-to-monitor-left" = { };
            "Mod+Shift+Ctrl+Down"."move-column-to-monitor-down" = { };
            "Mod+Shift+Ctrl+Up"."move-column-to-monitor-up" = { };
            "Mod+Shift+Ctrl+Right"."move-column-to-monitor-right" = { };
            "Mod+Shift+Ctrl+H"."move-column-to-monitor-left" = { };
            "Mod+Shift+Ctrl+J"."move-column-to-monitor-down" = { };
            "Mod+Shift+Ctrl+K"."move-column-to-monitor-up" = { };
            "Mod+Shift+Ctrl+L"."move-column-to-monitor-right" = { };

            "Mod+Page_Down"."focus-workspace-down" = { };
            "Mod+Page_Up"."focus-workspace-up" = { };
            "Mod+Shift+J"."focus-workspace-down" = { };
            "Mod+Shift+K"."focus-workspace-up" = { };
            "Mod+Shift+Page_Up"."focus-workspace-up" = { };
            "Mod+XF86Forward"."focus-workspace-down" = { };
            "Mod+XF86Back"."focus-workspace-up" = { };
            "Mod+Shift+Page_Down"."focus-workspace-down" = { };
            "Mod+U"."focus-workspace-down" = { };
            "Mod+I"."focus-workspace-up" = { };
            "Mod+Ctrl+Page_Down"."move-column-to-workspace-down" = { };
            "Mod+Ctrl+Page_Up"."move-column-to-workspace-up" = { };
            "Mod+Ctrl+U"."move-column-to-workspace-down" = { };
            "Mod+Ctrl+I"."move-column-to-workspace-up" = { };
            "Mod+Shift+U"."move-workspace-down" = { };
            "Mod+Shift+I"."move-workspace-up" = { };

            "Mod+WheelScrollDown" = {
              _props.cooldown-ms = 150;
              "focus-workspace-down" = { };
            };
            "Mod+WheelScrollUp" = {
              _props.cooldown-ms = 150;
              "focus-workspace-up" = { };
            };
            "Mod+Ctrl+WheelScrollDown" = {
              _props.cooldown-ms = 150;
              "move-column-to-workspace-down" = { };
            };
            "Mod+Ctrl+WheelScrollUp" = {
              _props.cooldown-ms = 150;
              "move-column-to-workspace-up" = { };
            };

            "Mod+WheelScrollRight"."focus-column-right" = { };
            "Mod+WheelScrollLeft"."focus-column-left" = { };
            "Mod+Ctrl+WheelScrollRight"."move-column-right" = { };
            "Mod+Ctrl+WheelScrollLeft"."move-column-left" = { };
            "Mod+Shift+WheelScrollDown"."focus-column-right" = { };
            "Mod+Shift+WheelScrollUp"."focus-column-left" = { };
            "Mod+Ctrl+Shift+WheelScrollDown"."move-column-right" = { };
            "Mod+Ctrl+Shift+WheelScrollUp"."move-column-left" = { };

            "Mod+1"."focus-workspace" = 1;
            "Mod+2"."focus-workspace" = 2;
            "Mod+3"."focus-workspace" = 3;
            "Mod+4"."focus-workspace" = 4;
            "Mod+5"."focus-workspace" = 5;
            "Mod+6"."focus-workspace" = 6;
            "Mod+7"."focus-workspace" = 7;
            "Mod+8"."focus-workspace" = 8;
            "Mod+9"."focus-workspace" = 9;
            "Mod+Ctrl+1"."move-column-to-workspace" = 1;
            "Mod+Ctrl+2"."move-column-to-workspace" = 2;
            "Mod+Ctrl+3"."move-column-to-workspace" = 3;
            "Mod+Ctrl+4"."move-column-to-workspace" = 4;
            "Mod+Ctrl+5"."move-column-to-workspace" = 5;
            "Mod+Ctrl+6"."move-column-to-workspace" = 6;
            "Mod+Ctrl+7"."move-column-to-workspace" = 7;
            "Mod+Ctrl+8"."move-column-to-workspace" = 8;
            "Mod+Ctrl+9"."move-column-to-workspace" = 9;

            "Mod+BracketLeft"."consume-or-expel-window-left" = { };
            "Mod+BracketRight"."consume-or-expel-window-right" = { };
            "Mod+Comma"."consume-window-into-column" = { };
            "Mod+Period"."expel-window-from-column" = { };

            "Mod+R"."switch-preset-column-width" = { };
            "Mod+Shift+R"."switch-preset-window-height" = { };
            "Mod+Ctrl+R"."reset-window-height" = { };
            "Mod+F"."maximize-column" = { };
            "Mod+Shift+F"."fullscreen-window" = { };
            "Mod+Ctrl+F"."expand-column-to-available-width" = { };
            "Mod+C"."center-column" = { };
            "Mod+Ctrl+C"."center-visible-columns" = { };
            "Mod+Minus"."set-column-width" = "-10%";
            "Mod+Equal"."set-column-width" = "+10%";
            "Mod+Shift+Minus"."set-window-height" = "-10%";
            "Mod+Shift+Equal"."set-window-height" = "+10%";
            "Mod+V"."toggle-window-floating" = { };
            "Mod+Shift+V"."switch-focus-between-floating-and-tiling" = { };
            "Mod+W"."toggle-column-tabbed-display" = { };

            "Print"."screenshot-screen" = { };
            "Ctrl+Print".screenshot = { };
            "Alt+Print"."screenshot-window" = { };

            "Mod+Escape" = {
              _props.allow-inhibiting = false;
              "toggle-keyboard-shortcuts-inhibit" = { };
            };

            "Mod+Shift+E".quit = { };
            "Ctrl+Alt+Delete".quit = { };
            "Mod+Shift+P"."power-off-monitors" = { };
          };
        };
      };
    };
  };
}
