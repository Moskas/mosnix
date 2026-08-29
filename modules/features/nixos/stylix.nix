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

          base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.moskas.colorscheme}.yaml";

          polarity = "dark";

          fonts = {
            monospace = monoFont;
            serif = monoFont;
            sansSerif = monoFont;
            emoji = monoFont;

            sizes = {
              desktop = 14;
              terminal = 14;
              popups = 14;
              applications = 14;
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
