{
  flake.homeModules.firefox =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      # Extension ID -> addons.mozilla.org slug; installed via policy and
      # placed in the extensions panel by the toolbar layout below.
      extensions = {
        "uBlock0@raymondhill.net" = "ublock-origin";
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = "vimium-ff";
        "addon@darkreader.org" = "darkreader";
        "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" = "styl-us";
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
        "firefox@betterttv.net" = "betterttv";
        "sponsorBlocker@ajay.app" = "sponsorblock";
        "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = "return-youtube-dislikes";
        "jid1-MnnxcxisBpnsXQ@jetpack" = "privacy-badger17";
        "7esoorv3@alefvanoon.anonaddy.me" = "libredirect";
        "deArrow@ajay.app" = "dearrow";
        "@testpilot-containers" = "multi-account-containers";
      };

      # Mirrors Firefox's makeWidgetId: lowercase, anything outside [a-z0-9_-] -> "_".
      widgetId =
        id:
        let
          sanitize = c: if builtins.match "[a-z0-9_-]" c != null then c else "_";
        in
        lib.concatMapStrings sanitize (lib.stringToCharacters (lib.toLower id)) + "-browser-action";

      # Firefox Color is installed into the profile by stylix, not by policy.
      extensionWidgets = map widgetId (lib.attrNames extensions ++ [ "FirefoxColor@mozilla.com" ]);

      toolbarState = {
        placements = {
          widget-overflow-fixed-list = [ ];
          unified-extensions-area = extensionWidgets;
          nav-bar = [
            "sidebar-button"
            "back-button"
            "forward-button"
            "stop-reload-button"
            "customizableui-special-spring4"
            "urlbar-container"
            "vertical-spacer"
            "customizableui-special-spring6"
            "downloads-button"
            "unified-extensions-button"
          ];
          toolbar-menubar = [ "menubar-items" ];
          TabsToolbar = [ ];
          vertical-tabs = [ "tabbrowser-tabs" ];
          PersonalToolbar = [ "personal-bookmarks" ];
        };
        # Widgets listed here but not placed stay off the toolbar instead of
        # being auto-added to their default area.
        seen = [
          "developer-button"
          "screenshot-button"
          "reset-pbm-toolbar-button"
          "smartwindow-group-tabs-button"
          "ai-window-toggle"
        ]
        ++ extensionWidgets;
        dirtyAreaCache = [
          "nav-bar"
          "TabsToolbar"
          "vertical-tabs"
          "PersonalToolbar"
          "toolbar-menubar"
          "unified-extensions-area"
        ];
        # Must match the running Firefox, or its layout migrations rerun on
        # every start (user.js resets this pref each launch).
        currentVersion = 26;
        newElementCount = 8;
      };

      c = config.lib.stylix.colors.withHashtag;

      # The new tab page's CSP only allows https:, data:, blob: and chrome:
      # images, so the logo has to be inlined rather than linked from the store.
      # stylix already recolours nixos-icons to the base16 palette. @logo@ is
      # filled in at build time.
      userContent =
        pkgs.runCommand "userContent.css"
          {
            # New tab page. Content pages don't inherit userChrome.css, so the
            # square corners and base16 states are repeated here.
            css = ''
              @-moz-document url("about:home"), url("about:newtab") {
                :root {
                  --border-radius-circle: 0 !important;
                  --border-radius-xsmall: 0 !important;
                  --border-radius-small: 0 !important;
                  --border-radius-medium: 0 !important;
                  --border-radius-large: 0 !important;
                  --border-radius-xlarge: 0 !important;

                  --newtab-background-color: ${c.base00} !important;
                  --newtab-background-color-secondary: ${c.base01} !important;
                  --newtab-background-card: ${c.base01} !important;
                  --newtab-text-primary-color: ${c.base05} !important;
                  --newtab-element-hover-color: ${c.base02} !important;
                  --newtab-element-active-color: ${c.base03} !important;
                  --newtab-element-secondary-color: ${c.base01} !important;
                  --newtab-element-secondary-hover-color: ${c.base02} !important;
                  --newtab-element-secondary-active-color: ${c.base03} !important;
                  --newtab-button-background: ${c.base01} !important;
                  --newtab-button-hover-background: ${c.base02} !important;
                  --newtab-button-active-background: ${c.base03} !important;
                  --newtab-button-text: ${c.base05} !important;
                  --newtab-primary-action-background: ${c.base0D} !important;
                  --newtab-primary-element-text-color: ${c.base00} !important;
                  --focus-outline-color: ${c.base0D} !important;
                }

                * {
                  border-radius: 0 !important;
                }

                .logo-and-wordmark .logo {
                  background: url("@logo@") no-repeat center / contain !important;
                }

                .logo-and-wordmark .wordmark {
                  display: none !important;
                }

                /* Flat tiles: drop the drop shadow, outline on hover instead. */
                .top-site-outer .tile {
                  box-shadow: none !important;
                  border: 1px solid ${c.base02} !important;
                }

                .top-site-outer:is(:hover, :focus-within) .tile {
                  background: ${c.base02} !important;
                  border-color: ${c.base0D} !important;
                }
              }
            '';
            passAsFile = [ "css" ];
          }
          ''
            substitute "$cssPath" $out \
              --replace-fail @logo@ "data:image/svg+xml;base64,$(base64 -w0 ${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg)"
          '';

      # New tab shortcuts, in tile order. Rewritten from user.js on every
      # start, so pins added or removed in the UI only last until restart.
      pinnedSites = [
        {
          label = "NixOS Search";
          url = "https://search.nixos.org/packages";
        }
        {
          label = "NixOS Wiki";
          url = "https://wiki.nixos.org";
        }
        {
          label = "HM Options";
          url = "https://home-manager-options.extranix.com";
        }
        {
          label = "GitHub";
          url = "https://github.com";
        }
        {
          label = "YouTube";
          url = "https://www.youtube.com";
        }
        {
          label = "osu!";
          url = "https://osu.ppy.sh";
        }
      ];
    in
    {
      config = {
        stylix.targets.firefox = {
          profileNames = [ "moskas" ];
          colorTheme.enable = true;
        };

        programs.firefox = {
          enable = true;

          # Firefox only uses the XDG path (~/.config/mozilla/firefox) when
          # ~/.mozilla is absent, but home-manager always creates
          # ~/.mozilla/native-messaging-hosts, so Firefox falls back to the
          # legacy path and never sees the managed profile.
          configPath = ".mozilla/firefox";

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

            # New tab page: search + shortcuts, nothing sponsored or suggested
            FirefoxHome = {
              Search = true;
              TopSites = true;
              SponsoredTopSites = false;
              Highlights = false;
              Stories = false;
              SponsoredStories = false;
              Weather = false;
              Locked = true;
            };

            # Extensions
            ExtensionSettings = lib.mapAttrs (_: slug: {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
              installation_mode = "force_installed";
            }) extensions;

            # Extension configuration
            "3rdparty".Extensions = {
              "uBlock0@raymondhill.net".adminSettings = {
                userSettings = rec {
                  uiTheme = "dark";
                  cloudStorageEnabled = lib.mkForce false;

                  importedLists = [
                    "https://filters.adtidy.org/extension/ublock/filters/3.txt"
                    "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
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
                  "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
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

          profiles."moskas" = {
            # stylix's colorTheme target seeds the Firefox Color extension's
            # settings; acknowledge that it may overwrite existing ext state.
            extensions.force = true;

            # Square UI corners. Zeroing the design-system radius tokens on :root
            # reaches shadow-DOM widgets (buttons, panels, toggles) through
            # inheritance; the universal rule catches hardcoded radii elsewhere.
            inherit userContent;

            userChrome = ''
              :root {
                --border-radius-circle: 0 !important;
                --border-radius-xsmall: 0 !important;
                --border-radius-small: 0 !important;
                --border-radius-medium: 0 !important;
                --border-radius-large: 0 !important;
                --border-radius-xlarge: 0 !important;
                --button-border-radius: 0 !important;
                --panel-border-radius: 0 !important;
                --arrowpanel-border-radius: 0 !important;
                --toolbarbutton-border-radius: 0 !important;
                --tab-border-radius: 0 !important;
                --urlbar-border-radius: 0 !important;
                --urlbar-inner-border-radius: 0 !important;
                --window-border-radius: 0 !important;
              }

              * {
                border-radius: 0 !important;
              }

              /* Firefox derives hover/selected states as translucent
                 currentColor mixes, which turn muddy on base16 themes.
                 Declared on every element so per-widget defaults can't win. */
              * {
                --toolbarbutton-background-color-hover: ${c.base02} !important;
                --toolbarbutton-background-color-active: ${c.base03} !important;
                --button-background-color-hover: ${c.base02} !important;
                --button-background-color-active: ${c.base03} !important;
                --button-background-color-ghost-hover: ${c.base02} !important;
                --button-background-color-ghost-active: ${c.base03} !important;

                --tab-background-color-hover: ${c.base01} !important;
                --tab-background-color-selected: ${c.base02} !important;

                --urlbar-box-background-color: ${c.base01} !important;
                --urlbar-box-background-color-focus: ${c.base01} !important;
                --urlbar-box-background-color-hover: ${c.base03} !important;
                --urlbar-box-background-color-active: ${c.base03} !important;

                --urlbarview-background-color-hover: ${c.base01} !important;
                --urlbarview-background-color-selected: ${c.base02} !important;
                --urlbarview-text-color-selected: ${c.base05} !important;
              }

              /* The vertical tab strip has no background of its own and shows
                 the frame colour; match the toolbar instead. The horizontal
                 #TabsToolbar keeps the frame colour. */
              #sidebar-container {
                --sidebar-launcher-surface-color: var(--toolbar-background-color) !important;
                background-color: var(--toolbar-background-color) !important;
              }
            '';

            settings = {
              "browser.uiCustomization.state" = builtins.toJSON toolbarState;

              # Sidebar / vertical tabs
              "sidebar.revamp" = true;
              "sidebar.verticalTabs" = true;
              "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;
              "sidebar.new-sidebar.has-used" = true;
              # Launcher tools: open tabs + Bitwarden
              "sidebar.main.tools" = "opentabs,{446900e4-71c2-419f-a6a7-df9c091e268b}";
              # Extension sidebars Firefox has already offered; without this it
              # re-adds Stylus/Bitwarden to the launcher on a fresh profile.
              "sidebar.installed.extensions" =
                "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d},{446900e4-71c2-419f-a6a7-df9c091e268b}";
              # Startup state: collapsed launcher, no panel open.
              "sidebar.backupState" = builtins.toJSON {
                command = "";
                panelOpen = false;
                bookmarksExpandedFolders = [ ];
                launcherWidth = 50;
                launcherExpanded = false;
                launcherVisible = true;
                toolsHeight = 75;
                collapsedToolsHeight = 75;
              };

              # Disable window buttons when client side decorations are off
              "browser.tabs.inTitlebar" = 0;
              "browser.startup.homepage" = "https://nixos.org";
              "browser.search.region" = "PL";
              "browser.bookmarks.showMobileBookmarks" = true;
              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

              # Startup (new tab page is configured via the FirefoxHome policy)
              "browser.aboutConfig.showWarning" = false;
              "browser.newtabpage.pinned" = builtins.toJSON pinnedSites;
              # Always reopen the previous session, and do it silently after
              # unclean exits (e.g. niri quitting) instead of about:sessionrestore
              "browser.startup.page" = 3;
              "browser.sessionstore.max_resumed_crashes" = 999;

              # Login prompts
              "signon.autofillForms" = false;
              "signon.formlessCapture.enabled" = false;
              "network.auth.subresource-http-auth-allow" = 1;
              "extensions.enabledScopes" = 5;
              # Auto-enable profile-installed extensions (stylix's Firefox Color)
              "extensions.autoDisableScopes" = 0;

              # Telemetry
              "datareporting.policy.dataSubmissionEnabled" = false;
              "datareporting.healthreport.uploadEnabled" = false;
              "toolkit.telemetry.server" = "data:,";
              "toolkit.telemetry.archive.enabled" = false;
              "toolkit.telemetry.newProfilePing.enabled" = false;
              "toolkit.telemetry.shutdownPingSender.enabled" = false;
              "toolkit.telemetry.updatePing.enabled" = false;
              "toolkit.telemetry.bhrPing.enabled" = false;
              "toolkit.telemetry.firstShutdownPing.enabled" = false;
              "toolkit.telemetry.coverage.opt-out" = true;
              "toolkit.coverage.opt-out" = true;
              "toolkit.coverage.endpoint.base" = "";
              "beacon.enabled" = false;
              "network.captive-portal-service.enabled" = false;

              #"browser.display.use_system_colors" = true;

              # Cookies
              "browser.contentblocking.category" = "standard";
              "privacy.partition.serviceWorkers" = false;
              "privacy.partition.always_partition_third_party_non_cookie_storage" = true;
              "privacy.partition.always_partition_third_party_non_cookie_storage.exempt_sessionstorage" = true;

              # Performance
              "network.http.throttle.version" = 1; # Stops youtube/twitch from downgrading quality and stopping playback while it does it

              # Webgl
              "webgl.force-enabled" = true;
            };
            search = {
              default = "SearX";
              force = true;
              engines = {
                "SearX" = {
                  urls = [ { template = "https://searx.taila32e5.ts.net/search?q={searchTerms}"; } ];
                  icon = "https://searx.taila32e5.ts.net/static/themes/simple/img/favicon.svg";
                  definedAliases = [ "@sx" ];
                };
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
                  urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
                  icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
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
                  icon = "https://www.youtube.com/s/desktop/5d669aa8/img/favicon.ico";
                  definedAliases = [ "yt" ];
                };
                "Github Users" = {
                  urls = [ { template = "https://github.com/search?q={searchTerms}&type=users"; } ];
                  icon = "https://github.githubassets.com/favicons/favicon-dark.svg";
                  definedAliases = [ "gu" ];
                };
                "Github Repos" = {
                  urls = [ { template = "https://github.com/search?q={searchTerms}&type=repositories"; } ];
                  icon = "https://github.githubassets.com/favicons/favicon-dark.svg";
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
