{
  flake.nixosModules.glance =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      monitorSites = [
        {
          title = "Jellyfin";
          url = "https://jelly.taila32e5.ts.net";
          icon = "si:jellyfin";
        }
        {
          title = "Forgejo";
          url = "https://git.taila32e5.ts.net";
          icon = "si:forgejo";
        }
        {
          title = "Deluge";
          url = "https://deluge.taila32e5.ts.net";
          icon = "si:deluge";
        }
        {
          title = "Grocy";
          url = "https://grocy.taila32e5.ts.net";
          icon = "si:grocy";
        }
        {
          title = "Searx";
          url = "https://searx.taila32e5.ts.net";
          icon = "si:searxng";
        }
        {
          title = "Vaultwarden";
          url = "https://vault.taila32e5.ts.net";
          icon = "si:vaultwarden";
        }
        {
          title = "Immich";
          url = "https://immich.taila32e5.ts.net";
          icon = "si:immich";
        }
        {
          title = "slskd";
          url = "https://slskd.taila32e5.ts.net";
          icon = "https://cdn.jsdelivr.net/gh/selfhst/icons@main/webp/slskd-light.webp";
        }
        {
          title = "n8n";
          url = "https://n8n.taila32e5.ts.net";
          icon = "si:n8n";
        }
      ];

      # Same URL glance resolves `si:` icons to, so the CSS can match the rendered <img src>
      iconUrl =
        icon:
        if lib.hasPrefix "si:" icon then
          "https://cdn.jsdelivr.net/npm/simple-icons@latest/icons/${lib.removePrefix "si:" icon}.svg"
        else
          icon;

      # CSS can't feed `src` into url(), so each icon gets its own mask rule; the image pixels are
      # pushed out of view and the background color shows through the icon shape instead
      monitorIconCss =
        color:
        lib.concatMapStrings (
          site:
          let
            url = iconUrl site.icon;
          in
          ''
            .monitor-site-icon[src="${url}"] {
              background-color: ${color};
              object-position: -999rem 0;
              filter: none !important;
              -webkit-mask: url("${url}") center / contain no-repeat;
              mask: url("${url}") center / contain no-repeat;
            }
          ''
        ) monitorSites;

      monoFont = config.moskas.fonts.mono;
      fontDir = "${monoFont.package}/share/fonts/truetype/NerdFonts/Terminess";
    in
    {
      config = {
        # Reached via the tsnsrv `dashboard` node (dashboard.taila32e5.ts.net)
        services.glance = {
          enable = true;
          settings = {
            server = {
              host = "127.0.0.1";
              port = 8080;
              # The stylix glance target sets the base HSL that glance derives its greys from;
              # this file pins each derived variable to an exact base16 color on top of it
              assets-path = pkgs.linkFarm "glance-assets" [
                {
                  name = "custom.css";
                  path = pkgs.writeText "custom.css" (
                    with config.lib.stylix.colors.withHashtag;
                    ''
                      :root {
                        --color-background: ${base00};
                        --color-widget-background: ${base00};
                        --color-widget-background-highlight: ${base01};
                        --color-widget-content-border: ${base02};
                        --color-separator: ${base01};
                        --color-popover-background: ${base01};
                        --color-popover-border: ${base02};
                        --color-progress-border: ${base02};
                        --color-progress-value: ${base03};
                        --color-vertical-progress-value: ${base03};
                        --color-graph-gridlines: ${base01};

                        --color-text-highlight: ${base07};
                        --color-text-paragraph: ${base05};
                        --color-text-base: ${base04};
                        --color-text-base-muted: ${base04};
                        --color-text-subdue: ${base03};

                        --color-primary: ${base07};
                        --color-positive: ${base0B};
                        --color-negative: ${base08};

                        --border-radius: 0;

                        --font-size-base: ${lib.toString config.moskas.fonts.sizes.desktop}px;
                        --font-size-h1: ${lib.toString (config.moskas.fonts.sizes.desktop + 6)}px;
                        --font-size-h2: ${lib.toString (config.moskas.fonts.sizes.desktop + 6)}px;
                        --font-size-h3: ${lib.toString (config.moskas.fonts.sizes.desktop + 6)}px;
                        --font-size-h4: ${lib.toString (config.moskas.fonts.sizes.desktop + 4)}px;
                        --font-size-h5: ${lib.toString config.moskas.fonts.sizes.desktop}px;
                        --font-size-h6: ${lib.toString config.moskas.fonts.sizes.desktop}px;
                      }

                      /* Installed copy first: web fonts lose the embedded bitmaps and render blurry at 1x */
                      @font-face {
                        font-family: "${monoFont.name}";
                        font-weight: 400;
                        font-display: swap;
                        src:
                          local("${monoFont.name}"),
                          local("TerminessNF"),
                          url("/assets/fonts/mono-regular.ttf") format("truetype");
                      }

                      @font-face {
                        font-family: "${monoFont.name}";
                        font-weight: 700;
                        font-display: swap;
                        src:
                          local("${monoFont.name} Bold"),
                          local("TerminessNF-Bold"),
                          url("/assets/fonts/mono-bold.ttf") format("truetype");
                      }

                      body {
                        font-family: "${monoFont.name}", monospace;
                        font-size: ${lib.toString config.moskas.fonts.sizes.desktop}px;
                      }

                      .popover-frame {
                        --shadow-color: color-mix(in srgb, ${base00} 50%, transparent);
                      }

                      .weather-column-rain::before {
                        background: radial-gradient(
                          circle at 4px 4px,
                          color-mix(in srgb, ${base0D} 40%, transparent) 1px,
                          transparent 0
                        );
                      }

                      .weather-column-daylight {
                        background: linear-gradient(
                          0deg,
                          transparent 30px,
                          color-mix(in srgb, ${base0A} 20%, transparent)
                        );
                      }

                      .weather-bar,
                      .weather-columns:hover .weather-bar {
                        background-color: color-mix(in srgb, ${base06} 35%, ${base00});
                        border-color: color-mix(in srgb, ${base06} 55%, ${base00});
                      }

                      .weather-column-current .weather-bar,
                      .weather-column:hover .weather-bar {
                        background-color: ${base05};
                        border-color: ${base03};
                      }

                      ${monitorIconCss base06}
                      .widget {
                        border-color: ${base02};
                        box-shadow: none !important;
                      }

                      .widget a {
                        color: ${base0A};
                      }

                      .widget-type-hacker-news a:visited,
                      .widget-type-lobsters a:visited {
                        color: ${base04};
                      }

                      .widget a:hover {
                        color: ${base09};
                      }
                    ''
                  );
                }
                {
                  name = "fonts/mono-regular.ttf";
                  path = "${fontDir}/TerminessNerdFont-Regular.ttf";
                }
                {
                  name = "fonts/mono-bold.ttf";
                  path = "${fontDir}/TerminessNerdFont-Bold.ttf";
                }
                {
                  # Stylix overlays nixos-icons with a recolored snowflake
                  name = "nix-snowflake.svg";
                  path = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                }
              ];
            };
            theme = {
              disable-picker = true;
              custom-css-file = "/assets/custom.css";
            };
            branding = {
              logo-url = "/assets/nix-snowflake.svg";
              favicon-url = "/assets/nix-snowflake.svg";
            };
            pages = [
              {
                name = "Dashboard";
                columns = [
                  {
                    size = "small";
                    widgets = [
                      {
                        type = "clock";
                        hour-format = "24h";
                        timezones = [
                          { timezone = "Europe/Warsaw"; }
                          { timezone = "America/Los_Angeles"; }
                          { timezone = "Asia/Tokyo"; }
                        ];
                      }
                      {
                        type = "server-stats";
                        servers = [
                          {
                            type = "local";
                            name = "${config.networking.hostName}";
                          }
                        ];
                      }
                      {
                        type = "weather";
                        location = "Wrocław, Poland";
                      }
                    ];
                  }
                  {
                    size = "full";
                    widgets = [
                      {
                        type = "monitor";
                        cache = "1m";
                        title = "Services";
                        sites = monitorSites;
                      }
                      {
                        type = "bookmarks";
                        groups = [
                          {
                            title = "Development";
                            links = [
                              {
                                title = "Github";
                                url = "https://github.com";
                              }
                              {
                                title = "Rust Book";
                                url = "https://doc.rust-lang.org/book/";
                              }
                            ];
                          }
                          {
                            title = "Media";
                            links = [
                              {
                                title = "anilist";
                                url = "https://anilist.co";
                              }
                              {
                                title = "Soundcloud";
                                url = "https://soundcloud.com";
                              }
                            ];
                          }
                          {
                            title = "Social";
                            links = [
                              {
                                title = "Fosstodon";
                                url = "https://fosstodon.org/";
                              }
                              {
                                title = "Lemmy";
                                url = "https://lemmy.world";
                              }
                            ];
                          }
                        ];
                      }
                      {
                        type = "group";
                        widgets = [
                          {
                            type = "lobsters";
                            tags = [
                              "nix"
                              "linux"
                              "rust"
                              "devops"
                              "emacs"
                            ];
                          }
                          {
                            type = "hacker-news";
                            limit = 10;
                            collapse-after = 5;
                          }
                        ];
                      }
                    ];
                  }
                ];
              }
            ];
          };
        };
      };
    };
}
