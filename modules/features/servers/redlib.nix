{
  flake.nixosModules.redlib =
    { config, ... }:
    {
      config = {
        services.redlib = {
          enable = true;
          openFirewall = true;
          port = 3080;
          settings = {
            THEME = "system";
            POST_SORT = "new";
            USE_HLS = "on";
            DISABLE_VISIT_REDDIT_CONFIRMATION = "on";
            ENABLE_RSS = "on";
            FULL_URL = "http://${config.networking.hostName}/r";
          };
        };
      };
    };
}
