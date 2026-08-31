{ self, lib, ... }:
{
  # Support for the standalone `flake.homeConfigurations.<host>` outputs (home
  # activation without NixOS). The NixOS path uses moskasProfile instead.
  #
  # The per-profile modules use a static import list (no option-driven
  # branching) because a home module cannot branch its own `imports` on its own
  # options. Per-feature `moskas.home.<x>.enable` overrides only apply on the
  # NixOS path.
  flake.homeModules = {
    standalone-base = {
      home = {
        username = "moskas";
        homeDirectory = "/home/moskas";
        stateVersion = "26.05";
      };
    };
  }
  // lib.mapAttrs' (
    name: preset:
    lib.nameValuePair "standalone-${name}" {
      imports = [
        self.homeModules.moskasOptions
      ]
      ++ map (n: self.homeModules.${n}) (lib.attrNames preset.home);
    }
  ) self.lib.moskas.profiles.presets;
}
