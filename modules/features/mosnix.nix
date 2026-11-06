{ lib, ... }:
let
  # Declaration site for the `moskas.*` settings knobs (theme, fonts, bar
  # position, ...). Exported for both module systems; an option unread by one
  # system (e.g. `colorscheme` in home-manager) is simply inert there.
  moskasOptions =
    { pkgs, ... }:
    {
      # Stable key so importing this module from several places dedups instead of
      # raising "option already declared".
      key = "moskas/options";

      options.moskas = {
        colorscheme = lib.mkOption {
          type = lib.types.str;
          default = "gruvbox-dark-medium";
          description = "Base16 colorscheme name from base16-schemes.";
        };

        desktop.bar = {
          position = lib.mkOption {
            type = lib.types.str;
            default = "top";
            description = "Default desktop bar position";
          };

          # Widget ids per bar section; capsule groups are referenced as "group:<name>".
          layout = {
            start = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [
                "control-center"
                "workspaces"
                "group:sysmon"
                "audio_visualizer"
              ];
              description = "Widgets in the start section of the bar.";
            };

            center = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ "group:media" ];
              description = "Widgets in the center section of the bar.";
            };

            end = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [
                "tray"
                "network"
                "bluetooth"
                "volume"
                "brightness"
                "battery"
                "clock"
                "group:notify"
              ];
              description = "Widgets in the end section of the bar.";
            };
          };

          # Defining any group replaces the whole default set.
          groups = lib.mkOption {
            type = lib.types.attrsOf (
              lib.types.submodule {
                options = {
                  members = lib.mkOption {
                    type = lib.types.listOf lib.types.str;
                    description = "Widgets inside the capsule group.";
                  };

                  fill = lib.mkOption {
                    type = lib.types.str;
                    default = "surface";
                    description = "Capsule fill color role.";
                  };

                  accordion = lib.mkOption {
                    type = lib.types.bool;
                    default = true;
                    description = "Collapse the group into an accordion.";
                  };
                };
              }
            );
            default = {
              notify = {
                fill = "surface_container";
                members = [
                  "notifications"
                  "clipboard"
                ];
              };
              sysmon.members = [
                "cpu"
                "temp"
                "ram"
              ];
              media = {
                accordion = false;
                members = [
                  "media"
                  "cat"
                ];
              };
            };
            description = "Bar capsule groups, keyed by group id.";
          };
        };

        fonts = {
          mono = lib.mkOption {
            type = lib.types.submodule {
              options = {
                package = lib.mkOption {
                  type = lib.types.package;
                  description = "Monospace font package.";
                };

                name = lib.mkOption {
                  type = lib.types.str;
                  description = "Monospace font family name.";
                };
              };
            };

            default = {
              package = pkgs.nerd-fonts.terminess-ttf;
              name = "Terminess Nerd Font";
            };

            description = "Monospace font used throughout the theme.";
          };

          sizes = {
            desktop = lib.mkOption {
              type = lib.types.int;
              default = 12;
            };

            terminal = lib.mkOption {
              type = lib.types.int;
              default = 12;
            };

            popups = lib.mkOption {
              type = lib.types.int;
              default = 12;
            };

            applications = lib.mkOption {
              type = lib.types.int;
              default = 12;
            };
          };
        };

        obs.cuda = lib.mkEnableOption "CUDA/NVENC-accelerated OBS build";
      };
    };
in
{
  flake.nixosModules.moskasOptions = moskasOptions;
  flake.homeModules.moskasOptions = moskasOptions;
}
