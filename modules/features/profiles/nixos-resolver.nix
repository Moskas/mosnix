{ self, ... }:
{
  # System-level half of a profile. Wires home-manager for moskas, resolves the
  # home feature module set from `moskas.profile` + per-feature
  # `moskas.home.<feature>.enable` overrides, and pulls in the compositor stack
  # for graphical profiles.
  #
  # The feature set is computed here (NixOS eval) and pushed into home-manager as
  # a concrete `imports` list. Branching a module's own `imports` on one of its
  # options is infinite recursion, so all conditionality lives in `config`.
  flake.nixosModules.moskasProfile =
    { config, lib, ... }:
    let
      inherit (self.lib.moskas.profiles) featureList presets;
      preset = presets.${config.moskas.profile};
      hcfg = config.moskas.home;
      enabled = lib.filter (n: hcfg.${n}.enable) featureList;

      niriChildren =
        lib.optionals (lib.elem "noctalia" enabled) [ { spawn-at-startup._args = [ "noctalia" ]; } ]
        ++ lib.optionals (lib.elem "waybar" enabled) [ { spawn-at-startup._args = [ "waybar" ]; } ]
        ++ lib.optionals (lib.elem "mako" enabled) [ { spawn-at-startup._args = [ "mako" ]; } ];
    in
    {
      imports = [
        self.nixosModules.moskasOptions
        self.nixosModules.moskasHomeManager
        self.nixosModules.moskasOverlays
      ];

      config = lib.mkMerge [
        {
          # Preset seeds the per-feature defaults; explicit host settings win
          # because these are mkDefault.
          moskas.home = lib.mapAttrs (_: v: { enable = lib.mkDefault v; }) preset.home;
          moskas.desktop.enable = lib.mkDefault preset.desktop;

          # Hosts that skip `common` (e.g. the WSL host) still get a usable
          # nixpkgs for the moskas home.
          nixpkgs.config.allowUnfree = lib.mkDefault true;
        }

        (lib.mkIf preset.desktop {
          programs.niri.enable = true;
          services.displayManager.ly.enable = true;
        })

        {
          home-manager.users."moskas".imports = [
            self.homeModules.moskasOptions
          ]
          ++ map (n: self.homeModules.${n}) enabled
          ++ lib.optional (lib.elem "niri" enabled) {
            wayland.windowManager.niri.settings._children = niriChildren;
          };
        }
      ];
    };
}
