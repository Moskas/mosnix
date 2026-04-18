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
        stylix.targets.firefox = {
          profileNames = [ "default" ];
          firefoxGnomeTheme.enable = true;
        };

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
            BlockAboutProfiles = false;
            BlockAboutSupport = false;

            # UI and Behavior
            DisplayMenuBar = "never";
            DontCheckDefaultBrowser = true;
            HardwareAcceleration = true;
            OfferToSaveLogins = false;
            DefaultDownloadDirectory = "${config.home.homeDirectory}/Downloads";

            # Extensions
            ExtensionSettings =
              let
                moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
              in
              {
                # "*".installation_mode = "blocked";

                "uBlock0@raymondhill.net" = {
                  install_url = moz "ublock-origin";
                  installation_mode = "force_installed";
                  updates_disabled = true;
                };

                "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
                  install_url = moz "vimium-ff";
                  installation_mode = "force_installed";
                  updates_disabled = true;
                };

                "addon@darkreader.org" = {
                  install_url = moz "darkreader";
                  installation_mode = "force_installed";
                  updates_disabled = true;
                };

                # "" = {
                #   install_url = moz "";
                #   installation_mode = "force_installed";
                #   updates_disabled = true;
                # };
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

          profiles.default = {
            settings = {
              "browser.uiCustomization.state" =
                ''{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["dearrow_ajay_app-browser-action","_testpilot-containers-browser-action","_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action","jid1-mnnxcxisbpnsxq_jetpack-browser-action","sponsorblocker_ajay_app-browser-action","ublock0_raymondhill_net-browser-action","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","addon_darkreader_org-browser-action","7esoorv3_alefvanoon_anonaddy_me-browser-action","_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action","_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action","_4b7db180-f46c-4955-afaf-a03913751acc_-browser-action","frankerfacez_frankerfacez_com-browser-action"],"nav-bar":["sidebar-button","back-button","forward-button","stop-reload-button","customizableui-special-spring4","urlbar-container","vertical-spacer","customizableui-special-spring6","downloads-button","unified-extensions-button"],"toolbar-menubar":["menubar-items"],"TabsToolbar":[],"vertical-tabs":["tabbrowser-tabs"],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["developer-button","screenshot-button","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","addon_darkreader_org-browser-action","dearrow_ajay_app-browser-action","_testpilot-containers-browser-action","7esoorv3_alefvanoon_anonaddy_me-browser-action","jid1-mnnxcxisbpnsxq_jetpack-browser-action","_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action","sponsorblocker_ajay_app-browser-action","_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action","ublock0_raymondhill_net-browser-action","_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action","_4b7db180-f46c-4955-afaf-a03913751acc_-browser-action","frankerfacez_frankerfacez_com-browser-action"],"dirtyAreaCache":["nav-bar","TabsToolbar","vertical-tabs","PersonalToolbar","toolbar-menubar","unified-extensions-area"],"currentVersion":23,"newElementCount":8}'';
              "sidebar.verticalTabs" = "true";
              "sidebar.verticalTabs.dragToPinPromo.dismissed" = "true";
              # Disable window buttons when client side decorations are off
              "browser.tabs.inTitlebar" = 0;
            };
            search = {
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
    };
}
