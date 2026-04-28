{ inputs, config, ... }:
{
  flake.homeModules.nixcord =
    { config, ... }:
    with config.lib.stylix.colors.withHashtag;
    {
      imports = [ inputs.nixcord.homeModules.nixcord ];
      stylix.targets.nixcord.enable = false;
      programs.nixcord = {
        enable = true;
        discord.enable = false;
        vesktop = {
          enable = true;
          useSystemVencord = true;
          settings = {
            minimizeToTray = false;
            tray = false;
            splashColor = "${base05}";
            splashBackground = "${base00}";
          };
        };
        quickCss = ''
          * {
            border-radius: 0 !important;
          }

          body {
              --font: ${config.stylix.fonts.monospace.name} !important;
              --code-font: ${config.stylix.fonts.monospace.name} !important;
          }

          :root {
              --colors: on; /* off: discord default colors, on: midnight custom colors */

              /* text colors */
              --text-0: ${base00}; /* text on colored elements */
              --text-1: ${base05}; /* other normally white text */
              --text-2: ${base06}; /* headings and important text */
              --text-3: ${base05}; /* normal text */
              --text-4: ${base05}; /* icon buttons and channels */
              --text-5: ${base04}; /* muted channels/chats and timestamps */

              /* background and dark colors */
              --bg-1: ${base00}; /* dark buttons when clicked */
              --bg-2: ${base01}; /* dark buttons */
              --bg-3: ${base01}; /* spacing, secondary elements */
              --bg-4: ${base00}; /* main background color */
              --hover: ${base01}; /* channels and buttons when hovered */
              --active: ${base01}; /* channels and buttons when clicked or selected */
              --active-2: ${base01}; /* extra state for transparent buttons */
              --message-hover: ${base01}; /* messages when hovered */

              /* accent colors */
              --accent-1: var(--blue-1); /* links and other accent text */
              --accent-2: var(--blue-2); /* small accent elements */
              --accent-3: var(--blue-3); /* accent buttons */
              --accent-4: var(--blue-4); /* accent buttons when hovered */
              --accent-5: var(--blue-5); /* accent buttons when clicked */
              --accent-new: var(--accent-2); /* stuff that's normally red like mute/deafen buttons */
              --mention: linear-gradient(to right, color-mix(in hsl, var(--accent-2), transparent 90%) 40%, transparent); /* background of messages that mention you */
              --mention-hover: linear-gradient(to right, color-mix(in hsl, var(--accent-2), transparent 95%) 40%, transparent); /* background of messages that mention you when hovered */
              --reply: linear-gradient(to right, color-mix(in hsl, var(--text-3), transparent 90%) 40%, transparent); /* background of messages that reply to you */
              --reply-hover: linear-gradient(to right, color-mix(in hsl, var(--text-3), transparent 95%) 40%, transparent); /* background of messages that reply to you when hovered */

              /* status indicator colors */
              --online: ${base0B}; /* change to #40a258 for default */
              --dnd: ${base08}; /* change to #d83a41 for default */
              --idle: ${base0A}; /* change to #cc954c for default */
              --streaming: ${base0E}; /* change to ##9147ff for default */
              --offline: var(--text-4); /* change to #82838b for default offline color */

              /* border colors */
              --border-light: var(--hover); /* general light border color */
              --border: var(--active); /* general normal border color */
              --border-hover: var(--active); /* border color of panels when hovered */
              --button-border: hsl(220, 0%, 100%, 0.1); /* neutral border color of buttons */

              /* base colors */
              --red-1: ${base08};
              --red-2: ${base08};
              --red-3: ${base08};
              --red-4: ${base08};
              --red-5: ${base08};

              --green-1: ${base0B};
              --green-2: ${base0B};
              --green-3: ${base0B};
              --green-4: ${base0B};
              --green-5: ${base0B};

              --blue-1: ${base0D};
              --blue-2: ${base0D};
              --blue-3: ${base0D};
              --blue-4: ${base0D};
              --blue-5: ${base0D};

              --yellow-1: ${base0A};
              --yellow-2: ${base0A};
              --yellow-3: ${base0A};
              --yellow-4: ${base0A};
              --yellow-5: ${base0A};

              --purple-1: ${base0E};
              --purple-2: ${base0E};
              --purple-3: ${base0E};
              --purple-4: ${base0E};
              --purple-5: ${base0E};
          }
        '';
        config = {
          notifyAboutUpdates = false;
          autoUpdate = false;
          autoUpdateNotification = false;
          useQuickCss = true;
          frameless = true;
          disableMinSize = true;
          themeLinks = [
            "https://raw.githubusercontent.com/refact0r/midnight-discord/refs/heads/master/themes/midnight.theme.css"
          ];
          plugins = {
            anonymiseFileNames.enable = true;
            petpet.enable = true;
            ClearURLs.enable = true;
            betterFolders = {
              enable = false;
              closeAllFolders = true;
              closeAllHomeButton = true;
            };
            spotifyControls.enable = true;
            dearrow.enable = true;
            youtubeAdblock.enable = true;
            fixYoutubeEmbeds.enable = true;
            forceOwnerCrown.enable = true;
            gameActivityToggle.enable = true;
            noBlockedMessages.enable = true;
            noReplyMention.enable = true;
            newGuildSettings.enable = true;
          };
        };
      };
    };
}
