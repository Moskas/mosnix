{
  flake.homeModules.firefox =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      config = {
        programs.firefox = {
          enable = true;

          languagePacks = [ "en-US" ];

          policies = {
            # Updates & Background Services
            AppAutoUpdate = false;
            BackgroundAppUpdate = false;

            # Feature Disabling
            DisableBuiltinPDFViewer = true;
            DisableFirefoxStudies = true;
            DisableFirefoxAccounts = true;
            DisableFirefoxScreenshots = true;
            DisableForgetButton = true;
            DisableMasterPasswordCreation = true;
            DisableProfileImport = true;
            DisableProfileRefresh = true;
            DisableSetDesktopBackground = true;
            DisablePocket = true;
            DisableTelemetry = true;
            DisableFormHistory = true;
            DisablePasswordReveal = true;

            # Access Restrictions
            BlockAboutConfig = false;
            BlockAboutProfiles = true;
            BlockAboutSupport = true;

            # UI and Behavior
            DisplayMenuBar = "never";
            DontCheckDefaultBrowser = true;
            HardwareAcceleration = false;
            OfferToSaveLogins = false;
            DefaultDownloadDirectory = "${config.home.homeDirectory}/Downloads";

            # Extensions
            ExtensionSettings =
              let
                moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
              in
              {
                "*".installation_mode = "blocked";

                "uBlock0@raymondhill.net" = {
                  install_url = moz "ublock-origin";
                  installation_mode = "force_installed";
                  updates_disabled = true;
                };

                "{73a6fe31-595d-460b-a920-fcc0f8843232}" = {
                  install_url = moz "noscript";
                  installation_mode = "force_installed";
                  updates_disabled = true;
                };
              };

            # Extension configuration
            "3rdparty".Extensions = {
              "uBlock0@raymondhill.net".adminSettings = {
                userSettings = rec {
                  uiTheme = "dark";
                  cloudStorageEnabled = lib.mkForce false;

                  importedLists = [
                    "https:#filters.adtidy.org/extension/ublock/filters/3.txt"
                    "https:#github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
                  ];

                  externalLists = lib.concatStringsSep "\n" importedLists;
                };

                selectedFilterLists = [
                  "CZE-0"
                  "adguard-generic"
                  "adguard-annoyance"
                  "adguard-social"
                  "adguard-spyware-url"
                  "easylist"
                  "easyprivacy"
                  "https:#github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
                  "plowe-0"
                  "ublock-abuse"
                  "ublock-badware"
                  "ublock-filters"
                  "ublock-privacy"
                  "ublock-quick-fixes"
                  "ublock-unbreak"
                  "urlhaus-1"
                ];
              };
            };
          };

          profiles.default.search = {
            default = "StartPage";
            force = true;
            engines = {
              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };
              "Nix Options" = {
                urls = [
                  {
                    template = "https://search.nixos.org/options";
                    params = [
                      {
                        name = "type";
                        value = "options";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@no" ];
              };
              "NixOS Wiki" = {
                urls = [ { template = "https://nixos.wiki/index.php?search={searchTerms}"; } ];
                icon = "https://nixos.wiki/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = [ "@nw" ];
              };
              "Home Manager Options" = {
                urls = [ { template = "https://home-manager-options.extranix.com/?query={searchTerms}"; } ];
                icon = "https://home-manager-options.extranix.com/images/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = [ "hm" ];
              };
              "Osu Beatmaps" = {
                urls = [ { template = "https://osu.ppy.sh/beatmapsets?q={searchTerms}"; } ];
                icon = "https://upload.wikimedia.org/wikipedia/commons/1/1e/Osu%21_Logo_2016.svg";
                definedAliases = [ "ob" ];
              };
              "StartPage" = {
                urls = [ { template = "https://startpage.com/search?q={searchTerms}"; } ];
                icon = "https://www.startpage.com/sp/cdn/images/startpage-logo-dark-new.svg";
                definedAliases = [ "s" ];
              };
              "Brave" = {
                urls = [ { template = "https://search.brave.com/search?q={searchTerms}"; } ];
                icon = "https://brave.com/static-assets/images/brave-logo-dark.svg";
                definedAliases = [ "b" ];
              };
              "Docs.rs" = {
                urls = [ { template = "https://docs.rs/releases/search?query={searchTerms}"; } ];
                icon = "https://upload.wikimedia.org/wikipedia/commons/d/d5/Rust_programming_language_black_logo.svg";
                definedAliases = [ "d" ];
              };
              "Anna's Archive" = {
                urls = [ { template = "https://annas-archive.gl/search?q={searchTerms}"; } ];
                icon = "https://annas-archive.gl//favicon-32x32.png?hash=989ac03e6b8daade6d2d";
                definedAliases = [ "aa" ];
              };
              youtube = {
                urls = [ { template = "https://www.youtube.com/results?search_query={searchTerms}"; } ];
                definedAliases = [ "yt" ];
              };
              "Github Users" = {
                urls = [ { template = "https://github.com/search?q={searchTerms}&type=users"; } ];
                definedAliases = [ "gu" ];
              };
              "Github Repos" = {
                urls = [ { template = "https://github.com/search?q={searchTerms}&type=repositories"; } ];
                definedAliases = [ "gr" ];
              };
              bing.metaData.hidden = true;
              google.metaData.alias = "@g";
              "4get" = {
                urls = [ { template = "https://4get.ca/web?s={searchTerms}"; } ];
                definedAliases = [
                  "fg"
                  "4g"
                ];
              };
            };
          };
        };
      };
    };
}
