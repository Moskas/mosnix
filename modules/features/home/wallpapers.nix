{ lib, ... }:
{
  flake.homeModules.wallpapers =
    { config, pkgs, ... }:
    let
      # Pinned rev + per-theme hashes, bumped with the `update-wallpapers` devshell command
      pin = lib.importJSON ./wallpapers.json;
      theme = lib.head (lib.splitString "-" config.lib.stylix.colors.scheme-slug);
    in
    {
      config = lib.mkIf (pin.hashes ? ${theme}) {
        home.file."Pictures/Wallpapers/${theme}".source =
          (pkgs.fetchFromGitHub {
            owner = "Moskas";
            repo = "wallpapers";
            inherit (pin) rev;
            hash = pin.hashes.${theme};
            sparseCheckout = [ theme ];
          })
          + "/${theme}";
      };
    };
}
