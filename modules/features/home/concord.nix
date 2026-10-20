{
  # Concord's built-in theme mostly uses ANSI colours, but a handful of groups
  # hardcode Discord's RGB palette. Remap those onto the terminal's ANSI
  # palette; where ANSI has no equivalent (orange, raised surfaces) fall back
  # to stylix, or to the nearest ANSI colour on hosts without stylix.
  flake.homeModules.concord =
    { config, ... }:
    let
      stylix = config.lib.stylix.colors.withHashtag or null;
      orange = if stylix != null then stylix.base09 else "yellow";
      surface = if stylix != null then stylix.base02 else "dark_gray";
    in
    {
      programs.concord = {
        enable = true;
        themeSettings = {
          highlight = {
            ScrollbarThumb.foreground = "gray";
            PresenceIdle.foreground = "yellow";
            NavigationMentioned.foreground = orange;
            MentionBadge.foreground = orange;
            InlineCode.foreground = orange;
            InlineTimestamp = {
              foreground = "terminal_default";
              background = surface;
            };
            MentionSelf = {
              foreground = "yellow";
              background = surface;
            };
            MentionOther = {
              foreground = "blue";
              background = surface;
            };
            CommandName.foreground = "blue";
            BotBadge = {
              foreground = "black";
              background = "blue";
            };
            UnreadBanner = {
              foreground = "black";
              background = "blue";
            };
            UnreadDivider.foreground = "red";
          };

          ui.border = {
            default = "plain";
            composer = "plain";
            message = "plain";
            forum = "plain";
          };
        };
      };
    };
}
