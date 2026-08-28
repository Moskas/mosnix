{ lib, ... }:
let
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
        fonts.mono = lib.mkOption {
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
        obs.cuda = lib.mkEnableOption "CUDA/NVENC-accelerated OBS build";
      };
    };
in
{
  flake.nixosModules.moskasOptions = moskasOptions;
  flake.homeModules.moskasOptions = moskasOptions;
}
