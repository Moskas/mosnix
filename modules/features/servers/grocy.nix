{
  flake.nixosModules.grocy =
    { config, ... }:
    {
      config = {
        services.grocy = {
          enable = true;
          hostName = "grocy.${config.networking.hostName}";
          nginx.enableSSL = false;
          settings = {
            currency = "PLN";
            culture = "pl";
            calendar = {
              showWeekNumber = true;
              firstDayOfWeek = 1;
            };
          };
        };
      };
    };
}
