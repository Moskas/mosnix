{ inputs, self, ... }:
{
  flake.homeModules.noctalia =
    { config, ... }:
    {
      imports = [
        inputs.noctalia.homeModules.default
        self.homeModules.moskasDesktop
      ];
      config = {
        programs.noctalia-shell = {
          enable = true;
          settings = {
            general = {
              enableShadows = false;
            };
            location = {
              name = "Wrocław, Poland";
            };
            bar = {
              showCapsule = false;
              outerCorners = false;
              position = "${config.moskas.desktop.bar.position}";
              widgets = {
                left = [
                  {
                    id = "ControlCenter";
                    useDistroLogo = true;
                  }
                  {
                    id = "Workspace";
                    labelMode = "none";
                    focusedWorkspaceColor = "none";
                    occupiedWorkspaceColor = "none";
                    emptyWorkspaceColor = "none";
                  }
                ];
                center = [ { id = "MediaMini"; } ];
                right = [
                  { id = "Tray"; }
                  {
                    id = "Volume";
                    displayMode = "Always show";
                  }
                  {
                    id = "Brightness";
                    displayMode = "Always show";
                  }
                  { id = "Network"; }
                  { id = "Battery"; }
                  {
                    formatHorizontal = "ddd, MMM dd HH:mm:ss";
                    formatVertical = "HH mm";
                    id = "Clock";
                    useMonospacedFont = true;
                    usePrimaryColor = true;
                  }
                  {
                    id = "NotificationHistory";
                    showUnreadBadge = true;
                    unreadBadgeColor = "Error";
                  }
                ];
              };
            };
          };
        };
      };
    };
}
