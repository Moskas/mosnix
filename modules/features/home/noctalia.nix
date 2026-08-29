{
  inputs,
  lib,
  self,
  ...
}:
{
  flake.homeModules.noctalia =
    { config, ... }:
    let
      # Shared capsule-group styling for the bar.
      capsuleGroup =
        args:
        {
          accordion = true;
          accordion_direction = "end";
          enabled = true;
          opacity = 1.0;
          padding = 6.0;
        }
        // args;
    in
    {
      imports = [
        inputs.noctalia.homeModules.default
        self.homeModules.moskasOptions
      ];
      config = {
        programs.noctalia = {
          enable = true;
          # v5 config scheme: https://docs.noctalia.dev/noctalia/configuration/
          settings = {
            accessibility.ui_scale = 1.15;

            backdrop.enabled = true;

            location = {
              auto_locate = false;
              address = "Wrocław, Poland";
            };

            #lockscreen.enabled = false;

            nightlight.enabled = true;

            plugins.enabled = [ "noctalia/bongocat" ];

            shell = {
              avatar_path = "/home/moskas/Pictures/avatar.png";
              corner_radius_scale = 0.0;
              polkit_agent = true;
              popup_shadows = false;
              screen_time_enabled = true;
              time_format = "{:%H:%M:%S}";

              launcher = {
                show_app_origin_indicator = false;
                sort_by_usage = false;
              };

              panel = {
                control_center_placement = "floating";
                open_near_click_control_center = true;
                shadow = false;
              };
            };

            control_center = {
              sidebar_section = "none";
              width = 900;
            };

            calendar = {
              enabled = true;
              account = {
                minemoskas = {
                  name = "Main";
                  type = "google";
                };
              };
            };

            battery.warning_threshold = 15;

            brightness = {
              enable_ddcutil = true;
              sync_all_monitors = true;
            };

            dock = {
              active_monitor_only = true;
              auto_hide = true;
              concave_edge_corners = false;
              enabled = true;
              launcher_position = "start";
              layer = "overlay";
              pinned = [
                "emacs"
                "firefox"
                "vesktop"
              ];
              radius = 0;
              reserve_space = false;
              shadow = false;
              show_dots = true;
            };

            bar.main = {
              position = config.moskas.desktop.bar.position;
              margin_ends = 0;
              padding = 8;
              radius = 0;
              shadow = false;
              thickness = 32;
              widget_spacing = 18;

              start = [
                "workspaces"
                "group:g2"
                "audio_visualizer"
              ];
              center = [ "group:g3" ];
              end = [
                "tray"
                "network"
                "bluetooth"
                "volume"
                "brightness"
                "battery"
                "clock"
                "group:g1"
              ];

              dead_zone.actions.left = "panel-toggle launcher";

              capsule_group = [
                (capsuleGroup {
                  id = "g1";
                  fill = "surface_variant";
                  members = [
                    "notifications"
                    "clipboard"
                  ];
                })
                (capsuleGroup {
                  id = "g2";
                  fill = "surface";
                  members = [
                    "cpu"
                    "temp"
                    "ram"
                  ];
                })
                (capsuleGroup {
                  id = "g3";
                  accordion = false;
                  fill = "surface_variant";
                  members = [
                    "media"
                    "cat"
                  ];
                })
              ];
            };

            notification = {
              enable_daemon = true;
              history_retention_hours = 12;
              filter = {
                feishin = {
                  enabled = true;
                  match = "feishin";
                  show_toast = true;
                  save_history = false;
                };
              };
            };

            widget = {
              audio_visualizer = {
                centered = false;
                color_2 = "tertiary";
                mirrored = false;
                width = 150;
              };

              battery.display_mode = "graphic";

              cat = {
                type = "noctalia/bongocat:cat";
                audio_spectrum = true;
                tappy_mode = true;
                use_mpris_filter = true;
              };

              clock = {
                capsule_padding = 10;
                format = "{:%H:%M:%S}";
                tooltip_format = "{:%d %B, %Y}";
              };

              "control-center" = {
                custom_image_colorize = true;
                glyph = "nix";
              };

              media = {
                capsule = true;
                capsule_padding = 12;
                hide_when_no_media = true;
                max_length = 300;
                min_length = 0;
                title_scroll = "on_hover";
              };

              network.show_label = false;

              sysmon.visualization = "none";

              tray = {
                detached_panel = true;
                drawer = true;
                match_adjacent_spacing = true;
              };

              workspaces = {
                empty_color = "shadow";
                occupied_color = "on_surface";
                style = "minimal";
              };
            };

            wallpaper = {
              enabled = true;
              directory = "/home/moskas/Pictures/Wallpapers/${lib.head (lib.splitString "-" config.lib.stylix.colors.scheme-slug)}/";
              directory_dark = "/home/moskas/Pictures/Wallpapers/${lib.head (lib.splitString "-" config.lib.stylix.colors.scheme-slug)}/dark/";
              directory_light = "/home/moskas/Pictures/Wallpapers/${lib.head (lib.splitString "-" config.lib.stylix.colors.scheme-slug)}/light/";
              automation = {
                enabled = true;
              };
            };

          };
        };
      };
    };
}
