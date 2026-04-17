{
  flake.nixosModules.vaultwarden =
    { config, ... }:
    {
      config = {
        services.vaultwarden = {
          enable = true;
          backupDir = "/var/local/vaultwarden/backup";
          config = {
            DOMAIN = "https://${config.networking.hostName}.local";
            SIGNUPS_ALLOWED = true;
            ROCKET_ADDRESS = "127.0.0.1";
            ROCKET_PORT = 8222;
            ROCKET_LOG = "critical";
          };
        };
      };
    };
}
