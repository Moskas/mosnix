{
  flake.nixosModules.glance = {
    config = {
      # Reached via the tsnsrv `dashboard` node (dashboard.taila32e5.ts.net)
      services.glance = {
        enable = true;
        settings = {
          server = {
            host = "127.0.0.1";
            port = 8080;
          };
          branding.logo-url = "https://moskas.github.io/IMG/kitty.png";
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
                          name = "laffey";
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
                      sites = [
                        {
                          title = "Jellyfin";
                          url = "https://jellyfin.taila32e5.ts.net";
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
                      ];
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
