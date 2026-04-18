{
  flake.homeModules.fuzzel = {
    config = {
      programs.fuzzel = {
        enable = true;
        settings = {
          border.radius = 0;
          main = {
            width = 60;
            inner-pad = 0;
            horizontal-pad = 10;
            vertical-pad = 10;
            line-height = 32;
            lines = 10;
          };
          key-bindings = {
            next = "Down Control+j";
            prev = "Up Control+k";
            next-page = "Shift+j";
            prev-page = "Shift+k";
          };
        };
      };
    };
  };
}
