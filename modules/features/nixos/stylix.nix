{
  flake.nixosModules.stylixConfig =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      monoFont = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrains Mono Nerd Font";
      };
    in
    {
      options.moskas.colorscheme = lib.mkOption {
        type = lib.types.str;
        default = "gruvbox-dark-medium";
        description = "Base16 colorscheme name from base16-schemes.";
      };

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
              terminal = 13;
              popups = 14;
              applications = 12;
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
