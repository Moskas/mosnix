{ self, ... }:
{
  flake.nixosModules.stylixConfig =
    {
      pkgs,
      config,
      ...
    }:
    let
      monoFont = config.moskas.fonts.mono;
    in
    {
      imports = [ self.nixosModules.moskasOptions ];

      config = {
        stylix = {
          enable = true;
          autoEnable = true;
          image = null;
          targets.gtksourceview.enable = false;

          base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.moskas.colorscheme}.yaml";

          polarity = "dark";

          fonts = {
            monospace = monoFont;
            serif = monoFont;
            sansSerif = monoFont;
            emoji = {
              package = pkgs.noto-fonts-monochrome-emoji;
              name = "Noto Fonts Monochrome Emoji";
            };

            sizes = {
              desktop = config.moskas.fonts.sizes.desktop;
              terminal = config.moskas.fonts.sizes.terminal;
              popups = config.moskas.fonts.sizes.popups;
              applications = config.moskas.fonts.sizes.applications;
            };
          };

          cursor = {
            size = 16;
            package = pkgs.phinger-cursors;
            name = "phinger-cursors-light";
          };

        };
      };
    };
}
