{
  # GUI client for HTML-heavy mail; reuses the accounts from `email`
  flake.homeModules.thunderbird =
    { config, ... }:
    let
      c = config.lib.stylix.colors.withHashtag;
    in
    {
      programs.thunderbird = {
        enable = true;

        profiles.moskas = {
          isDefault = true;

          settings = {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            # Stylix polarity is dark; makes light-dark() pick the dark side
            "ui.systemUsesDarkTheme" = 1;
          };

          # Nova (TB 115+) ignores GTK colors, so remap its palette tokens to base16.
          # Token names taken from TB 158's colors.css, layout.css and variables.css.
          userChrome = ''
            :root,
            :host {
              --color-white: ${c.base06} !important;
              --color-gray-05: ${c.base06} !important;
              --color-gray-10: ${c.base05} !important;
              --color-gray-20: ${c.base05} !important;
              --color-gray-30: ${c.base04} !important;
              --color-gray-40: ${c.base04} !important;
              --color-gray-50: ${c.base03} !important;
              --color-gray-60: ${c.base03} !important;
              --color-gray-70: ${c.base02} !important;
              --color-gray-80: ${c.base01} !important;
              --color-gray-90: ${c.base00} !important;
              --color-black: ${c.base00} !important;
              --color-neutral-200: ${c.base02} !important;

              --selected-item-color: ${c.base0D} !important;
              --selected-item-text-color: ${c.base00} !important;
              --color-primary-default: ${c.base0D} !important;
              --color-primary-hover: ${c.base0C} !important;
              --color-primary-pressed: ${c.base0C} !important;
              --color-primary-soft: ${c.base02} !important;
              --focus-outline-color: ${c.base0D} !important;
              --new-folder-color: ${c.base0B} !important;

              --tabs-toolbar-background-color: ${c.base01} !important;
              --tabs-toolbar-box-shadow: none !important;
            }
          '';
        };
      };

      accounts.email.accounts.gmail.thunderbird = {
        enable = true;
        # `plain` auth is set for himalaya; use Google's OAuth2 login here instead
        settings = id: {
          "mail.server.server_${id}.authMethod" = 10;
          "mail.smtpserver.smtp_${id}.authMethod" = 10;
        };
      };
    };
}
