{ inputs, ... }:
{
  flake.homeModules.nixcord =
    { config, ... }:
    let
      c = config.lib.stylix.colors.withHashtag;
      font = ''"${config.stylix.fonts.monospace.name}", monospace'';

      # Same roles as the Firefox content theme: base00 canvas, base01 boxes,
      # base02 hover/borders, base03 active, base0D accent.
      accentHover = "color-mix(in srgb, ${c.base0D} 80%, ${c.base05})";
      accentActive = "color-mix(in srgb, ${c.base0D} 60%, ${c.base05})";
      tint = color: amount: "color-mix(in srgb, ${color} ${toString amount}%, transparent)";
    in
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
            splashColor = c.base05;
            splashBackground = c.base00;
          };
        };
        config = {
          notifyAboutUpdates = false;
          autoUpdate = false;
          autoUpdateNotification = false;
          useQuickCss = true;
          frameless = true;
          disableMinSize = true;
          enabledThemes = [ "base16.css" ];
          # Maps Discord's native design tokens straight to the base16 palette,
          # no remote theme involved.
          themes.base16 = ''
            /**
             * @name base16
             * @author moskas
             * @version 1.0.0
             * @description Flat base16 theme generated from the stylix palette.
             **/

            * {
              border-radius: 0 !important;
              /* Terminess only renders crisp on whole-pixel glyph advances. */
              letter-spacing: 0 !important;
              font-synthesis: none !important;
            }

            /* Bump the 10/11px spots to Terminess' smallest crisp size. */
            :is(time, [class^="separator_"], [class^="edited_"], [class^="acronym_"]) {
              font-size: 12px !important;
            }

            :root,
            .theme-light,
            .theme-dark,
            .theme-darker,
            .theme-midnight,
            .visual-refresh {
              --font-primary: ${font} !important;
              --font-display: ${font} !important;
              --font-headline: ${font} !important;
              --font-code: ${font} !important;

              /* panes */
              --app-frame-background: ${c.base00} !important;
              --app-frame-border: ${c.base02} !important;
              --background-base-lowest: ${c.base00} !important;
              --background-base-lower: ${c.base00} !important;
              --background-base-low: ${c.base00} !important;
              --background-primary: ${c.base00} !important;
              --background-secondary: ${c.base00} !important;
              --background-tertiary: ${c.base00} !important;
              --home-background: ${c.base00} !important;
              --bg-base-primary: ${c.base00} !important;
              --bg-base-secondary: ${c.base00} !important;
              --bg-base-tertiary: ${c.base00} !important;

              /* raised surfaces: popouts, cards, inputs, modals */
              --background-surface-high: ${c.base01} !important;
              --background-surface-higher: ${c.base01} !important;
              --background-surface-highest: ${c.base01} !important;
              --background-floating: ${c.base01} !important;
              --background-secondary-alt: ${c.base01} !important;
              --bg-surface-raised: ${c.base01} !important;
              --bg-surface-overlay: ${c.base01} !important;
              --bg-surface-overlay-tmp: ${c.base01} !important;
              --card-background-default: ${c.base01} !important;
              --card-primary-bg: ${c.base01} !important;
              --chat-background-default: ${c.base01} !important;
              --channeltextarea-background: ${c.base01} !important;
              --input-background-default: ${c.base01} !important;
              --input-background: ${c.base01} !important;
              --background-code: ${c.base01} !important;
              --modal-background: ${c.base01} !important;
              --modal-footer-background: ${c.base01} !important;
              --user-profile-overlay-background: ${c.base01} !important;
              --user-profile-toolbar-background: ${c.base01} !important;
              --user-profile-note-background-focus: ${c.base00} !important;
              --activity-card-background: ${c.base01} !important;
              --background-accent: ${c.base02} !important;
              --background-scrim: ${tint c.base00 70} !important;
              --background-scrim-lightbox: ${tint c.base00 90} !important;

              /* states */
              --background-mod-subtle: ${c.base02} !important;
              --background-mod-muted: ${c.base02} !important;
              --background-mod-normal: ${c.base02} !important;
              --background-mod-strong: ${c.base03} !important;
              --background-modifier-hover: ${c.base02} !important;
              --background-modifier-active: ${c.base03} !important;
              --background-modifier-selected: ${c.base03} !important;
              --background-modifier-accent: ${c.base02} !important;
              --interactive-background-hover: ${c.base02} !important;
              --interactive-background-active: ${c.base03} !important;
              --interactive-background-selected: ${c.base03} !important;
              --message-background-hover: ${c.base01} !important;
              --background-message-hover: ${c.base01} !important;
              --user-profile-background-hover: ${c.base02} !important;
              --user-profile-overlay-background-hover: ${c.base02} !important;

              /* text */
              --text-default: ${c.base05} !important;
              --text-normal: ${c.base05} !important;
              --text-primary: ${c.base05} !important;
              --text-strong: ${c.base06} !important;
              --header-primary: ${c.base06} !important;
              --header-secondary: ${c.base04} !important;
              --text-secondary: ${c.base04} !important;
              --text-subtle: ${c.base04} !important;
              --text-muted: ${c.base04} !important;
              --text-tertiary: ${c.base03} !important;
              --chat-text-muted: ${c.base04} !important;
              --channel-text-area-placeholder: ${c.base03} !important;
              --input-placeholder-text-default: ${c.base03} !important;
              --input-text-default: ${c.base05} !important;
              --textbox-markdown-syntax: ${c.base04} !important;
              --text-link: ${c.base0D} !important;
              --text-brand: ${c.base0D} !important;
              --text-overlay-light: ${c.base00} !important;
              --app-message-embed-secondary-text: ${c.base04} !important;
              --spine-default: ${c.base03} !important;

              /* icons and interactive text */
              --interactive-normal: ${c.base04} !important;
              --interactive-hover: ${c.base05} !important;
              --interactive-active: ${c.base06} !important;
              --interactive-muted: ${c.base03} !important;
              --interactive-text-default: ${c.base04} !important;
              --interactive-text-hover: ${c.base05} !important;
              --interactive-text-active: ${c.base06} !important;
              --interactive-icon-default: ${c.base04} !important;
              --interactive-icon-hover: ${c.base05} !important;
              --interactive-icon-active: ${c.base06} !important;
              --channels-default: ${c.base04} !important;
              --channel-icon: ${c.base04} !important;
              --icon-default: ${c.base04} !important;
              --icon-subtle: ${c.base04} !important;
              --icon-muted: ${c.base03} !important;
              --icon-strong: ${c.base05} !important;
              --icon-link: ${c.base0D} !important;
              --icon-voice-muted: ${c.base08} !important;

              /* borders */
              --border-faint: ${c.base02} !important;
              --border-subtle: ${c.base02} !important;
              --border-muted: ${c.base02} !important;
              --border-normal: ${c.base02} !important;
              --border-strong: ${c.base03} !important;
              --border-focus: ${c.base0D} !important;
              --border-feedback-critical: ${c.base08} !important;
              --input-border-default: ${c.base02} !important;
              --input-border-hover: ${c.base03} !important;
              --input-border-active: ${c.base0D} !important;
              --input-border-error-default: ${c.base08} !important;
              --user-profile-border: ${c.base02} !important;
              --user-profile-toolbar-border: ${c.base02} !important;

              /* accent */
              --brand-260: ${c.base0D} !important;
              --brand-360: ${c.base0D} !important;
              --brand-500: ${c.base0D} !important;
              --brand-560: ${accentHover} !important;
              --brand-600: ${accentActive} !important;
              --blurple-50: ${c.base0D} !important;
              --background-brand: ${c.base0D} !important;
              --bg-brand: ${c.base0D} !important;
              --control-brand-foreground: ${c.base0D} !important;
              --control-brand-foreground-new: ${c.base0D} !important;
              --badge-background-default: ${c.base0D} !important;
              --badge-text-default: ${c.base00} !important;
              --badge-notification-background: ${c.base08} !important;
              --background-feedback-notification: ${c.base08} !important;
              --progressbar-indicator-background: ${c.base0D} !important;
              --progressbar-track-background: ${c.base02} !important;
              --slider-track-background: ${c.base02} !important;

              /* primary buttons */
              --control-primary-background-default: ${c.base0D} !important;
              --control-primary-background-hover: ${accentHover} !important;
              --control-primary-background-active: ${accentActive} !important;
              --control-primary-border-default: ${c.base0D} !important;
              --control-primary-border-hover: ${accentHover} !important;
              --control-primary-border-active: ${accentActive} !important;
              --control-primary-text-default: ${c.base00} !important;
              --control-primary-text-hover: ${c.base00} !important;
              --control-primary-text-active: ${c.base00} !important;
              --control-primary-icon-default: ${c.base00} !important;
              --control-primary-icon-hover: ${c.base00} !important;
              --control-primary-icon-active: ${c.base00} !important;
              --button-filled-brand-background: ${c.base0D} !important;
              --button-filled-brand-background-hover: ${accentHover} !important;
              --button-filled-brand-background-active: ${accentActive} !important;
              --button-filled-brand-text: ${c.base00} !important;
              --button-filled-brand-text-hover: ${c.base00} !important;

              /* secondary buttons */
              --control-secondary-background-default: ${c.base01} !important;
              --control-secondary-background-hover: ${c.base02} !important;
              --control-secondary-background-active: ${c.base03} !important;
              --control-secondary-border-default: ${c.base02} !important;
              --control-secondary-border-hover: ${c.base03} !important;
              --control-secondary-border-active: ${c.base03} !important;
              --control-secondary-text-default: ${c.base05} !important;
              --control-secondary-text-hover: ${c.base05} !important;
              --control-secondary-text-active: ${c.base05} !important;
              --control-secondary-icon-default: ${c.base05} !important;
              --control-secondary-icon-hover: ${c.base05} !important;
              --control-secondary-icon-active: ${c.base05} !important;
              --redesign-button-secondary-background: ${c.base01} !important;
              --redesign-button-secondary-pressed-background: ${c.base03} !important;
              --redesign-button-secondary-text: ${c.base05} !important;
              --button-secondary-background: ${c.base01} !important;
              --button-secondary-background-hover: ${c.base02} !important;
              --button-secondary-background-active: ${c.base03} !important;
              --button-outline-primary-text: ${c.base05} !important;

              /* icon-only buttons */
              --control-icon-only-background-hover: ${c.base02} !important;
              --control-icon-only-background-active: ${c.base03} !important;
              --control-icon-only-border-hover: ${c.base02} !important;
              --control-icon-only-border-active: ${c.base03} !important;
              --control-icon-only-icon-default: ${c.base04} !important;
              --control-icon-only-icon-hover: ${c.base05} !important;
              --control-icon-only-icon-active: ${c.base06} !important;

              /* connect (join voice) buttons */
              --control-connect-background-default: ${c.base0B} !important;
              --control-connect-background-hover: color-mix(in srgb, ${c.base0B} 80%, ${c.base05}) !important;
              --control-connect-background-active: color-mix(in srgb, ${c.base0B} 60%, ${c.base05}) !important;
              --control-connect-border-default: ${c.base0B} !important;
              --control-connect-border-hover: ${c.base0B} !important;
              --control-connect-border-active: ${c.base0B} !important;
              --control-connect-text-default: ${c.base00} !important;
              --control-connect-text-hover: ${c.base00} !important;
              --control-connect-text-active: ${c.base00} !important;
              --control-connect-icon-default: ${c.base00} !important;
              --control-connect-icon-hover: ${c.base00} !important;
              --control-connect-icon-active: ${c.base00} !important;

              /* destructive buttons */
              --control-critical-primary-background-default: ${c.base08} !important;
              --control-critical-primary-background-hover: color-mix(in srgb, ${c.base08} 80%, ${c.base05}) !important;
              --control-critical-primary-background-active: color-mix(in srgb, ${c.base08} 60%, ${c.base05}) !important;
              --control-critical-primary-border-default: ${c.base08} !important;
              --control-critical-primary-border-hover: ${c.base08} !important;
              --control-critical-primary-border-active: ${c.base08} !important;
              --control-critical-primary-text-default: ${c.base00} !important;
              --control-critical-primary-text-hover: ${c.base00} !important;
              --control-critical-primary-text-active: ${c.base00} !important;
              --control-critical-primary-icon-default: ${c.base00} !important;
              --control-critical-primary-icon-hover: ${c.base00} !important;
              --control-critical-primary-icon-active: ${c.base00} !important;
              --control-critical-secondary-background-default: ${c.base01} !important;
              --control-critical-secondary-background-hover: ${c.base02} !important;
              --control-critical-secondary-background-active: ${c.base03} !important;
              --control-critical-secondary-border-default: ${c.base02} !important;
              --control-critical-secondary-border-hover: ${c.base08} !important;
              --control-critical-secondary-border-active: ${c.base08} !important;
              --control-critical-secondary-text-default: ${c.base08} !important;
              --control-critical-secondary-text-hover: ${c.base08} !important;
              --control-critical-secondary-text-active: ${c.base08} !important;
              --control-critical-secondary-icon-default: ${c.base08} !important;
              --control-critical-secondary-icon-hover: ${c.base08} !important;
              --control-critical-secondary-icon-active: ${c.base08} !important;
              --button-danger-background: ${c.base08} !important;
              --menu-item-danger-hover-bg: ${c.base08} !important;
              --menu-item-danger-active-bg: ${c.base08} !important;
              --menu-item-default-hover-bg: ${c.base02} !important;

              /* toggles */
              --checkbox-background-default: ${c.base01} !important;
              --checkbox-background-hover: ${c.base02} !important;
              --checkbox-background-active: ${c.base03} !important;
              --checkbox-background-selected-default: ${c.base0D} !important;
              --checkbox-background-selected-hover: ${accentHover} !important;
              --checkbox-border-default: ${c.base03} !important;
              --checkbox-border-hover: ${c.base03} !important;
              --checkbox-border-active: ${c.base03} !important;
              --checkbox-border-selected-default: ${c.base0D} !important;
              --checkbox-border-selected-hover: ${accentHover} !important;
              --checkbox-icon-active: ${c.base00} !important;
              --radio-background-default: ${c.base01} !important;
              --radio-background-hover: ${c.base02} !important;
              --radio-background-active: ${c.base03} !important;
              --radio-background-selected-default: ${c.base0D} !important;
              --radio-background-selected-hover: ${accentHover} !important;
              --radio-border-default: ${c.base03} !important;
              --radio-border-hover: ${c.base03} !important;
              --radio-border-active: ${c.base03} !important;
              --radio-border-selected-default: ${c.base0D} !important;
              --radio-border-selected-hover: ${accentHover} !important;
              --radio-thumb-background-active: ${c.base00} !important;
              --switch-background-default: ${c.base02} !important;
              --switch-background-hover: ${c.base03} !important;
              --switch-background-selected-default: ${c.base0D} !important;
              --switch-background-selected-hover: ${accentHover} !important;
              --switch-border-default: ${c.base02} !important;
              --switch-border-hover: ${c.base03} !important;
              --switch-border-selected-default: ${c.base0D} !important;
              --switch-border-selected-hover: ${accentHover} !important;
              --switch-thumb-background-default: ${c.base05} !important;
              --switch-thumb-background-selected-default: ${c.base00} !important;

              /* messages */
              --mention-foreground: ${c.base0D} !important;
              --mention-background: ${tint c.base0D 20} !important;
              --message-mentioned-background-default: ${tint c.base0D 10} !important;
              --message-mentioned-background-hover: ${tint c.base0D 15} !important;
              --background-mentioned: ${tint c.base0D 10} !important;
              --background-mentioned-hover: ${tint c.base0D 15} !important;
              --info-warning-foreground: ${c.base0D} !important;
              --message-highlight-background-default: ${tint c.base05 6} !important;
              --message-highlight-background-hover: ${tint c.base05 9} !important;
              --background-message-highlight: ${tint c.base05 6} !important;
              --message-reacted-background-default: ${tint c.base0D 15} !important;
              --message-reacted-text-default: ${c.base06} !important;
              --reaction-background-default: ${c.base01} !important;
              --reaction-background-hover: ${c.base02} !important;
              --reaction-background-active: ${c.base03} !important;
              --reaction-background-reacted-default: ${tint c.base0D 15} !important;
              --reaction-background-reacted-hover: ${tint c.base0D 25} !important;
              --reaction-border-default: ${c.base02} !important;
              --reaction-border-hover: ${c.base03} !important;
              --reaction-border-active: ${c.base03} !important;
              --reaction-border-reacted-default: ${c.base0D} !important;
              --reaction-text-default: ${c.base05} !important;
              --reaction-text-hover: ${c.base06} !important;
              --reaction-text-active: ${c.base06} !important;
              --reaction-text-reacted-default: ${c.base06} !important;
              --polls-voted-fill: ${tint c.base0D 15} !important;
              --polls-victor-fill: ${tint c.base0B 15} !important;

              /* status */
              --status-online: ${c.base0B} !important;
              --status-idle: ${c.base0A} !important;
              --status-dnd: ${c.base08} !important;
              --status-streaming: ${c.base0E} !important;
              --status-offline: ${c.base04} !important;
              --status-speaking: ${c.base0B} !important;
              --status-positive: ${c.base0B} !important;
              --status-positive-background: ${c.base0B} !important;
              --status-positive-text: ${c.base00} !important;
              --status-success: ${c.base0B} !important;
              --status-warning: ${c.base0A} !important;
              --status-warning-background: ${c.base0A} !important;
              --status-warning-text: ${c.base00} !important;
              --status-danger: ${c.base08} !important;
              --status-danger-background: ${c.base08} !important;
              --status-negative: ${c.base08} !important;
              --icon-status-online: ${c.base0B} !important;
              --icon-status-idle: ${c.base0A} !important;
              --icon-status-dnd: ${c.base08} !important;
              --icon-status-offline: ${c.base04} !important;
              --text-status-online: ${c.base0B} !important;
              --text-status-idle: ${c.base0A} !important;
              --text-status-dnd: ${c.base08} !important;
              --text-status-offline: ${c.base04} !important;

              /* feedback */
              --text-feedback-positive: ${c.base0B} !important;
              --text-feedback-critical: ${c.base08} !important;
              --text-feedback-warning: ${c.base0A} !important;
              --text-feedback-info: ${c.base0D} !important;
              --text-positive: ${c.base0B} !important;
              --text-negative: ${c.base08} !important;
              --text-warning: ${c.base0A} !important;
              --icon-feedback-positive: ${c.base0B} !important;
              --icon-feedback-critical: ${c.base08} !important;
              --icon-feedback-warning: ${c.base0A} !important;
              --icon-feedback-info: ${c.base0D} !important;
              --background-feedback-positive: ${tint c.base0B 20} !important;
              --background-feedback-critical: ${tint c.base08 20} !important;
              --background-feedback-warning: ${tint c.base0A 20} !important;
              --background-feedback-info: ${tint c.base0D 20} !important;
              --background-code-addition: ${tint c.base0B 20} !important;
              --background-code-deletion: ${tint c.base08 20} !important;
              --notice-background-positive: ${c.base0B} !important;
              --notice-background-warning: ${c.base0A} !important;
              --notice-background-info: ${c.base0D} !important;
              --notice-background-critical: ${c.base08} !important;
              --notice-text-positive: ${c.base00} !important;
              --notice-text-warning: ${c.base00} !important;
              --notice-text-info: ${c.base00} !important;
              --notice-text-critical: ${c.base00} !important;
              --input-background-error-default: ${tint c.base08 10} !important;

              /* base palette used by plugins and older components */
              --red-400: ${c.base08} !important;
              --red-460: ${c.base08} !important;
              --red-500: ${c.base08} !important;
              --red-630: ${c.base08} !important;
              --green-330: ${c.base0B} !important;
              --green-360: ${c.base0B} !important;
              --yellow-300: ${c.base0A} !important;
              --yellow-360: ${c.base0A} !important;
              --teal-430: ${c.base0C} !important;
              --primary-400: ${c.base04} !important;

              --scrollbar-auto-thumb: ${c.base02} !important;
              --scrollbar-auto-track: transparent !important;
              --scrollbar-thin-thumb: ${c.base02} !important;
              --scrollbar-thin-track: transparent !important;
            }

            /* The refresh separates panes by shade only; flat panes need a rule. */
            :is([class^="sidebarList_"], [class*=" sidebarList_"]) {
              border-right: 1px solid ${c.base02} !important;
            }

            /* Collapse the titlebar and float its buttons (inbox) into the right
               end of the channel header, like midnight's titlebar mode. */
            :root,
            body,
            .visual-refresh,
            .refresh-title-bar-small {
              --custom-app-top-bar-height: 0px !important;
            }
            [class^="bar_"]:has(> [class^="trailing_"]) > :not([class^="trailing_"]),
            [class^="trailing_"] > :is(a[href*="support.discord.com"], [class^="winButtons_"]) {
              display: none !important;
            }
            [class^="bar_"] > [class^="trailing_"] {
              position: absolute;
              /* Header is 48px plus a 1px border; 8px matches its right padding. */
              top: 8px;
              right: 8px;
              height: 32px;
              gap: 4px;
              z-index: 1000;
            }
            /* Match the header toolbar's 20px icons on the same 40px pitch. */
            [class^="trailing_"] > div:not([class^="winButtons_"]) {
              display: flex !important;
              align-items: center;
              justify-content: center;
              width: 32px !important;
              height: 32px !important;
            }
            [class^="trailing_"] > div:not([class^="winButtons_"]) svg {
              width: 20px !important;
              height: 20px !important;
            }

            /* Without the titlebar the server list starts at the window edge. */
            nav[class*="guilds_"] {
              border-right: 1px solid ${c.base02} !important;
            }
            nav[class*="guilds_"] [class*="scroller_"] {
              padding-top: 12px !important;
              scrollbar-width: none !important;
            }
            /* Reserve room in the header toolbar for 1-3 floated buttons. */
            body:has([class^="trailing_"] > div:not([class^="winButtons_"]):nth-of-type(1)) {
              --moskas-trailing-width: 44px;
            }
            body:has([class^="trailing_"] > div:not([class^="winButtons_"]):nth-of-type(2)) {
              --moskas-trailing-width: 80px;
            }
            body:has([class^="trailing_"] > div:not([class^="winButtons_"]):nth-of-type(3)) {
              --moskas-trailing-width: 116px;
            }
            [class^="toolbar_"] {
              margin-right: var(--moskas-trailing-width, 0px) !important;
            }

            /* DMs button: logo in canvas colour on the accent background. */
            :is([data-list-item-id="guildsnav___home"][class*="selected_"],
              [data-list-item-id="guildsnav___home"]:hover)
              > [class^="childWrapper_"] {
              color: ${c.base00} !important;
            }

            /* Inbox: canvas colour, outlined so it stands off the chat behind it. */
            div[class^="container_"]:has(> [class^="header_"] [class*="inboxTitle_"]) {
              --background-base-lowest: ${c.base00};
              --background-base-lower: ${c.base00};
              --background-base-low: ${c.base00};
              --background-surface-high: ${c.base00};
              --background-surface-higher: ${c.base00};
              --background-surface-highest: ${c.base00};
              --background-floating: ${c.base00};
              --bg-surface-overlay: ${c.base00};
              --bg-surface-raised: ${c.base00};
              --modal-background: ${c.base00};
              background: ${c.base00} !important;
              border: 1px solid ${c.base03} !important;
              box-shadow: none !important;
            }

            /* Vencord's switches and Discord's own switch indicator colour the
               track and thumb inline instead of reading --switch-* tokens. */
            :is(.vc-switch-container, [class^="switchIndicator_"]) {
              background-color: ${c.base02} !important;
              border: 1px solid ${c.base03} !important;
            }
            :is(.vc-switch-container.vc-switch-checked,
              [class^="switchIndicator_"][style*="88, 101, 242"]) {
              background-color: ${c.base0D} !important;
              border-color: ${c.base0D} !important;
            }
            :is(.vc-switch-slider, [class^="thumb_"]) rect {
              fill: ${c.base04} !important;
              rx: 0 !important;
              ry: 0 !important;
            }
            :is(.vc-switch-checked .vc-switch-slider,
              [class^="switchIndicator_"][style*="88, 101, 242"] [class^="thumb_"]) rect {
              fill: ${c.base00} !important;
            }
            .vc-switch-slider > svg > path {
              fill: ${c.base02} !important;
            }
            .vc-switch-checked .vc-switch-slider > svg > path {
              fill: ${c.base0D} !important;
            }

            ::selection {
              background-color: ${c.base02};
              color: ${c.base05};
            }

            /* Status dots are drawn with literal fills, classic and refresh palettes. */
            :is(svg, rect, path):is([fill="#23a55a"], [fill="#43a25a"]) {
              fill: ${c.base0B} !important;
            }
            :is(svg, rect, path):is([fill="#f0b232"], [fill="#ca9654"]) {
              fill: ${c.base0A} !important;
            }
            :is(svg, rect, path):is([fill="#f23f43"], [fill="#d83a42"]) {
              fill: ${c.base08} !important;
            }
            :is(svg, rect, path):is([fill="#80848e"], [fill="#83838b"]) {
              fill: ${c.base04} !important;
            }
            :is(svg, rect, path):is([fill="#593695"], [fill="#9147ff"]) {
              fill: ${c.base0E} !important;
            }

            /* Code blocks, base16 styling guidelines. */
            .hljs { color: ${c.base05}; }
            .hljs-comment, .hljs-quote, .hljs-meta { color: ${c.base03} !important; }
            .hljs-variable, .hljs-template-variable, .hljs-tag, .hljs-name,
            .hljs-selector-id, .hljs-deletion { color: ${c.base08} !important; }
            .hljs-number, .hljs-literal, .hljs-built_in, .hljs-type,
            .hljs-params, .hljs-link { color: ${c.base09} !important; }
            .hljs-attr, .hljs-attribute, .hljs-selector-class { color: ${c.base0A} !important; }
            .hljs-string, .hljs-symbol, .hljs-bullet, .hljs-addition { color: ${c.base0B} !important; }
            .hljs-regexp, .hljs-selector-pseudo { color: ${c.base0C} !important; }
            .hljs-title, .hljs-section, .hljs-function { color: ${c.base0D} !important; }
            .hljs-keyword, .hljs-selector-tag { color: ${c.base0E} !important; }
            .hljs-subst { color: ${c.base0F} !important; }
          '';
          plugins = {
            anonymiseFileNames.enable = true;
            petpet.enable = true;
            clearUrls.enable = true;
            characterCounter.enable = true;
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
