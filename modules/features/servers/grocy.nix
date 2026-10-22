{
  flake.nixosModules.grocy = {
    config = {
      services.grocy = {
        enable = true;
        # tsnsrv's `grocy` node preserves the Host header, so the grocy nginx
        # vhost has to carry the tailnet name.
        hostName = "grocy.taila32e5.ts.net";
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
      # nginx only fronts grocy for tsnsrv; keep it off the LAN and tailnet
      services.nginx.defaultListenAddresses = [ "127.0.0.1" ];
    };
  };
}
