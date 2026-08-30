{ lib, config, ... }:
let
  inherit (config.flake.lib.moskas.profiles) featureList;

  # Single declaration site for every `moskas.*` option. Exported for both
  # module systems; an option unread by one system (e.g. `colorscheme` in
  # home-manager) is simply inert there.
  moskasOptions =
    { pkgs, ... }:
    {
      # Stable key so importing this module from several places dedups instead of
      # raising "option already declared".
      key = "moskas/options";

      options.moskas = {
        profile = lib.mkOption {
          type = lib.types.enum [
            "full"
            "lightweight"
            "terminal"
          ];
          default = "terminal";
          description = "Preset seeding default enable-state for the desktop and graphical feature groups.";
        };

        desktop.enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether this host runs a Wayland desktop (compositor + display manager). Raised by graphical profiles.";
        };

        home = lib.genAttrs featureList (name: {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable the ${name} home feature module.";
          };
        });

        colorscheme = lib.mkOption {
          type = lib.types.str;
          default = "gruvbox-dark-medium";
          description = "Base16 colorscheme name from base16-schemes.";
        };

        desktop.bar.position = lib.mkOption {
          type = lib.types.str;
          default = "top";
          description = "Default desktop bar position";
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
              default = 14;
            };

            terminal = lib.mkOption {
              type = lib.types.int;
              default = 14;
            };

            popups = lib.mkOption {
              type = lib.types.int;
              default = 14;
            };

            applications = lib.mkOption {
              type = lib.types.int;
              default = 14;
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
