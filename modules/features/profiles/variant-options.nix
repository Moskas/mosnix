{ lib, config, ... }:
let
  inherit (config.flake.lib.moskas.profiles) featureList;

  # Variant-selection options. Only meaningful on the NixOS side: the profile
  # resolver reads them during NixOS eval and pushes a concrete home feature
  # `imports` list into home-manager. Setting them under
  # `home-manager.users.moskas` is inert.
  moskasVariant = {
    key = "moskas/variant";

    options.moskas = {
      profile = lib.mkOption {
        type = lib.types.enum [
          "graphical"
          "terminal"
        ];
        default = "terminal";
        description = "Preset seeding the default enable-state of the home feature groups.";
      };

      desktop.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether this host runs a Wayland desktop (compositor + display manager). Defaulted true by the graphical profile.";
      };

      home = lib.genAttrs featureList (name: {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable the ${name} home feature module.";
        };
      });
    };
  };
in
{
  flake.nixosModules.moskasVariant = moskasVariant;
}
